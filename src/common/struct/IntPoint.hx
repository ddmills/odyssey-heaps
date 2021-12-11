package common.struct;

@:structInit class IntPoint
{
	public final x:Int;
	public final y:Int;

	public inline function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function equals(other:IntPoint)
	{
		return other.x == x && other.y == y;
	}

	public function asWorld()
	{
		return new Coordinate(x, y, WORLD);
	}

	public function toString()
	{
		return '${x},${y}';
	}
}
