package common.util;

class Buffer<T>
{
	var values:Array<T>;

	public var size(default, null):Int;

	public function new(size:Int = 30)
	{
		values = new Array();
		this.size = size;
	}

	public function push(value:T)
	{
		values.push(value);
		if (values.length > size)
		{
			values.shift();
		}
	}

	public function peak():T
	{
		return values[values.length - 1];
	}

	public inline function iterator()
	{
		return values.iterator();
	}
}
