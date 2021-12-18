package domain;

class Resource
{
	public var value(default, set):Int;
	public var max(default, set):Int;
	public var ratio(get, never):Float;

	public function new(value:Int, max:Int)
	{
		this.max = max;
		this.value = value;
	}

	function get_ratio():Float
	{
		return max / value;
	}

	function set_value(v:Int):Int
	{
		value = v.clamp(0, max);
		return value;
	}

	function set_max(value:Int):Int
	{
		max = value.clamp(0, value);
		if (value > max)
		{
			value = max;
		}
		return max;
	}

	public function toString()
	{
		return '${value}/${max}';
	}
}
