package common.util;

class FloatExtensions
{
	static public function toString(n:Float):String
	{
		return Std.string(n);
	}

	static public inline function floor(n:Float):Int
	{
		return Math.floor(n);
	}

	static public inline function ciel(n:Float):Int
	{
		return Math.ceil(n);
	}

	static public inline function round(n:Float):Int
	{
		return Math.round(n);
	}

	static public inline function lerp(n:Float, target:Float, time:Float, snap:Float = 0):Float
	{
		var pos = n + time * (target - n);

		if ((target - pos).abs() < snap)
		{
			return target;
		}

		return ((target - pos).abs() < snap) ? target : pos;
	}

	static public inline function abs(n:Float):Float
	{
		return Math.abs(n);
	}

	static public inline function toDegrees(n:Float):Float
	{
		return n * (180 / Math.PI);
	}

	static public inline function toRadians(n:Float):Float
	{
		return n / (180 / Math.PI);
	}
}
