package domain.screens;

import core.Frame;
import core.Screen;
import data.TileResources;
import ecs.Entity;
import ecs.components.Sprite;

class SailScreen extends Screen
{
	var cursor:Entity;

	public function new() {}

	override function onEnter()
	{
		cursor = new Entity();
		cursor.add(new Sprite(new h2d.Bitmap(TileResources.CURSOR), game.TILE_W_HALF));
		cursor.get(Sprite).visible = true;
		world.add(cursor);
	}

	override function onDestroy()
	{
		// todo: cleanup cursor
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		var w = camera.mouse.toWorld().floor();

		cursor.pos = w;
	}
}
