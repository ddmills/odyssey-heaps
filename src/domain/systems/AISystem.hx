package domain.systems;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.util.AStar;
import common.util.Distance;
import core.Game;
import ecs.Entity;
import ecs.components.Energy;
import ecs.components.Move;

class AI
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		var start = entity.pos.toWorld().ToIntPoint();
		var goal = Game.instance.world.player.pos.toWorld().ToIntPoint();

		if (outOfRange(start, goal))
		{
			entity.get(Energy).consumeEnergy(25);
			return;
		}

		var result = astar(start, goal);
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

	function outOfRange(start:IntPoint, goal:IntPoint)
	{
		return Distance.Diagonal(start, goal) > 10;
	}

	function astar(start:IntPoint, goal:IntPoint)
	{
		var world = Game.instance.world;
		var map = world.map;

		return AStar.GetPath({
			start: start,
			goal: goal,
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
