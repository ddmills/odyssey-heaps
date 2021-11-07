package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import ecs.Query;
import ecs.components.Move;
import ecs.components.MoveComplete;
import ecs.components.Path;

class PathFollowSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Path]
		});
	}

	public override function update(frame:Frame)
	{
		for (entity in query)
		{
			var path = entity.get(Path);

			if (entity.has(MoveComplete) || !entity.has(Move))
			{
				if (path.hasNext())
				{
					var next = path.next();
					var target = new Coordinate(next.x, next.y, WORLD);
					var speed = .16;

					entity.add(new Move(target, speed, LINEAR));
				}
				else
				{
					trace('PATH COMPLETE');
					entity.remove(path);
				}
			}
		}
	}
}
