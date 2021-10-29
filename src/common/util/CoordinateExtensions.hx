package common.util;

import common.struct.Coordinate;
import core.Game;
import h2d.col.Point;

class CoordinateExtensions
{
	static public inline function toString(c:Coordinate, precision:Int = null):String
	{
		return '${c.x},${c.y}';
	}

	static public inline function floor(c:Coordinate):Coordinate
	{
		return new Coordinate(c.x.floor(), c.y.floor(), c.space);
	}

	static public inline function toWorld(c:Coordinate):Coordinate
	{
		var world = Game.instance.world;

		switch c.space
		{
			case PIXEL:
				return world.pxToWorld(c.x, c.y);
			case CHUNK:
				return world.chunkToWorld(c.x, c.y);
			case SCREEN:
				return world.screenToWorld(c.x, c.y);
			case WORLD:
				return c;
		}
	}

	static public inline function toPx(c:Coordinate):Coordinate
	{
		var world = Game.instance.world;

		switch c.space
		{
			case PIXEL:
				return c;
			case CHUNK:
				return world.chunkToPx(c.x, c.y);
			case SCREEN:
				return world.screenToPx(c.x, c.y);
			case WORLD:
				return world.worldToPx(c.x, c.y);
		}
	}

	static public inline function toChunk(c:Coordinate):Coordinate
	{
		var world = Game.instance.world;

		switch c.space
		{
			case PIXEL:
				return world.pxToChunk(c.x, c.y);
			case SCREEN:
				return world.screenToChunk(c.x, c.y);
			case WORLD:
				return world.worldToChunk(c.x, c.y);
			case CHUNK:
				return c;
		}
	}

	static public inline function toScreen(c:Coordinate):Coordinate
	{
		var world = Game.instance.world;

		switch c.space
		{
			case PIXEL:
				return world.pxToScreen(c.x, c.y);
			case CHUNK:
				return world.chunkToScreen(c.x, c.y);
			case SCREEN:
				return c;
			case WORLD:
				return world.worldToScreen(c.x, c.y);
		}
	}

	static public inline function lerp(a:Coordinate, b:Coordinate, time:Float):Coordinate
	{
		return new Coordinate(a.x.lerp(b.x, time), a.y.lerp(b.y, time), a.space);
	}

	static public inline function sub(a:Coordinate, b:Coordinate):Coordinate
	{
		return new Coordinate(a.x - b.x, a.y - b.y, a.space);
	}

	static public inline function add(a:Coordinate, b:Coordinate):Coordinate
	{
		return new Coordinate(a.x + b.x, a.y + b.y, a.space);
	}

	static public inline function manhattan(a:Coordinate, b:Coordinate):Float
	{
		return (a.x - b.x).abs() + (a.y - b.y).abs();
	}

	static public inline function angle(a:Coordinate):Float
	{
		var atan2 = Math.atan2(a.y, a.x);
		var up = atan2 - 3.92699081698;
		var val = up < 0 ? Math.PI * 2 + up : up;

		return val;
	}

	public static inline function lengthSq(a:Coordinate):Float
	{
		return a.x * a.x + a.y * a.y;
	}

	static public inline function normalized(a:Coordinate):{x:Float, y:Float}
	{
		var k = lengthSq(a);
		if (k < hxd.Math.EPSILON)
		{
			k = 0;
		}
		else
		{
			k = hxd.Math.invSqrt(k);
		}

		return {
			x: a.x * k,
			y: a.y * k,
		};
	}
}
