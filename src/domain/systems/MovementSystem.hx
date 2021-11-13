package domain.systems;

import common.struct.Cardinal;
import common.struct.Coordinate;
import core.Frame;
import ecs.Query;
import ecs.components.Direction;
import ecs.components.Move;
import ecs.components.MoveComplete;
import ecs.components.Moved;

class MovementSystem extends System
{
	var query:Query;
	var completed:Query;
	var moved:Query;

	public function new()
	{
		query = new Query({
			all: [Move],
			none: [MoveComplete]
		});
		completed = new Query({
			all: [MoveComplete]
		});
		moved = new Query({
			all: [Moved]
		});
	}

	inline function getDelta(pos:Coordinate, goal:Coordinate, speed:Float, tween:Tween, tmod:Float):Coordinate
	{
		switch tween
		{
			case LINEAR:
				var direction = pos.direction(goal);
				var dx = direction.x * tmod * speed;
				var dy = direction.y * tmod * speed;
				return new Coordinate(dx, dy, WORLD);
			case LERP:
				return pos.lerp(goal, tmod * speed).sub(pos);
			case INSTANT:
				return goal.sub(pos);
		}
	}

	public override function update(frame:Frame)
	{
		for (entity in completed)
		{
			entity.remove(MoveComplete);
		}
		for (entity in moved)
		{
			entity.remove(Moved);
		}

		for (entity in query)
		{
			var start = entity.pos;
			var move = entity.get(Move);
			var delta = getDelta(start, move.goal, move.speed, move.tween, frame.tmod);

			var deltaSq = delta.lengthSq();
			var distanceSq = start.distanceSq(move.goal, WORLD);

			start.lerp(move.goal, frame.tmod * move.speed);

			if (distanceSq < Math.max(deltaSq, move.epsilon * move.epsilon))
			{
				entity.pos = move.goal;
				entity.remove(move);
				entity.add(new MoveComplete());
			}
			else
			{
				entity.pos = start.add(delta);
			}

			if (entity.x.floor() != start.x.floor() || entity.y.floor() != start.y.floor())
			{
				entity.add(new Moved());
			}

			if (entity.has(Direction))
			{
				var component = entity.get(Direction);
				var degrees = move.goal.sub(start).angle().toDegrees();
				var cardinal = Cardinal.fromDegrees(degrees);

				component.cardinal = cardinal;
			}
		}
	}
}
