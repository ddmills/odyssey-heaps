package ecs.components;

import common.struct.Grid;
import common.struct.IntPoint;
import ecs.spawnables.SpawnableType;

class Inventory extends Component
{
	public var contentRefs:Grid<EntityRef>;

	public function new()
	{
		contentRefs = new Grid<EntityRef>(8, 4);
		contentRefs.fillFn(idx -> new EntityRef());
	}

	public function getSpawnable(spawnable:SpawnableType):Entity
	{
		var res = contentRefs.find((e) ->
		{
			var entity = e.value.entity;

			if (entity == null)
			{
				return false;
			}

			var stack = entity.get(Stackable);

			if (stack == null)
			{
				return false;
			}

			return stack.spawnable == spawnable;
		});

		if (res != null)
		{
			return res.value.entity;
		}

		return null;
	}

	public function findFreeSpot():IntPoint
	{
		var idx = contentRefs.findIdx((v) -> v.value.entity == null);

		if (idx < 0)
		{
			return null;
		}

		return contentRefs.coord(idx);
	}

	public function addItem(item:Entity, stack:Bool = true)
	{
		if (stack && item.has(Stackable))
		{
			var stackable = item.get(Stackable);
			var existing = getSpawnable(stackable.spawnable);

			if (existing != null)
			{
				existing.get(Stackable).stack(item);
				return;
			}
		}
		var freeSpot = findFreeSpot();
		if (freeSpot == null)
		{
			throw "TODO: inventory full";
		}

		item.add(new IsInventoried({
			owner: entity
		}));

		contentRefs.set(freeSpot.x, freeSpot.y, new EntityRef(item.id));
	}

	public function removeItem(item:Entity)
	{
		var idx = contentRefs.findIdx((c) -> c.value != null && c.value.entity == item);

		if (idx < 0)
		{
			return false;
		}

		contentRefs.getAt(idx).entity = null;

		item.remove(IsInventoried);

		return true;
	}
}
