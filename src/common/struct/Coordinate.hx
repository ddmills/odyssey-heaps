package common.struct;

import common.util.Projection;

typedef Point =
{
	var x:Int;
	var y:Int;
};

class Coordinate
{
	public final x:Float;
	public final y:Float;
	public final space:Space;

	public inline function new(x:Float, y:Float, space:Space)
	{
		this.x = x;
		this.y = y;
		this.space = space;
	}

	public static function FromPoints(points:Array<Point>, space:Space):Array<Coordinate>
	{
		return Lambda.map(points, function(p)
		{
			return new Coordinate(p.x, p.y, space);
		});
	}
}
