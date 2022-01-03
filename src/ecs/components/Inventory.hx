package ecs.components;

import ecs.spawnables.SpawnableType;

class Inventory extends Component
{
	public var size:Int;

	var contentRefs:Array<EntityRef>;

	public var content(get, null):Array<Entity>;

	public function new()
	{
		contentRefs = new Array();
		size = 8;
	}

	public function getSpawnable(spawnable:SpawnableType):Entity
	{
		return content.find((e) ->
		{
			var stack = e.get(Stackable);

			if (stack == null)
			{
				return false;
			}

			return stack.spawnable == spawnable;
		});
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

		item.add(new IsInventoried({
			owner: entity
		}));
		contentRefs.push(new EntityRef(item.id));
	}

	public function removeItem(item:Entity)
	{
		var idx = contentRefs.findIdx((c) -> c.entity == item);

		if (idx < 0)
		{
			return false;
		}

		contentRefs.splice(idx, 1);

		item.remove(IsInventoried);

		return true;
	}

	function get_content():Array<Entity>
	{
		// TODO remove dead refs
		return contentRefs.map((e) -> e.entity).filter((e) -> e != null);
	}
}
