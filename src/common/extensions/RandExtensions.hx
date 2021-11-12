package common.extensions;

class RandExtensions
{
	public static function pick<T>(r:hxd.Rand, array:Array<T>):T
	{
		return array[r.random(array.length)];
	}

	public static function pickIdx<T>(r:hxd.Rand, array:Array<T>):Int
	{
		return Math.floor(r.rand() * array.length);
	}
}
