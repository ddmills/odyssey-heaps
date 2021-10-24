package domain;

import common.struct.Coordinate;
import core.Game;
import domain.terrain.ChunkManager;
import h2d.Layers;

class World
{
	public var chunkSize(default, null):Int = 16;
	public var chunkCountX(default, null):Int = 128;
	public var chunkCountY(default, null):Int = 128;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var game(get, null):Game;
	public var chunks(default, null):ChunkManager;
	public var bg(default, null):h2d.Object;
	public var container(default, null):h2d.Object;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		chunks = new ChunkManager(chunkCountX, chunkCountY, chunkSize);
		container = new Layers();
		bg = new Layers();
		container.addChild(bg);
	}

	function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}

	public function worldToPx(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate((wx - wy) * game.TILE_W_HALF, (wx + wy) * game.TILE_H_HALF, PIXEL);
	}

	public function pxToWorld(px:Float, py:Float):Coordinate
	{
		var wx = Math.floor((px / game.TILE_W_HALF + py / game.TILE_H_HALF) / 2);
		var wy = Math.floor((py / game.TILE_H_HALF - px / game.TILE_W_HALF) / 2);

		return new Coordinate(wx, wy, WORLD);
	}

	public function screenToPx(sx:Float, sy:Float):Coordinate
	{
		return new Coordinate(Math.floor(sx - container.x), Math.floor(sy - container.y), PIXEL);
	}

	public function screenToWorld(sx:Float, sy:Float):Coordinate
	{
		var p = screenToPx(sx, sy);
		return pxToWorld(p.x, p.y);
	}

	public function pxToChunk(px:Float, py:Float):Coordinate
	{
		var world = pxToWorld(px, py);

		return new Coordinate(Math.floor(world.x / chunkSize), Math.floor(world.y / chunkSize), CHUNK);
	}

	public function chunkToPx(cx:Float, cy:Float):Coordinate
	{
		var world = chunkToWorld(cx, cy);

		return worldToPx(world.x, world.y);
	}

	public function worldToChunk(worldX:Float, worldY:Float):Coordinate
	{
		return new Coordinate(Math.floor(worldX / chunkSize), Math.floor(worldY / chunkSize), CHUNK);
	}

	public function chunkToWorld(chunkX:Float, chunkY:Float):Coordinate
	{
		return new Coordinate(chunkX * chunkSize, chunkY * chunkSize, WORLD);
	}
}
