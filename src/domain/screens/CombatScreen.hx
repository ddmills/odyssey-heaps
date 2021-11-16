package domain.screens;

import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import data.DiceCombos;
import data.DieRoll;
import data.TextResource;
import data.TileResources;
import ecs.Entity;
import ecs.Query;
import ecs.components.CrewMember;
import ecs.components.Health;
import ecs.components.Level;
import ecs.components.Person;
import ecs.components.Profession;
import h2d.Bitmap;
import h2d.Interactive;
import rand.PoissonDiscSampler;

typedef GameDie =
{
	var roll:DieRoll;
	var ob:Bitmap;
	var isSelected:Bool;
	var isRetired:Bool;
	var isSpent:Bool;
	var origin:IntPoint;
};

typedef Crew =
{
	var entity:Entity;
	var hpOb:h2d.Object;
};

class CombatScreen extends Screen
{
	var mobs:Array<Crew>;
	var ob:h2d.Object;
	var rollArea:h2d.Object;
	var gameDice:Array<GameDie>;
	var crewQuery:Query;
	var crew:Array<Crew>;
	var turn:Int;
	var dieSize:Int = 64;
	var comboOb:h2d.Object;

	public function new(mob:Entity)
	{
		mobs = [
			{
				entity: mob,
				hpOb: new h2d.Object()
			}
		];
		ob = new h2d.Object();
		comboOb = new h2d.Object();
		turn = 0;

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

		crew = crewQuery.map((entity) ->
		{
			var c = {
				entity: entity,
				hpOb: new h2d.Object(),
			};

			ob.addChild(c.hpOb);

			return c;
		});

		for (mob in mobs)
		{
			ob.addChild(mob.hpOb);
		}

		var rollAreaSize = 256 + dieSize;

		var rollTxt = TextResource.MakeText();
		rollTxt.text = 'Roll';
		rollTxt.alignCenter;
		rollTxt.x = 128;
		rollTxt.y = 8;

		var rollBtn = new Bitmap(h2d.Tile.fromColor(0x57723a, rollAreaSize, 32));
		rollBtn.x = 0;
		rollBtn.y = 512 + dieSize;

		var rollBtnInt = new Interactive(rollAreaSize, 32);
		rollBtnInt.onClick = (e) -> rollCrewDice();
		rollBtn.addChild(rollBtnInt);
		rollBtn.addChild(rollTxt);

		rollArea = new Bitmap(h2d.Tile.fromColor(0x1b1f23, rollAreaSize, rollAreaSize));
		rollArea.x = 0;
		rollArea.y = 256;

		renderCrew();

		ob.addChild(comboOb);
		ob.addChild(rollArea);
		ob.addChild(rollBtn);

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
		for (die in gameDice)
		{
			die.ob.remove();
		}
		gameDice = new Array();

		var disc = new PoissonDiscSampler(256, 256, dieSize + 12, turn);
		for (c in crew)
		{
			var lvl = c.entity.get(Level).lvl;
			var dice = c.entity.get(Profession).data.dice;
			var rolls = dice.roll(lvl, (Math.random() * 10000).floor());
			var pos = disc.sample();

			if (pos == null)
			{
				pos = {
					x: (Math.random() * 256).floor(),
					y: (Math.random() * 256).floor(),
				};
			}

			for (roll in rolls)
			{
				renderDie(pos, roll);
			}
		}

		turn++;
	}

	function renderDie(pos:IntPoint, roll:DieRoll)
	{
		var tile = TileResources.getDie(roll.value);
		var bm = new Bitmap(tile);
		bm.scale(dieSize / 16);
		bm.x = rollArea.x + 128;
		bm.y = rollArea.y + 256 + dieSize / 2;

		var clickSpot = new h2d.Interactive(16, 16);
		bm.addChild(clickSpot);
		clickSpot.x = 0;
		clickSpot.y = 0;

		var gameDie = {
			roll: roll,
			ob: bm,
			isSelected: false,
			isRetired: false,
			isSpent: false,
			origin: pos,
		};

		clickSpot.onClick = (e:hxd.Event) -> dieClicked(gameDie);

		gameDice.push(gameDie);

		ob.addChild(bm);
	}

	function updateCombo()
	{
		comboOb.removeChildren();

		var selected = gameDice.filter((d) -> d.isSelected).map((d) -> d.roll.value);

		for (combo in DiceCombos.PLAYER)
		{
			if (combo.appliesTo(selected))
			{
				var comboTxt = TextResource.MakeText();
				comboTxt.text = combo.title;
				comboTxt.alignCenter;
				comboTxt.x = 8;
				comboTxt.y = 8;

				var comboAreaSize = (comboTxt.textWidth + 16).floor();

				var comboBtn = new Bitmap(h2d.Tile.fromColor(0x57723a, comboAreaSize, 32));

				var comboBtnInt = new Interactive(comboAreaSize, 32);
				comboBtnInt.onClick = (evt) ->
				{
					gameDice.filter((d) -> d.isSelected).each((d, idx) ->
					{
						d.isSpent = true;
						d.isSelected = false;
						d.ob.visible = false;
						updateCombo();
					});
					combo.apply(mobs);
					renderCrew();
				}

				comboBtn.addChild(comboBtnInt);
				comboBtn.addChild(comboTxt);

				comboOb.x = 512;
				comboOb.y = 128;
				comboOb.addChild(comboBtn);
				break;
			}
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
		for (die in gameDice)
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
		}
	}
}
