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
}
