package common.struct;

enum Space
{
	PIXEL;
	WORLD;
	CHUNK;
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
}
