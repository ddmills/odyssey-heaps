package domain.screens;

import common.struct.FloatPoint;
import common.struct.IntPoint;
import common.util.Timeout;
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

class CombatScreen extends Screen
{
	var mobs:Array<Crew>;
	var ob:h2d.Object;
	var diceOb:h2d.Object;
	var mobDiceOb:h2d.Object;
	var rollArea:h2d.Object;
	var gameDice:Array<GameDie>;
	var crewQuery:Query;
	var crew:Array<Crew>;
	var turn:Int;
	var rollsRemaining:Int;
	var dieSize:Int = 64;
	var selectedDiceOb:h2d.Object;
	var rollBtn:Button;
	var turnBtn:Button;
	var comboBtn:Button;
	var rollingPos:IntPoint;
	var mobRollingPos:IntPoint;
	var isPlayerTurn:Bool;
	var mobCombo:DiceCombo;
	var timeout:Timeout;

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
		selectedDiceOb = new h2d.Object();
		rollBtn = new Button();
		turnBtn = new Button();
		comboBtn = new Button();
		timeout = new Timeout(1);

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

		for (mob in mobs)
		{
			ob.addChild(mob.hpOb);
		}

		rollBtn.text = 'Roll (${rollsRemaining})';
		rollBtn.backgroundColor = 0x57723a;
		rollBtn.onClick = (e) -> rollCrewDice();

		turnBtn.text = 'End turn (${turn})';
		turnBtn.backgroundColor = 0x804c36;
		turnBtn.onClick = (e) -> endTurn();

		rollArea = new Bitmap(h2d.Tile.fromColor(0x333333, 512, 256));

		rollingPos = new IntPoint(0, 0);
		mobRollingPos = new IntPoint(0, 0);

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

		ob.addChild(selectedDiceOb);
		ob.addChild(rollArea);
		ob.addChild(diceOb);
		ob.addChild(mobDiceOb);
		ob.addChild(rollBtn);
		ob.addChild(turnBtn);
		ob.addChild(comboBtn);

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

		var disc = new PoissonDiscSampler(512 - dieSize, 256 - dieSize, dieSize + 4, (Math.random() * 10000).floor());
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

		var disc = new PoissonDiscSampler(512 - dieSize, 256 - dieSize, dieSize + 12, (Math.random() * 10000).floor());
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
		timeout.onComplete = () -> mobTurn();
		timeout.reset();
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
	}

	function mobTurn()
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
			mobDiceOb.visible = false;
			endMobTurn();
			return;
		}

		mobCombo = valid.max((c) -> c.faces.length);
		for (face in mobCombo.faces)
		{
			var die = availableDice.find((d) -> d.roll.value == face);
			die.isSelected = true;
		}
		timeout.onComplete = () -> applyMobCombo();
		timeout.reset();
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

		renderCrew();
		mobTurn();
	}

	function updateCombo()
	{
		selectedDiceOb.removeChildren();
		comboBtn.visible = false;

		var selected = crew.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).map((d) -> d.roll.value);

		for (combo in DiceCombos.PLAYER)
		{
			if (!combo.appliesTo(selected))
			{
				continue;
			}

			var comboTxt = TextResource.MakeText();
			comboTxt.text = combo.title;

			comboBtn.visible = true;
			comboBtn.backgroundColor = 0x57723a;
			comboBtn.width = (comboTxt.textWidth + dieSize).floor();
			comboBtn.height = dieSize;
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

			break;
		}
	}

	function dieClicked(die:GameDie)
	{
		die.isSelected = !die.isSelected;

		updateCombo();
	}

	function repositionHud()
	{
		var rollAreaWidth = 512;
		var rollAreaHeight = 256;

		rollArea.x = (game.window.width / 2) - (rollAreaWidth / 2);
		rollArea.y = game.window.height - rollAreaHeight - dieSize;

		var rx = rollArea.x.floor();
		var ry = (rollArea.y + rollAreaHeight / 2).floor();

		rollingPos = new IntPoint(rx, ry);
		mobRollingPos = new IntPoint(rx + rollAreaWidth, ry);

		rollBtn.x = rx - 128 - 64;
		rollBtn.y = ry - 32;
		rollBtn.width = 128;
		rollBtn.height = 64;

		turnBtn.x = rx + 512 + 64;
		turnBtn.y = ry - 32;
		turnBtn.width = 128;
		turnBtn.height = 64;

		comboBtn.x = (game.window.width / 2) - (comboBtn.width / 2);
		comboBtn.y = rollArea.y - (comboBtn.height + (dieSize / 2));

		var selectedBounds = selectedDiceOb.getBounds();
		selectedDiceOb.x = (game.window.width / 2) - (selectedBounds.width / 2);
		selectedDiceOb.y = comboBtn.y - (dieSize + comboBtn.height);
	}

	override function update(frame:Frame)
	{
		var x = 0;
		var numSelected = crew.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).count();
		var center = (game.window.width / 2).floor();
		var width = (numSelected * dieSize) + ((numSelected - 1) * 8);
		var left = center - width / 2;
		var diceY = comboBtn.y - (dieSize + dieSize / 2);

		crew.flatMap((c) -> c.gameDice).each((die) ->
		{
			var pos:FloatPoint = null;
			if (die.isSelected)
			{
				pos = {
					x: left + (x * (dieSize + 8)),
					y: diceY,
				};
				x++;
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

		var numMobSelected = mobs.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).count();
		var mobWidth = (numMobSelected * dieSize) + ((numMobSelected - 1) * 8);
		var mobLeft = center - mobWidth / 2;

		x = 0;
		mobs.flatMap((m) -> m.gameDice).each((die) ->
		{
			var pos:FloatPoint = null;
			if (die.isSelected)
			{
				pos = {
					x: mobLeft + (x * (dieSize + 8)),
					y: diceY
				};
				x++;
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
			var newpos = cur.lerp(pos, frame.tmod * .4);

			die.ob.x = newpos.x;
			die.ob.y = newpos.y;
		});

		repositionHud();

		timeout.update();
	}
}
