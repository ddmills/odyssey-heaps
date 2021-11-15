package common.extensions;

import common.struct.FloatPoint;

class FloatPointExtensions
{
	static public inline function lerp(a:FloatPoint, b:FloatPoint, t:Float):FloatPoint
	{
		return {
			x: a.x.lerp(b.x, t),
			y: a.y.lerp(b.y, t),
		};
	}
}
