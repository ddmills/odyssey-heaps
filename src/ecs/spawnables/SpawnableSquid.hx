package ecs.spawnables;

import ecs.prefabs.SquidPrefab;

class SpawnableSquid extends Spawnable
{
	public function new() {}

	public function Spawn(?options:Dynamic):Entity
	{
		return SquidPrefab.Create();
	}
}
