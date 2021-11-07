package domain.screens;

import common.struct.Coordinate;
import common.util.Bresenham;
import core.Frame;
import core.Screen;
import data.TileResources;
import ecs.Entity;
import ecs.components.Path;
import ecs.components.Settlement;
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

		game.render(FOG_OVERLAY, cursor.get(Sprite).ob);

		game.camera.x = 0;
		game.camera.y = 0;
		game.camera.zoom = 2;
		game.camera.follow = world.player.entity;
	}

	override function onDestroy()
	{
		cursor.get(Sprite).ob.remove();
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		cursor.pos = camera.mouse.toWorld().floor();
	}

	override function onMouseDown(click:Coordinate)
	{
		var entities = world.getEntitiesAt(click);

		var settlement = Lambda.find(entities, function(entity)
		{
			return entity.has(Settlement);
		});

		if (settlement != null)
		{
			game.screens.push(new SettlementScreen(settlement));
			return;
		}

		var goal = click.toWorld().floor();
		var line = Bresenham.getLine(world.player.x.floor(), world.player.y.floor(), goal.x.floor(), goal.y.floor());
		var path = new Path(line);

		world.player.entity.add(path);
	}
}
