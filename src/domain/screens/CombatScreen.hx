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
	var origin:IntPoint;
};

class CombatScreen extends Screen
{
	var mob:Entity;
	var ob:h2d.Object;
	var rollArea:h2d.Object;
	var gameDice:Array<GameDie>;
	var crewQuery:Query;
	var turn:Int;
	var dieSize:Int = 64;
	var comboOb:h2d.Object;

	public function new(mob:Entity)
	{
		this.mob = mob;
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

		ob.addChild(comboOb);
		ob.addChild(rollArea);
		ob.addChild(rollBtn);

		game.render(HUD, ob);
	}

	function rollCrewDice()
	{
		for (die in gameDice)
		{
			die.ob.remove();
		}
		gameDice = new Array();

		var disc = new PoissonDiscSampler(256, 256, dieSize + 12, turn);
		for (e in crewQuery)
		{
			var lvl = e.get(Level).lvl;
			var dice = e.get(Profession).data.dice;
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
			origin: pos,
		};

		clickSpot.onClick = (e:hxd.Event) -> dieClicked(gameDie);

		gameDice.push(gameDie);

		ob.addChild(bm);
	}

	function dieClicked(die:GameDie)
	{
		comboOb.removeChildren();
		die.isSelected = !die.isSelected;

		var selected = gameDice.filter((d) -> d.isSelected).map((d) -> d.roll.value);

		for (combo in DiceCombos.PLAYER)
		{
			if (combo.appliesTo(selected))
			{
				trace('COMBO APPLIES!', combo.title);

				var comboTxt = TextResource.MakeText();
				comboTxt.text = combo.title;
				comboTxt.alignCenter;
				comboTxt.x = 8;
				comboTxt.y = 8;

				var comboAreaSize = (comboTxt.textWidth + 16).floor();

				var comboBtn = new Bitmap(h2d.Tile.fromColor(0x57723a, comboAreaSize, 32));

				var comboBtnInt = new Interactive(comboAreaSize, 32);
				comboBtnInt.onClick = (e) -> combo.apply();

				comboBtn.addChild(comboBtnInt);
				comboBtn.addChild(comboTxt);

				comboOb.x = 512;
				comboOb.y = 128;
				comboOb.addChild(comboBtn);
				break;
			}
		}
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
