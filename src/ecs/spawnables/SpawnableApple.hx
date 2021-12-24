package ecs.spawnables;

import ecs.components.Moniker;

class SpawnableApple extends Spawnable
{
	public function new() {}

	public function Spawn(?options:Dynamic):Entity
	{
		var apple = new Entity();

		apple.add(new Moniker('apple'));

		return apple;
	}
}
