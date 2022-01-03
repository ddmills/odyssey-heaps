package ecs.components;

import ecs.spawnables.SpawnableType;
import ecs.spawnables.Spawner;

typedef StackableOpts =
{
	var spawnable:SpawnableType;
	var quantity:Int;
}

class Stackable extends Component
{
	public var quantity(default, null):Int;
	public var capacity(default, null):Int;
	public var spawnable(default, null):SpawnableType;

	public function new(opts:StackableOpts)
	{
		spawnable = opts.spawnable;
		quantity = opts.quantity;
		capacity = 12;
	}

	public function split(amount:Int):Entity
	{
		if (amount >= quantity)
		{
			return entity;
		}

		var other = Spawner.Spawn(spawnable);
		other.get(Stackable).quantity = amount;
		quantity -= amount;

		var isInventoried = entity.get(IsInventoried);

		if (isInventoried != null)
		{
			isInventoried.owner.get(Inventory).addItem(other, false);
		}

		return other;
	}

	public function stack(other:Entity)
	{
		// TODO add stack limits
		var stack = other.get(Stackable);

		if (quantity + stack.quantity > capacity)
		{
			// cannot fully stack
		}

		quantity += stack.quantity;
		stack.quantity = 0;
		other.add(new IsDestroying());
	}
}
