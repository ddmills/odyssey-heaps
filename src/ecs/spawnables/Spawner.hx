package ecs.spawnables;

class Spawner
{
	public static function GetSpawnable(type:SpawnableType):Spawnable
	{
		switch type
		{
			case TENTACLE:
				return new SpawnableTentacle();
		}
	}

	public static function Spawn(type:SpawnableType):Entity
	{
		return GetSpawnable(type).Spawn();
	}
}
