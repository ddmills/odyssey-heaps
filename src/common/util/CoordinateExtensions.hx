package common.util;

import common.struct.Coordinate;
import core.Game;

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

	static public inline function lerp(c:Coordinate, target:Coordinate, time:Float):Coordinate
	{
		return new Coordinate(c.x.lerp(target.x, time), c.y.lerp(target.y, time), c.space);
	}
}
