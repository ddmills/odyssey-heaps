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
	public var chunks(default, null):ChunkManager;
	public var bg(default, null):h2d.Object;

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

	public function pxToChunk(px:Float, py:Float)
	{
		return {
			x: Math.floor(px / Game.instance.TSIZE / chunkSize),
			y: Math.floor(py / Game.instance.TSIZE / chunkSize),
		}
	}

	public function chunkToWorld(chunkX:Int, chunkY:Int)
	{
		return {
			x: chunkX * chunkSize,
			y: chunkY * chunkSize,
		}
	}

	public function worldToChunk(worldX:Float, worldY:Float)
	{
		return {
			x: Math.floor(worldX / chunkSize),
			y: Math.floor(worldY / chunkSize),
		}
	}
}
