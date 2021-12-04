package domain.systems;

import core.Frame;
import ecs.Query;
import ecs.components.Energy;
import ecs.components.Turn;

class EnergySystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Energy]
		});
	}

	override function update(frame:Frame)
	{
		if (world.turns.current.entity != null)
		{
			return;
		}

		world.clock.clearDeltas();

		var entity = query.max((e) -> e.get(Energy).value);

		if (entity == null)
		{
			return;
		}

		var energy = entity.get(Energy);

		if (!energy.hasEnergy)
		{
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		if (!entity.has(Turn))
		{
			entity.add(new Turn());
			world.turns.current.entity = entity;
		}
	}
}
