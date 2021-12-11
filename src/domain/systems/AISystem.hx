package domain.systems;

import common.struct.Coordinate;
import common.util.AStar;
import common.util.Distance;
import core.Game;
import ecs.Entity;
import ecs.components.Energy;
import ecs.components.Move;
import ecs.components.Path;

class AI
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		var result = astar(entity.pos, Game.instance.world.player.pos);
		if (result.success && result.path.length > 2)
		{
			if (entity.has(Move))
			{
				if (result.path.length > 3)
				{
					var next = result.path[2].asWorld();
					entity.add(new Move(next, .2, LINEAR));
				}
			}
			else
			{
				var next = result.path[1].asWorld();
				entity.add(new Move(next, .2, LINEAR));
			}

			entity.get(Energy).consumeEnergy(75);
		}
		else
		{
			entity.get(Energy).consumeEnergy(25);
		}
	}

	function astar(start:Coordinate, goal:Coordinate)
	{
		var world = Game.instance.world;
		var map = world.map;

		return AStar.GetPath({
			start: start.toWorld().ToIntPoint(),
			goal: goal.ToIntPoint(),
			allowDiagonals: true,
			cost: function(a, b)
			{
				if (map.data.isOutOfBounds(b.x, b.y))
				{
					return Math.POSITIVE_INFINITY;
				}

				// get entities
				var entities = world.getEntitiesAt(b.asWorld());
				if (entities.length > 0)
				{
					return 12;
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
}
