package common.struct;

enum Space
{
	PIXEL;
	WORLD;
	CHUNK;
	SCREEN;
}

class Coordinate
{
	public var x:Float;
	public var y:Float;
	public var space(default, null):Space;

	public function new(x:Float, y:Float, space:Space)
	{
		this.x = x;
		this.y = y;
		this.space = space;
	}

	public static function FromPoints(points:Array<{x:Int, y:Int}>, space:Space):Array<Coordinate>
	{
		return Lambda.map(points, function(p)
		{
			return new Coordinate(p.x, p.y, space);
		});
	}
}
