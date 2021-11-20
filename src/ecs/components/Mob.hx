package ecs.components;

import domain.combat.dice.DiceCombo;
import ecs.spawnables.SpawnableType;
import ecs.spawnables.Spawner;

class Mob extends Component
{
	public var spawnables(default, null):Array<SpawnableType>;
	public var combos(default, null):Array<DiceCombo>;

	public function new(spawnables:Array<SpawnableType>, combos:Array<DiceCombo>)
	{
		this.spawnables = spawnables;
		this.combos = combos;
	}

	public function spawn():Array<Entity>
	{
		return spawnables.map((type) -> Spawner.Spawn(type));
	}
}
