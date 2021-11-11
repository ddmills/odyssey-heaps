package common.extensions;

class IterableExtensions
{
	public static function max<T>(iter:Iterable<T>, fn:(value:T) -> Float):T
	{
		var cur = null;
		var curWeight = -1.0;

		for (value in iter)
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
}
