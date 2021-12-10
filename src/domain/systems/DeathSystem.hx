package domain.systems;

import core.Frame;
import ecs.Query;
import ecs.components.IsDead;
import ecs.components.IsDestroying;
import ecs.components.IsPlayer;

class DeathSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDead],
			none: [IsPlayer, IsDestroying]
		});
	}

	public override function update(frame:Frame)
	{
		query.each((e) ->
		{
			e.add(new IsDestroying());
		});
	}
}
