package common.extensions;

class IterableExtensions
{
	public static function max<T>(it:Iterable<T>, fn:(value:T) -> Float):T
	{
		var cur = null;
		var curWeight = -1.0;

		for (value in it)
		{
			var weight = fn(value);

			if (cur == null || weight > curWeight)
			{
				curWeight = weight;
				cur = value;
			}
		}

		return cur;
	}

	public static inline function exists<T>(it:Iterable<T>, fn:(value:T) -> Bool):Bool
	{
		return Lambda.exists(it, fn);
	}

	public static inline function filter<A>(it:Iterable<A>, fn:(item:A) -> Bool)
	{
		return Lambda.filter(it, fn);
	}

	public static inline function map<A, B>(it:Iterable<A>, fn:(item:A) -> B):Array<B>
	{
		return Lambda.map(it, fn);
	}

	public static inline function find<T>(it:Iterable<T>, fn:(value:T) -> Bool):T
	{
		return Lambda.find(it, fn);
	}

	public static inline function fold<A, B>(it:Iterable<A>, fn:(item:A, result:B) -> B, first:B):B
	{
		return Lambda.fold(it, fn, first);
	}

	public static inline function count<A, B>(it:Iterable<A>):Int
	{
		return Lambda.count(it);
	}
}
