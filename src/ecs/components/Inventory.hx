package ecs.components;

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

	public function addItem(item:Entity)
	{
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
