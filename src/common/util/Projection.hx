package common.util;

import common.struct.Coordinate;
import core.Game;

enum Space
{
	PIXEL;
	WORLD;
	CHUNK;
	SCREEN;
}

class Projection
{
	static var game(get, null):Game;
	static var chunkSize(get, null):Int;

	inline static function get_game():Game
	{
		return Game.instance;
	}

	inline static function get_chunkSize():Int
	{
		return game.world.chunkSize;
	}

	public static function worldToPx(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate((wx - wy) * game.TILE_W_HALF, (wx + wy) * game.TILE_H_HALF, PIXEL);
	}

	public static function pxToWorld(px:Float, py:Float):Coordinate
	{
		var wx = (px / game.TILE_W_HALF + py / game.TILE_H_HALF) / 2;
		var wy = (py / game.TILE_H_HALF - px / game.TILE_W_HALF) / 2;

		return new Coordinate(wx, wy, WORLD);
	}

	public static function screenToPx(sx:Float, sy:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);
		var px = (sx + camWorld.x) / game.camera.zoom;
		var py = (sy + camWorld.y) / game.camera.zoom;
		return new Coordinate(px, py, PIXEL);
	}

	public static function pxToScreen(px:Float, py:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);

		var sx = (px * game.camera.zoom) - camWorld.x;
		var sy = (py * game.camera.zoom) - camWorld.y;

		return new Coordinate(sx, sy, SCREEN);
	}

	public static function screenToWorld(sx:Float, sy:Float):Coordinate
	{
		var p = screenToPx(sx, sy);
		return pxToWorld(p.x, p.y);
	}

	public static function screenToChunk(sx:Float, sy:Float):Coordinate
	{
		var w = screenToWorld(sx, sy);
		return worldToChunk(w.x, w.y);
	}

	public static function pxToChunk(px:Float, py:Float):Coordinate
	{
		var world = pxToWorld(px, py);
		return new Coordinate(world.x / chunkSize, world.y / chunkSize, CHUNK);
	}

	public static function chunkToPx(cx:Float, cy:Float):Coordinate
	{
		var world = chunkToWorld(cx, cy);
		return worldToPx(world.x, world.y);
	}

	public static function worldToChunk(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize), CHUNK);
	}

	public static function worldToScreen(wx:Float, wy:Float):Coordinate
	{
		var px = worldToPx(wx, wy);
		return pxToScreen(px.x, px.y);
	}

	public static function chunkToWorld(chunkX:Float, chunkY:Float):Coordinate
	{
		return new Coordinate(chunkX * chunkSize, chunkY * chunkSize, WORLD);
	}

	public static function chunkToScreen(cx:Float, cy:Float):Coordinate
	{
		var px = chunkToPx(cx, cy);
		return pxToScreen(px.x, px.y);
	}

	public static function tileReal(wx:Float, wy:Float):Coordinate
	{
		var column = new Array<Coordinate>();
		column.push(new Coordinate(wx + 1, wy + 1, WORLD));
		column.push(new Coordinate(wx, wy, WORLD));
		column.push(new Coordinate(wx - 1, wy - 1, WORLD));

		// is Wx/wy on left or right?
		var remX = wx - wx.floor();
		var remY = wy - wy.floor();

		var isLeft = remX < remY;

		trace(isLeft);

		return column[1];
	}
}
