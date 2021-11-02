package common.util;

class BitUtil
{
	public static function subtractBit(num:Int, bit:Int):Int
	{
		return num & ~(1 << bit);
	}

	public static function addBit(num:Int, bit:Int):Int
	{
		return num | (1 << bit);
	}

	public static function hasBit(num:Int, bit:Int):Bool
	{
		return (num >> bit) % 2 != 0;
	}

	public static function intersection(n1:Int, n2:Int):Int
	{
		return n1 & n2;
	}
}
