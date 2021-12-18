package domain.systems;

import core.Frame;
import ecs.Entity;
import ecs.Query;
import ecs.components.Energy;
import ecs.components.IsPlayer;

class EnergySystem extends System
{
	public var isPlayersTurn(default, null):Bool;

	var query:Query;

	public function new()
	{
		isPlayersTurn = false;
		query = new Query({
			all: [Energy]
		});
	}

	function getNext():Entity
	{
		var entities = query.toArray();
		var entity = entities.max((e) -> e.get(Energy).value);
		if (entity == null)
		{
			return null;
		}

		var energy = entity.get(Energy);

		if (!energy.hasEnergy)
		{
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		entities.remove(entity);

		return entity;
	}

	override function update(frame:Frame)
	{
		world.clock.clearDeltas();
		if (isPlayersTurn && world.player.entity.get(Energy).hasEnergy)
		{
			return;
		}

		while (true)
		{
			var entity = getNext();

			if (entity.has(IsPlayer))
			{
				isPlayersTurn = true;
				world.player.startTurn();
				break;
			}
			else
			{
				isPlayersTurn = false;
				world.ai.takeAction(entity);
			}
		}
	}
}
