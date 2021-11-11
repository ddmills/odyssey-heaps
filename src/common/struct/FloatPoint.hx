package common.struct;

@:structInit class FloatPoint
{
	public final x:Float;
	public final y:Float;

	public inline function new(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
}
