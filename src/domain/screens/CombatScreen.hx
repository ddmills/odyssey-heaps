package domain.screens;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import data.Dice;
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
	var die:Dice;
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

	public function new(mob:Entity)
	{
		this.mob = mob;
		ob = new h2d.Object();
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

		var rolls = crewQuery.flatMap((e) ->
		{
			var lvl = e.get(Level).lvl;
			return e.get(Profession).data.dice.roll(lvl);
		});

		var disc = new PoissonDiscSampler(256, 256, dieSize, turn);

		for (die in rolls)
		{
			var pos = disc.sample();
			renderDie(pos, die);
		};

		turn++;
	}

	function renderDie(pos:IntPoint, die:Dice)
	{
		var tile = TileResources.getDie(die);
		var bm = new Bitmap(tile);
		bm.scale(dieSize / 16);
		bm.x = rollArea.x + pos.x;
		bm.y = rollArea.y + pos.y;

		var clickSpot = new h2d.Interactive(16, 16);
		bm.addChild(clickSpot);
		clickSpot.x = 0;
		clickSpot.y = 0;

		var gameDie = {
			die: die,
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
		trace('clicked die', die);
		die.isSelected = !die.isSelected;
		renderSelectedDice();
	}

	function renderSelectedDice() {}

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
