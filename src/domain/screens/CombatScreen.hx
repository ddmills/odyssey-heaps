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
import domain.screens.components.CombatantCard;
import domain.screens.components.CrewMemberCard;
import domain.screens.components.EnemyCard;
import domain.ui.Box;
import domain.ui.Button;
import ecs.Entity;
import ecs.Query;
import ecs.components.Combatant;
import ecs.components.CrewMember;
import ecs.components.Health;
import ecs.components.Incapacitated;
import ecs.components.IsDead;
import ecs.components.Level;
import ecs.components.Mob;
import ecs.components.Person;
import ecs.components.Profession;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Tile;
import hxd.Rand;
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
	var gameDice:Array<GameDie>;
	var cardOb:CombatantCard;
	var isTarget:Bool;
};

class CombatScreen extends Screen
{
	var mob:Entity;
	var enemies:Array<Crew>;
	var ob:h2d.Object;
	var diceOb:h2d.Object;
	var mobDiceOb:h2d.Object;
	var rollArea:Box;
	var gameDice:Array<GameDie>;
	var crewQuery:Query;
	var crew:Array<Crew>;
	var turn:Int;
	var rollsRemaining:Int;
	var dieSize:Int = 16 * 3;
	var selectedDiceOb:h2d.Object;
	var rollBtn:Button;
	var turnBtn:Button;
	var comboBtn:Button;
	var rollingPos:IntPoint;
	var mobRollingPos:IntPoint;
	var isPlayerTurn:Bool;
	var mobCombo:DiceCombo;
	var timeout:Timeout;
	var comboTxt:h2d.Text;
	var comboDescTxt:h2d.Text;
	var background:Bitmap;
	var isCombatOver:Bool;

	public function new(mob:Entity)
	{
		this.mob = mob;
		enemies = mob.get(Mob).spawn().map((entity) -> {
			entity: entity,
			gameDice: new Array(),
			cardOb: cast new EnemyCard(entity),
			isTarget: true,
		});

		ob = new h2d.Object();
		diceOb = new h2d.Object();
		mobDiceOb = new h2d.Object();
		background = new h2d.Bitmap();
		diceOb.visible = false;
		selectedDiceOb = new h2d.Object();
		rollBtn = new Button();
		turnBtn = new Button();
		comboBtn = new Button();
		timeout = new Timeout(1.5);
		comboTxt = TextResource.MakeText();
		comboDescTxt = TextResource.MakeText();

		turn = 0;
		rollsRemaining = 0;
		isPlayerTurn = true;
		isCombatOver = false;

		gameDice = new Array();

		crewQuery = new Query({
			all: [CrewMember, Person, Profession, Level]
		});
	}

	public override function onEnter()
	{
		background.tile = Tile.fromColor(0x1a1d22, game.window.width, game.window.height);
		ob.addChild(background);

		rollsRemaining = 3;

		for (enemy in enemies)
		{
			ob.addChild(enemy.cardOb);
		}

		rollBtn.backgroundColor = 0x57723a;
		rollBtn.onClick = (e) -> rollCrewDice();

		turnBtn.backgroundColor = 0x804c36;
		turnBtn.onClick = (e) -> endTurn();

		updateBtns();

		comboTxt.scale(2);
		comboTxt.textAlign = Center;
		comboDescTxt.textAlign = Center;

		rollArea = new Box({
			width: ((512 + 64) / 32).floor(),
			height: ((256 + 64) / 32).floor(),
			size: 16,
			scale: 2,
		});

		rollingPos = new IntPoint(0, 0);
		mobRollingPos = new IntPoint(0, 0);

		enemies.each((enemy) ->
		{
			var dice = enemy.entity.get(Combatant).dice.getSet(1);

			enemy.gameDice = dice.map((die) ->
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
					isRetired: enemy.entity.has(Incapacitated),
					isSpent: false,
					origin: new IntPoint(0, 0),
				};

				return gameDie;
			});
			enemy.cardOb.onClick = (e) -> setTarget(enemy);
		});

		crew = crewQuery.map((entity:Entity) ->
		{
			var lvl = entity.get(Level).lvl;
			var dice = entity.get(Combatant).dice.getSet(lvl);
			var cardOb:CombatantCard = new CrewMemberCard(entity);

			var c = {
				entity: entity,
				gameDice: new Array<GameDie>(),
				cardOb: cardOb,
				isTarget: false,
			};

			c.gameDice = dice.map((die) ->
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
					isRetired: c.entity.has(Incapacitated),
					isSpent: false,
					origin: new IntPoint(0, 0),
				};

				clickSpot.onClick = (e:hxd.Event) -> dieClicked(gameDie);

				return gameDie;
			});

			ob.addChild(c.cardOb);

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
		ob.addChild(comboTxt);
		ob.addChild(comboDescTxt);

		game.render(HUD, ob);

		checkCombatEnd();
	}

	override function onDestroy()
	{
		ob.removeChildren();
		crewQuery.dispose();

		enemies.each((e) ->
		{
			e.entity.destroy();
		});
		enemies = [];
	}

	function renderCrew()
	{
		crew.each((c) ->
		{
			c.cardOb.updateHp();
			c.cardOb.updateDice(c.gameDice);
		});
		enemies.each((enemy) ->
		{
			enemy.cardOb.updateHp();
			enemy.cardOb.updateDice(enemy.gameDice);
		});
	}

	function setTarget(target:Crew)
	{
		enemies.each((enemy) ->
		{
			enemy.isTarget = (enemy == target);
		});
	}

	function updateBtns()
	{
		if (isPlayerTurn)
		{
			rollBtn.visible = true;
			rollBtn.text = 'Roll (${rollsRemaining})';
			turnBtn.visible = true;
			turnBtn.text = 'End turn (${turn})';
		}
		else
		{
			turnBtn.visible = false;
			rollBtn.visible = false;
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
		updateBtns();

		var disc = new PoissonDiscSampler(512 - dieSize * 2, 256 - dieSize * 2, dieSize + 4, (Math.random() * 10000).floor());
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

				gameDie.origin = pos;
				gameDie.isRetired = c.entity.has(Incapacitated);

				if (gameDie.isRetired)
				{
					gameDie.ob.visible = false;
				}

				if (!gameDie.isSpent && !gameDie.isRetired && !gameDie.isSelected)
				{
					gameDie.ob.x = rollingPos.x;
					gameDie.ob.y = rollingPos.y;

					var seed = (Math.random() * 10000).floor();
					gameDie.roll = gameDie.die.roll(seed);
					gameDie.ob.tile = TileResources.getDie(gameDie.roll.value);
				}
			}
			c.cardOb.updateDice(c.gameDice);
		}
	}

	function rollMobDice()
	{
		mobDiceOb.visible = true;

		var disc = new PoissonDiscSampler(512 - dieSize, 256 - dieSize, dieSize + 12, (Math.random() * 10000).floor());
		for (enemy in enemies)
		{
			for (gameDie in enemy.gameDice)
			{
				var pos = disc.sample();
				if (pos == null)
				{
					pos = {
						x: (Math.random() * 256).floor(),
						y: (Math.random() * 256).floor(),
					};
				}

				gameDie.origin = pos;
				gameDie.isRetired = enemy.entity.has(Incapacitated);

				if (gameDie.isRetired)
				{
					gameDie.ob.visible = false;
				}

				if (!gameDie.isSpent && !gameDie.isRetired && !gameDie.isSelected)
				{
					gameDie.ob.x = mobRollingPos.x;
					gameDie.ob.y = mobRollingPos.y;

					var seed = (Math.random() * 10000).floor();
					gameDie.roll = gameDie.die.roll(seed);
					gameDie.ob.tile = TileResources.getDie(gameDie.roll.value);
				}
			}
		}
		renderCrew();
		timeout.onComplete = () -> mobTurn();
		timeout.reset();
	}

	function endMobTurn()
	{
		enemies.each((enemy) ->
		{
			enemy.gameDice.each((die) ->
			{
				die.isSpent = false;
				die.isSelected = false;
				die.roll = null;
				die.ob.visible = !die.isRetired;
				die.ob.x = mobRollingPos.x;
				die.ob.y = mobRollingPos.y;
			});
			enemy.cardOb.updateHp();
			enemy.cardOb.updateDice(enemy.gameDice);
		});
		isPlayerTurn = true;
		updateBtns();
		checkCombatEnd();
	}

	function endTurn()
	{
		if (!isPlayerTurn)
		{
			return;
		}

		turn++;
		diceOb.visible = false;

		crew.each((c) ->
		{
			c.gameDice.each((die) ->
			{
				die.isSpent = false;
				die.isSelected = false;
				die.ob.visible = !die.isRetired;
				die.roll = null;
				die.ob.x = rollingPos.x;
				die.ob.y = rollingPos.y;
			});
		});

		rollsRemaining = 3;
		rollBtn.text = 'Roll (${rollsRemaining} remaining)';
		crew.each((c) -> c.cardOb.updateDice(c.gameDice));
		updateCombo();
		isPlayerTurn = false;
		updateBtns();
		checkCombatEnd();

		if (!isCombatOver)
		{
			rollMobDice();
		}
	}

	function mobTurn()
	{
		var combos = mob.get(Mob).combos;
		var availableDice = enemies.flatMap((m) -> m.gameDice)
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

		showComboText(mobCombo);

		timeout.onComplete = () -> applyMobCombo();
		timeout.reset();
		renderCrew();
	}

	function showComboText(combo:DiceCombo)
	{
		comboTxt.text = combo.title;
		comboDescTxt.text = combo.description;
		comboTxt.visible = true;
		comboDescTxt.visible = true;
	}

	function hideComboText()
	{
		comboTxt.text = '';
		comboDescTxt.text = '';
		comboTxt.visible = true;
		comboDescTxt.visible = true;
	}

	function applyMobCombo()
	{
		enemies.flatMap((e) -> e.gameDice)
			.filter((d) -> d.isSelected)
			.each((d) ->
			{
				d.isSpent = true;
				d.isSelected = false;
				d.ob.visible = false;
			});

		var r = Rand.create();
		r.pick(crew).isTarget = true;

		mobCombo.apply(crew, enemies);
		mobCombo = null;

		crew.each((c) -> c.isTarget = false);
		hideComboText();

		renderCrew();
		mobTurn();
	}

	function updateCombo()
	{
		selectedDiceOb.removeChildren();
		comboBtn.visible = false;
		hideComboText();

		var selected = crew.flatMap((c) -> c.gameDice).filter((d) -> d.isSelected).map((d) -> d.roll.value);

		for (combo in DiceCombos.PLAYER)
		{
			if (!combo.appliesTo(selected))
			{
				continue;
			}

			var comboTxt = TextResource.MakeText();
			comboTxt.text = combo.title;
			showComboText(combo);

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
				combo.apply(enemies, crew);

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
		background.tile = Tile.fromColor(0x1a1d22, game.window.width, game.window.height);

		var rollAreaWidth = 512;
		var rollAreaHeight = 256;

		rollArea.x = (game.window.width / 2) - (rollAreaWidth / 2);
		rollArea.y = (game.window.height - rollAreaHeight - dieSize) - 32;

		var rx = rollArea.x.floor();
		var ry = (rollArea.y + rollAreaHeight / 2).floor();

		rollingPos = new IntPoint(rx, ry);
		mobRollingPos = new IntPoint(rx + rollAreaWidth, ry);

		rollBtn.x = rx - 180 - 64;
		rollBtn.y = ry - 32;
		rollBtn.width = 180;
		rollBtn.height = 64;

		turnBtn.x = rx + 512 + 64;
		turnBtn.y = ry - 32;
		turnBtn.width = 180;
		turnBtn.height = 64;

		comboBtn.x = (game.window.width / 2) - (comboBtn.width / 2);
		comboBtn.y = rollArea.y - (comboBtn.height + (dieSize / 2));

		comboTxt.x = (game.window.width / 2);
		comboTxt.y = 64;

		comboDescTxt.x = (game.window.width / 2);
		comboDescTxt.y = 120;

		var selectedBounds = selectedDiceOb.getBounds();
		selectedDiceOb.x = (game.window.width / 2) - (selectedBounds.width / 2);
		selectedDiceOb.y = comboBtn.y - (dieSize + comboBtn.height);

		crew.each((c, i) ->
		{
			c.cardOb.x = 8;
			c.cardOb.y = 120 * i + ((i + 1) * 8);
		});
		enemies.each((e, i) ->
		{
			e.cardOb.x = game.window.width - 8 - 320;
			e.cardOb.y = 120 * i + ((i + 1) * 8);
		});
	}

	function checkCombatEnd()
	{
		if (enemies.every((e) -> e.entity.get(Health).current <= 0))
		{
			isCombatOver = true;
			mob.add(new IsDead());
			game.screens.pop();
		}

		if (crew.every((c) -> c.entity.get(Health).current <= 0))
		{
			isCombatOver = true;
			game.screens.pop();
		}
	}

	override function update(frame:Frame)
	{
		var crewDice = crew.flatMap((c) -> c.gameDice);
		var numSelected = crewDice.filter((d) -> d.isSelected).count();
		var center = (game.window.width / 2).floor();
		var width = (numSelected * dieSize) + ((numSelected - 1) * 8);
		var left = center - width / 2;
		var diceY = comboBtn.y - (dieSize + dieSize / 2);

		var x = 0;
		crewDice.each((die) ->
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
					x: rollArea.x + die.origin.x + 32,
					y: rollArea.y + die.origin.y + 32,
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

		var enemyDice = enemies.flatMap((e) -> e.gameDice);
		var numEnemyDiceSelected = enemyDice.filter((d) -> d.isSelected).count();
		var mobWidth = (numEnemyDiceSelected * dieSize) + ((numEnemyDiceSelected - 1) * 8);
		var mobLeft = center - mobWidth / 2;

		x = 0;
		enemyDice.each((die) ->
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
					x: rollArea.x + die.origin.x + 32,
					y: rollArea.y + die.origin.y + 32,
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

		world.updateSystems();
	}
}
