package domain.systems;

import ecs.Entity;
import ecs.components.Energy;

class AI
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		entity.get(Energy).consumeEnergy(100);
	}
}
