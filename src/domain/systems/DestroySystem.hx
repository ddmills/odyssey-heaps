package domain.systems;

import core.Frame;
import ecs.Entity;
import ecs.Query;
import ecs.components.IsDestroying;

class DestroySystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDestroying]
		});
	}

	public override function update(frame:Frame)
	{
		query.each((e:Entity) ->
		{
			var isDestroying = e.get(IsDestroying);

			if (isDestroying.isFlagged)
			{
				e.destroy();
			}
			else
			{
				isDestroying.flag();
			}
		});
	}
}
