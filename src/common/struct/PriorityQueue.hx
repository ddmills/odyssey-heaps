package common.struct;

@:generic class PriorityQueue<T>
{
	var items:Array<{value:T, priority:Float}>;

	public var isEmpty(get, never):Bool;
	public var length(get, never):Int;

	public function new()
	{
		items = new Array();
	}

	function get_isEmpty():Bool
	{
		return items.length == 0;
	}

	function get_length():Int
	{
		return items.length;
	}

	public function pop():Null<T>
	{
		return isEmpty ? null : items.shift().value;
	}

	public function peek():Null<T>
	{
		return isEmpty ? null : items[0].value;
	}

	public function put(value:T, priority:Float)
	{
		var item = {value: value, priority: priority};

		for (i in 0...length)
		{
			if (items[i].priority > item.priority)
			{
				items.insert(i, item);
				return;
			}
		}

		items.push(item);
	}
}
