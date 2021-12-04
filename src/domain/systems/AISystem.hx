package domain.systems;

import ecs.Entity;
import ecs.components.Energy;
import ecs.components.Moniker;

class AI
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		trace('MOB ACTION', entity.get(Moniker).displayName);
		entity.get(Energy).consumeEnergy(100);
	}
}
