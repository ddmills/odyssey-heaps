package ecs.spawnables;

import ecs.components.Moniker;

class SpawnableTelescope extends Spawnable
{
	public function new() {}

	public function Spawn(?options:Dynamic):Entity
	{
		var telescope = new Entity();

		telescope.add(new Moniker('telescope'));

		return telescope;
	}
}
