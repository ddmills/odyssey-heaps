package ecs.spawnables;

import ecs.components.Moniker;
import ecs.components.Stackable;

class SpawnableApple extends Spawnable
{
	public function new() {}

	public function Spawn(?options:Dynamic):Entity
	{
		var apple = new Entity();

		apple.add(new Moniker('apple'));
		apple.add(new Stackable({
			spawnable: APPLE,
			quantity: 1,
		}));

		return apple;
	}
}
