package domain.systems;

import common.struct.IntPoint;
import common.util.AStar;
import common.util.Distance;
import core.Game;
import domain.screens.CombatScreen;
import ecs.Entity;
import ecs.components.Energy;
import ecs.components.Mob;
import ecs.components.Move;

class AI
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		var start = entity.pos.toWorld().ToIntPoint();
		var goal = Game.instance.world.player.pos.toWorld().ToIntPoint();
		var distance = Distance.Diagonal(start, goal);

		if (distance > 10)
		{
			entity.get(Energy).consumeEnergy(25);
			return;
		}

		if (distance <= 2)
		{
			startCombat(entity);
		}
		else
		{
			move(entity, start, goal);
		}
	}

	function move(entity:Entity, start:IntPoint, goal:IntPoint)
	{
		var result = astar(start, goal);

		if (!result.success)
		{
			entity.get(Energy).consumeEnergy(25);
		}

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

	function startCombat(entity:Entity)
	{
		entity.get(Energy).consumeEnergy(100);
		var mob = entity.get(Mob);

		if (mob != null)
		{
			Game.instance.screens.push(new CombatScreen(entity));
			return;
		}
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
