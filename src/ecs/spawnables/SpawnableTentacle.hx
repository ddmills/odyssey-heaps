package ecs.spawnables;

import data.DiceSets;
import ecs.components.Combatant;
import ecs.components.Health;
import ecs.components.Moniker;

class SpawnableTentacle extends Spawnable
{
	public function new() {}

	public function Spawn(?options:Dynamic):Entity
	{
		var tentacle = new Entity();

		tentacle.add(new Moniker('Tentacle'));
		tentacle.add(new Combatant(DiceSets.TENTACLE));
		tentacle.add(new Health(4, 4));

		return tentacle;
	}
}
