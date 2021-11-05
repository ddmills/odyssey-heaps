package common.extensions;

class ArrayExtensions
{
	public static function intersection<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) != null;
		});
	}

	public static function difference<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) == null;
		});
	}
}
