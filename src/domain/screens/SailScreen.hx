package domain.screens;

import common.struct.Coordinate;
import common.util.AStar;
import common.util.Bresenham;
import common.util.Distance;
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

	function astar(goal:Coordinate)
	{
		var map = world.map;

		return AStar.GetPath({
			start: world.player.pos.toWorld().ToIntPoint(),
			goal: goal.ToIntPoint(),
			allowDiagonals: true,
			cost: function(a, b)
			{
				if (map.data.isOutOfBounds(b.x, b.y))
				{
					return Math.POSITIVE_INFINITY;
				}

				var tile = map.data.get(b.x, b.y);

				if (!tile.isWater)
				{
					return Distance.Diagonal(a, b) * 4;
				}

				return Distance.Diagonal(a, b);
			}
		});
	}

	override function onKeyUp(keyCode:Int)
	{
		if (keyCode == 77)
		{
			game.screens.push(new MapScreen());
		}
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

		var goal = click.toWorld();
		var line = astar(goal);
		var path = new Path(line.path);

		world.player.entity.add(path);
	}
}
