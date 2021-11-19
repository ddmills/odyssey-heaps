package domain.screens.components;

import data.DieFace;
import data.TextResource;
import data.TileResources;
import domain.screens.CombatScreen.GameDie;
import ecs.Entity;
import ecs.components.Health;
import ecs.components.Level;
import ecs.components.Person;
import ecs.components.Profession;
import h2d.Bitmap;
import h2d.Object;
import h2d.Text;
import h2d.Tile;

class CrewMemberCard extends h2d.Object
{
	var entity:Entity;

	var avatarOb:h2d.Bitmap;
	var backgroundOb:h2d.Bitmap;
	var diceOb:h2d.Object;
	var nameTxt:Text;
	var lvlTxt:Text;
	var hpOb:h2d.Object;

	public function new(entity:Entity)
	{
		super();
		this.entity = entity;

		var person = entity.get(Person);
		var level = entity.get(Level);
		var profession = entity.get(Profession);

		var portrait = hxd.Res.img.portraits.portrait1.toTile();
		var portraitOb = new h2d.Bitmap(portrait);
		portraitOb.scale(2);
		avatarOb = new h2d.Bitmap(Tile.fromColor(0x111111, 80, 80));
		avatarOb.addChild(portraitOb);
		backgroundOb = new h2d.Bitmap(Tile.fromColor(0x111111, 320, 80));
		diceOb = new h2d.Object();
		diceOb.scale(2);
		diceOb.x = 320 - 32;
		diceOb.y = 80 - 32;

		nameTxt = TextResource.MakeText();
		nameTxt.text = person.name;
		nameTxt.x = 80 + 8;
		nameTxt.y = 8;

		lvlTxt = TextResource.MakeText();
		lvlTxt.text = 'Level ${level.lvl} ${profession.data.name}';
		lvlTxt.x = 80 + 8;
		lvlTxt.y = 8 + 16;

		hpOb = new Object();
		hpOb.x = 80 + 8;
		hpOb.y = 80 - 16 - 8;

		addChild(backgroundOb);
		addChild(avatarOb);
		addChild(diceOb);
		addChild(nameTxt);
		addChild(lvlTxt);
		addChild(hpOb);

		updateHp();
	}

	public function updateHp()
	{
		hpOb.removeChildren();

		var hp = entity.get(Health);
		var filled = Tile.fromColor(0xa0422c, 8, 16);
		var empty = Tile.fromColor(0x999999, 8, 16);

		for (n in 0...hp.current)
		{
			var pip = new h2d.Bitmap(filled);
			pip.x = n * 10;
			hpOb.addChild(pip);
		};
		for (n in hp.current...hp.max)
		{
			var pip = new h2d.Bitmap(empty);
			pip.x = n * 10;
			hpOb.addChild(pip);
		};
	}

	public function updateDice(dice:Array<GameDie>)
	{
		var x = 0;
		diceOb.removeChildren();

		dice.each((die, i) ->
		{
			if (!die.isSpent && die.roll != null)
			{
				var tile = TileResources.getDie(die.roll.value);
				var bm = new h2d.Bitmap(tile);

				bm.x = x * (32 + 8);

				diceOb.addChild(bm);
				x++;
			}
		});

		diceOb.x = 320 - (x * (32 + 8));
		diceOb.y = 80 - 32 - 8;
	}
}
