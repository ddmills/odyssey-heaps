package common.extensions;

class IterableExtensions
{
	public static function max<T>(it:Iterable<T>, fn:(value:T) -> Float):T
	{
		var cur = null;
		var curWeight = Math.NEGATIVE_INFINITY;

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

	public static function min<T>(it:Iterable<T>, fn:(value:T) -> Float):T
	{
		var cur = null;
		var curWeight = Math.POSITIVE_INFINITY;

		for (value in it)
		{
			var weight = fn(value);

			if (cur == null || weight < curWeight)
			{
				curWeight = weight;
				cur = value;
			}
		}

		return cur;
	}

	public static inline function every<T>(it:Iterable<T>, fn:(value:T) -> Bool):Bool
	{
		return !it.exists((v) -> !fn(v));
	}

	public static inline function first<T>(it:Iterable<T>):T
	{
		return it.iterator().next();
	}

	public static inline function sort<T>(it:Iterable<T>, fn:(a:T, b:T) -> Int):Array<T>
	{
		var arr = Lambda.array(it);

		arr.sort(fn);

		return arr;
	}

	public static inline function toArray<T>(it:Iterable<T>):Array<T>
	{
		return Lambda.array(it);
	}

	public static inline function exists<T>(it:Iterable<T>, fn:(value:T) -> Bool):Bool
	{
		return Lambda.exists(it, fn);
	}

	public static inline function filter<A>(it:Iterable<A>, fn:(item:A) -> Bool)
	{
		return Lambda.filter(it, fn);
	}

	public static overload extern inline function each<A>(it:Iterable<A>, fn:(item:A, idx:Int) -> Void)
	{
		var i = 0;
		for (x in it)
		{
			fn(x, i++);
		}
	}

	public static overload extern inline function each<A>(it:Iterable<A>, fn:(item:A) -> Void)
	{
		for (x in it)
		{
			fn(x);
		}
	}

	public static inline function map<A, B>(it:Iterable<A>, fn:(item:A) -> B):Array<B>
	{
		return Lambda.map(it, fn);
	}

	public static inline function flatMap<A, B>(it:Iterable<A>, fn:(item:A) -> Iterable<B>):Array<B>
	{
		return Lambda.flatMap(it, fn);
	}

	public static inline function find<T>(it:Iterable<T>, fn:(value:T) -> Bool):T
	{
		return Lambda.find(it, fn);
	}

	public static inline function findIdx<T>(it:Iterable<T>, fn:(value:T) -> Bool):Int
	{
		return Lambda.findIndex(it, fn);
	}

	public static inline function fold<A, B>(it:Iterable<A>, fn:(item:A, result:B) -> B, first:B):B
	{
		return Lambda.fold(it, fn, first);
	}

	public static inline function count<A, B>(it:Iterable<A>):Int
	{
		return Lambda.count(it);
	}

	public static function toMap<K:String, V>(it:Iterable<V>, keyFn:(item:V) -> K):Map<K, V>
	{
		return [for (v in it) keyFn(v) => v];
	}
}
