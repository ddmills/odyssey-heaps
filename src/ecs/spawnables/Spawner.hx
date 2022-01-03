package ecs.spawnables;

class Spawner
{
	public static function GetSpawnable(type:SpawnableType):Spawnable
	{
		switch type
		{
			case APPLE:
				return new SpawnableApple();
			case TENTACLE:
				return new SpawnableTentacle();
			case SQUID:
				return new SpawnableSquid();
			case TELESCOPE:
				return new SpawnableTelescope();
		}
	}

	public static function Spawn(type:SpawnableType):Entity
	{
		return GetSpawnable(type).Spawn();
	}
}
