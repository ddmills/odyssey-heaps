package domain.screens;

import common.struct.Grid.GridItem;
import core.Frame;
import core.Screen;
import data.Keybindings.Keybinding;
import data.TextResource;
import ecs.Entity;
import ecs.EntityRef;
import ecs.components.Inventory;
import ecs.components.IsInventoried;
import ecs.components.Moniker;

var SLOT_TILE_SIZE = 80;
var SLOT_PADDING = 6;
var SLOT_SIZE = SLOT_TILE_SIZE + SLOT_PADDING + SLOT_PADDING;

class InventoryScreen extends Screen
{
	var root:h2d.Object;
	var entity:Entity;

	var inventory(get, never):Inventory;

	public function new()
	{
		entity = game.world.player.entity;
	}

	override function onEnter()
	{
		root = new h2d.Object();

		var bkg = new h2d.Bitmap();
		bkg.tile = h2d.Tile.fromColor(0x002244, inventory.contentRefs.width * SLOT_SIZE, inventory.contentRefs.height * SLOT_SIZE);
		root.addChild(bkg);

		inventory.contentRefs.each((ref:GridItem<EntityRef>) ->
		{
			var c = ref.value.entity == null ? 0x333333 : 0x770000;
			var slot = new h2d.Bitmap();
			slot.tile = h2d.Tile.fromColor(c, SLOT_TILE_SIZE, SLOT_TILE_SIZE);
			bkg.addChild(slot);

			slot.x = SLOT_SIZE * ref.x + SLOT_PADDING;
			slot.y = SLOT_SIZE * ref.y + SLOT_PADDING;

			if (ref.value.entity != null)
			{
				var e = ref.value.entity;
				var text = TextResource.MakeText();
				text.text = e.get(IsInventoried).display;
				slot.addChild(text);
			}
		});

		game.render(HUD, root);
	}

	override function update(frame:Frame)
	{
		root.x = game.window.width / 2 - (inventory.contentRefs.width * SLOT_SIZE / 2);
		root.y = game.window.height / 2 - (inventory.contentRefs.height * SLOT_SIZE / 2);
	}

	override function onDestroy()
	{
		root.remove();
	}

	override function onKeyUp(key:Int)
	{
		if (Keybinding.BACK.is(key) || Keybinding.INVENTORY_SCREN.is(key))
		{
			game.screens.pop();
		}
	}

	function get_inventory():Inventory
	{
		return entity.get(Inventory);
	}
}
