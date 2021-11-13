package common.util;

class IntExtensions
{
	static public inline function toString(n:Int):String
	{
		return Std.string(n);
	}

	static public inline function isEven(n:Int):Bool
	{
		return n % 2 == 0;
	}

	static public inline function isOdd(n:Int):Bool
	{
		return n % 2 == 1;
	}

	static public inline function abs(n:Int):Int
	{
		return n <= 0 ? -n : n;
	}

	static public inline function toHxdColor(n:Int):h3d.Vector
	{
		var b = n & 0xff;
		var g = (n >> 8) & 0xff;
		var r = (n >> 16) & 0xff;

		return new h3d.Vector(r / 255, g / 255, b / 255);
	}
}
