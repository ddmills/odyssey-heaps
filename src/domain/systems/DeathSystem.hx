package domain.systems;

import ecs.Query;
import ecs.components.IsDead;
import ecs.components.IsPlayer;

class DeathSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDead],
			none: [IsPlayer]
		});

		query.onEntityAdded((e) ->
		{
			e.destroy();
		});
	}
}
