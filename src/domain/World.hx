package domain;

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

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		chunks = new ChunkManager(chunkCountX, chunkCountY, chunkSize);
		bg = new Layers();
	}

	function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}

	public function worldToPx(wx:Int, wy:Int)
	{
		return {
			x: (wx - wy) * game.TILE_W_HALF,
			y: (wx + wy) * game.TILE_H_HALF,
		};
	}

	public function pxToWorld(px:Float, py:Float)
	{
		return {
			x: Math.floor((px / game.TILE_W_HALF + py / game.TILE_H_HALF) / 2),
			y: Math.floor((py / game.TILE_H_HALF - px / game.TILE_W_HALF) / 2),
		}
	}

	public function screenToPx(sx:Float, sy:Float)
	{
		return {
			x: Math.floor(sx - bg.x),
			y: Math.floor(sy - bg.y),
		};
	}

	public function screenToWorld(sx:Float, sy:Float)
	{
		var p = screenToPx(sx, sy);
		return pxToWorld(p.x, p.y);
	}

	public function pxToChunk(px:Float, py:Float)
	{
		var world = pxToWorld(px, py);

		return {
			x: Math.floor(world.x / chunkSize),
			y: Math.floor(world.y / chunkSize),
		}
	}

	public function chunkToPx(cx:Int, cy:Int)
	{
		var world = chunkToWorld(cx, cy);

		return worldToPx(world.x, world.y);
	}

	public function worldToChunk(worldX:Float, worldY:Float)
	{
		return {
			x: Math.floor(worldX / chunkSize),
			y: Math.floor(worldY / chunkSize),
		}
	}

	public function chunkToWorld(chunkX:Int, chunkY:Int)
	{
		return {
			x: chunkX * chunkSize,
			y: chunkY * chunkSize,
		}
	}
}
