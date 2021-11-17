package domain.screens;

import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import data.DiceCombos;
import data.DieRoll;
import data.TextResource;
import data.TileResources;
import domain.combat.dice.DiceCombo;
import domain.combat.dice.Die;
import domain.ui.Button;
import ecs.Entity;
import ecs.Query;
import ecs.components.CrewMember;
import ecs.components.Health;
import ecs.components.Level;
import ecs.components.Mob;
import ecs.components.Person;
import ecs.components.Profession;
import h2d.Bitmap;
import h2d.Interactive;
import rand.PoissonDiscSampler;

typedef GameDie =
{
	var roll:DieRoll;
	var ob:Bitmap;
	var die:Die;
	var isSelected:Bool;
	var isRetired:Bool;
	var isSpent:Bool;
	var origin:IntPoint;
};

typedef Crew =
{
	var entity:Entity;
	var hpOb:h2d.Object;
	var gameDice:Array<GameDie>;
};

enum MobStage
{
	ROLLING;
	SELECTING;
	EXECUTING;
	DONE;
}

class CombatScreen extends Screen
{
	var mobs:Array<Crew>;
	var ob:h2d.Object;
	var diceOb:h2d.Object;
	var mobDiceOb:h2d.Object;
	var rollArea:h2d.Object;
	var mobRollArea:h2d.Object;
	var gameDice:Array<GameDie>;
	var crewQuery:Query;
	var crew:Array<Crew>;
	var turn:Int;
	var rollsRemaining:Int;
	var dieSize:Int = 64;
	var comboInfoOb:h2d.Object;
	var rollBtn:Button;
	var turnBtn:Button;
	var rollingPos:IntPoint;
	var mobRollingPos:IntPoint;
	var isPlayerTurn:Bool;
	var mobStage:MobStage;
	var lastMobAction:Float;
	var mobCombo:DiceCombo;

	public function new(mob:Entity)
	{
		mobs = [
			{
				entity: mob,
				hpOb: new h2d.Object(),
				gameDice: new Array()
			}
		];
		ob = new h2d.Object();
		diceOb = new h2d.Object();
		mobDiceOb = new h2d.Object();
		diceOb.visible = false;
		comboInfoOb = new h2d.Object();
		rollBtn = new Button();
		turnBtn = new Button();
		mobStage = DONE;

		turn = 0;
		rollsRemaining = 0;
		isPlayerTurn = true;

		gameDice = new Array();

		crewQuery = new Query({
			all: [CrewMember, Person, Profession, Level]
		});
	}

	public override function onEnter()
	{
		var bg = new h2d.Bitmap(TileResources.VIGNETTE_WATER);
		bg.scale(3);
		ob.addChild(bg);

		rollsRemaining = 3;
		lastMobAction = 0;

		for (mob in mobs)
		{
			ob.addChild(mob.hpOb);
		}

		var rollAreaSize = 256 + dieSize;

		rollBtn.text = 'Roll (${rollsRemaining})';
		rollBtn.width = rollAreaSize;
		rollBtn.height = 32;
		rollBtn.x = 0;
		rollBtn.y = 512 + dieSize;
		rollBtn.backgroundColor = 0x57723a;
		rollBtn.onClick = (e) -> rollCrewDice();

		turnBtn.text = 'End turn (${turn})';
		turnBtn.width = rollAreaSize;
		turnBtn.height = 32;
		turnBtn.x = 0;
		turnBtn.y = 512 + dieSize + 32;
		turnBtn.backgroundColor = 0x804c36;
		turnBtn.onClick = (e) -> endTurn();

		rollArea = new Bitmap(h2d.Tile.fromColor(0x1b1f23, rollAreaSize, rollAreaSize));
		rollArea.x = 0;
		rollArea.y = 256;

		mobRollArea = new Bitmap(h2d.Tile.fromColor(0x333333, rollAreaSize, rollAreaSize));
		mobRollArea.x = game.camera.width - rollAreaSize;
		mobRollArea.y = 256;

		rollingPos = new IntPoint((rollArea.x + 128).floor(), (rollArea.y + 256 + dieSize / 2).floor());
		mobRollingPos = new IntPoint((mobRollArea.x + 128).floor(), (mobRollArea.y + 256 + dieSize / 2).floor());

		mobs.each((mob) ->
		{
			var dice = mob.entity.get(Mob).dice.getSet(1);

			mob.gameDice = dice.map((die) ->
			{
				var bm = new h2d.Bitmap();
				bm.scale(dieSize / 16);
				bm.x = rollingPos.x;
				bm.y = rollingPos.y;

				mobDiceOb.addChild(bm);

				var gameDie = {
					roll: null,
					die: die,
					ob: bm,
					isSelected: false,
					isRetired: false,
					isSpent: false,
					origin: new IntPoint(0, 0),
				};

				return gameDie;
			});
		});

		crew = crewQuery.map((entity) ->
		{
			var lvl = entity.get(Level).lvl;
			var dice = entity.get(Profession).data.dice.getSet(lvl);

			var gameDice = dice.map((die) ->
			{
				var bm = new h2d.Bitmap();
				bm.scale(dieSize / 16);
				bm.x = rollingPos.x;
				bm.y = rollingPos.y;

				var clickSpot = new h2d.Interactive(16, 16);
				clickSpot.x = 0;
				clickSpot.y = 0;

				bm.addChild(clickSpot);
				diceOb.addChild(bm);

				var gameDie = {
					roll: null,
					die: die,
					ob: bm,
					isSelected: false,
					isRetired: false,
					isSpent: false,
					origin: new IntPoint(0, 0),
				};

				clickSpot.onClick = (e:hxd.Event) -> dieClicked(gameDie);

				return gameDie;
			});

			var c = {
				entity: entity,
				hpOb: new h2d.Object(),
				gameDice: gameDice
			};

			ob.addChild(c.hpOb);

			return c;
		});

		renderCrew();

		ob.addChild(comboInfoOb);
		ob.addChild(rollArea);
		ob.addChild(mobRollArea);
		ob.addChild(diceOb);
		ob.addChild(mobDiceOb);
		ob.addChild(rollBtn);
		ob.addChild(turnBtn);

		game.render(HUD, ob);
	}

	function renderCrew()
	{
		var x = 0;
		for (c in crew)
		{
			c.hpOb.removeChildren();

			var health = c.entity.get(Health);
			var txt = TextResource.MakeText();
			txt.text = '${health.current}/${health.max}';
			txt.dropShadow = null;
			txt.color = 0x57723a.toHxdColor();

			txt.x = 256 + 32 * x;
			txt.y = 32;

			c.hpOb.addChild(txt);

			x++;
		}

		x = 0;
		for (mob in mobs)
		{
			mob.hpOb.removeChildren();

			var health = mob.entity.get(Health);
			var txt = TextResource.MakeText();
			txt.text = '${health.current}/${health.max}';
			txt.dropShadow = null;
			txt.color = 0x57723a.toHxdColor();

			txt.x = 800 + 32 * x;
			txt.y = 32;

			mob.hpOb.addChild(txt);

			x++;
		}
	}

	function rollCrewDice()
	{
		if (rollsRemaining <= 0 || !isPlayerTurn)
		{
			return;
		}

		diceOb.visible = true;
		rollsRemaining--;
		rollBtn.text = 'Roll (${rollsRemaining})';

		var disc = new PoissonDiscSampler(256, 256, dieSize + 12, (Math.random() * 10000).floor());
		for (c in crew)
		{
			for (gameDie in c.gameDice)
			{
				var pos = disc.sample();
				if (pos == null)
				{
					pos = {
						x: (Math.random() * 256).floor(),
						y: (Math.random() * 256).floor(),
					};
				}

				if (!gameDie.isSpent && !gameDie.isRetired && !gameDie.isSelected)
				{
					gameDie.ob.x = rollingPos.x;
					gameDie.ob.y = rollingPos.y;

					var seed = (Math.random() * 10000).floor();
					gameDie.roll = gameDie.die.roll(seed);
					gameDie.origin = pos;
					gameDie.ob.tile = TileResources.getDie(gameDie.roll.value);
				}
			}
		}
	}

	function rollMobDice()
	{
		mobDiceOb.visible = true;
		mobStage = SELECTING;
		lastMobAction = game.frame.tick;

		var disc = new PoissonDiscSampler(256, 256, dieSize + 12, (Math.random() * 10000).floor());
		for (m in mobs)
		{
			for (gameDie in m.gameDice)
			{
				var pos = disc.sample();
				if (pos == null)
				{
					pos = {
						x: (Math.random() * 256).floor(),
						y: (Math.random() * 256).floor(),
					};
				}

				if (!gameDie.isSpent && !gameDie.isRetired && !gameDie.isSelected)
				{
					gameDie.ob.x = mobRollingPos.x;
					gameDie.ob.y = mobRollingPos.y;

					var seed = (Math.random() * 10000).floor();
					gameDie.roll = gameDie.die.roll(seed);
					gameDie.origin = pos;
					gameDie.ob.tile = TileResources.getDie(gameDie.roll.value);
				}
			}
		}
	}

	function endMobTurn()
	{
		mobs.flatMap((m) -> m.gameDice).each((die) ->
		{
			die.isSpent = false;
			die.isSelected = false;
			die.ob.visible = true;
			die.ob.x = mobRollingPos.x;
			die.ob.y = mobRollingPos.y;
		});
		isPlayerTurn = true;
	}

	function endTurn()
	{
		if (!isPlayerTurn)
		{
			return;
		}

		turn++;
		turnBtn.text = 'End turn (${turn})';
		diceOb.visible = false;

		crew.flatMap((c) -> c.gameDice).each((die) ->
		{
			die.isSpent = false;
			die.isSelected = false;
			die.ob.visible = true;
			die.ob.x = rollingPos.x;
			die.ob.y = rollingPos.y;
		});

		rollsRemaining = 3;
		rollBtn.text = 'Roll (${rollsRemaining})';
		updateCombo();
		isPlayerTurn = false;

		rollMobDice();
		mobTurn();
	}

	function mobTurn()
	{
		if (mobStage == SELECTING)
		{
			var combos = mobs[0].entity.get(Mob).combos;
			var availableDice = mobs.flatMap((m) -> m.gameDice)
				.filter((d) -> !d.isRetired && !d.isSpent);

			var availableFaces = availableDice.map((d) -> d.roll.value);

			// for each combo, check if we have the dice
			var valid = combos.filter((combo) ->
			{
				var clone = availableFaces.copy();

				for (face in combo.faces)
				{
					if (!clone.contains(face))
					{
						return false;
					}

					clone.remove(face);
				}

				return true;
			});

			if (valid.length == 0)
			{
				mobStage = DONE;
				mobDiceOb.visible = false;
				endMobTurn();
				return;
			}

			mobCombo = valid.max((c) -> c.faces.length);
			trace('combo', turn, mobCombo);
			for (face in mobCombo.faces)
			{
				var die = availableDice.find((d) -> d.roll.value == face);
				die.isSelected = true;
			}
			applyMobCombo();
		}
	}

	function applyMobCombo()
	{
		mobs.flatMap((m) -> m.gameDice)
			.filter((d) -> d.isSelected)
			.each((d) ->
			{
				d.isSpent = true;
				d.isSelected = false;
				d.ob.visible = false;
			});
		mobCombo.apply(crew);
		mobCombo = null;
		mobStage = SELECTING;
		renderCrew();
		mobTurn();
	}

	function updateCombo()
	{
		comboInfoOb.removeChildren();

		var selected = crew.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).map((d) -> d.roll.value);

		for (combo in DiceCombos.PLAYER)
		{
			if (!combo.appliesTo(selected))
			{
				continue;
			}

			var comboTxt = TextResource.MakeText();
			comboTxt.text = combo.title;
			var comboAreaSize = (comboTxt.textWidth + 16).floor();

			var comboBtn = new Button();
			comboBtn.backgroundColor = 0x57723a;
			comboBtn.width = comboAreaSize;
			comboBtn.height = 32;
			comboBtn.text = combo.title;
			comboBtn.onClick = (evt) ->
			{
				crew.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).each((d, idx) ->
				{
					d.isSpent = true;
					d.isSelected = false;
					d.ob.visible = false;
					updateCombo();
				});
				combo.apply(mobs);
				renderCrew();
			}

			comboInfoOb.x = 512;
			comboInfoOb.y = 128;
			comboInfoOb.addChild(comboBtn);
			break;
		}
	}

	function dieClicked(die:GameDie)
	{
		die.isSelected = !die.isSelected;

		updateCombo();
	}

	override function update(frame:Frame)
	{
		var x = 0;
		crew.flatMap((c) -> c.gameDice).each((die) ->
		{
			var pos:FloatPoint = null;
			if (die.isSelected)
			{
				pos = {
					x: (x++ * dieSize) + 8,
					y: dieSize,
				};
			}
			else
			{
				pos = {
					x: rollArea.x + die.origin.x,
					y: rollArea.y + die.origin.y,
				};
			}
			var cur:FloatPoint = {
				x: die.ob.x,
				y: die.ob.y,
			};
			var newpos = cur.lerp(pos, frame.tmod * .2);

			die.ob.x = newpos.x;
			die.ob.y = newpos.y;
		});

		x = 0;
		mobs.flatMap((m) -> m.gameDice).each((die) ->
		{
			var pos:FloatPoint = null;
			if (die.isSelected)
			{
				pos = {
					x: ((x++ * dieSize) + 8),
					y: dieSize,
				};
			}
			else
			{
				pos = {
					x: mobRollArea.x + die.origin.x,
					y: mobRollArea.y + die.origin.y,
				};
			}
			var cur:FloatPoint = {
				x: die.ob.x,
				y: die.ob.y,
			};
			var newpos = cur.lerp(pos, frame.tmod * .2);

			die.ob.x = newpos.x;
			die.ob.y = newpos.y;
		});

		// if (!isPlayerTurn)
		// {
		// 	frame.elapsed;
		// }
		// if mobs turn...
		// roll dice
	}
}
