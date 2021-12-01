package domain.screens.components;

import data.TextResource;
import data.TileResources;
import data.portraits.PortraitData;
import domain.screens.CombatScreen.GameDie;
import ecs.Entity;
import ecs.components.Health;
import ecs.components.Moniker;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Object;
import h2d.Text;
import h2d.Tile;

class EnemyCard extends CombatantCard
{
	var entity:Entity;

	var avatarOb:h2d.Bitmap;
	var diceOb:h2d.Object;
	var nameTxt:Text;
	var hpOb:h2d.Object;

	public function new(entity:Entity)
	{
		super();
		this.entity = entity;

		var name = entity.get(Moniker);

		var cardHeight = 120;
		var cardWidth = 320;

		avatarOb = new h2d.Bitmap(PortraitData.PORTRAIT_BG);
		avatarOb.addChild(new h2d.Bitmap(PortraitData.PORTRAIT_TENTACLE));
		avatarOb.addChild(new h2d.Bitmap(PortraitData.PORTRAIT_TRIM));
		avatarOb.scale(2);
		avatarOb.x = cardWidth - 80;

		diceOb = new h2d.Object();
		diceOb.scale(2);
		diceOb.x = 0;
		diceOb.y = cardHeight - 32;

		nameTxt = TextResource.MakeText();
		nameTxt.text = name.displayName;
		nameTxt.textAlign = Right;
		nameTxt.x = cardWidth - 80 - 8;
		nameTxt.y = 8;

		hpOb = new Object();
		hpOb.x = cardWidth - 80 - 8;
		hpOb.y = cardHeight - 16 - 8;

		var name2Txt = TextResource.MakeText();
		name2Txt.text = name.displayName.split(' ')[0].toUpperCase();
		name2Txt.textAlign = Center;
		name2Txt.x = cardWidth - (80 / 2);
		name2Txt.y = 120 - 16 - 4;

		var interactive = new Interactive(0, 0);
		interactive.onClick = (e) -> onClick(e);
		interactive.x = avatarOb.x;
		interactive.y = avatarOb.y;
		interactive.width = 80;
		interactive.height = 120;

		addChild(avatarOb);
		addChild(diceOb);
		addChild(nameTxt);
		// addChild(name2Txt);
		addChild(hpOb);
		addChild(interactive);

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
			pip.x = -n * 10;
			hpOb.addChild(pip);
		};
		for (n in hp.current...hp.max)
		{
			var pip = new h2d.Bitmap(empty);
			pip.x = -n * 10;
			hpOb.addChild(pip);
		};
	}

	public function updateDice(dice:Array<GameDie>)
	{
		var x = 0;
		diceOb.removeChildren();

		dice.each((die, i) ->
		{
			if (!die.isSpent && !die.isRetired && die.roll != null)
			{
				var tile = TileResources.getDie(die.roll.value);
				var bm = new h2d.Bitmap(tile);

				bm.x = x * (32 + 8);

				diceOb.addChild(bm);
				x++;
			}
		});

		diceOb.x = 8;
		diceOb.y = 120 - 32 - 8;
	}
}
