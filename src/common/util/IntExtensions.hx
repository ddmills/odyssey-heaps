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
}
