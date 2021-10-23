package domain.terrain;

import common.struct.Grid;
import core.Game;

class ChunkManager
{
	var chunkSize:Int = 16;
	var chunkCountX:Int = 128;
	var chunkCountY:Int = 128;
	var chunks:Grid<Chunk>;

	public function new()
	{
		chunks = new Grid<Chunk>(chunkCountX, chunkCountY);
		for (i in 0...chunks.size)
		{
			var coord = chunks.coord(i);
			var chunk = new Chunk(i, coord.x, coord.y, chunkSize);

			chunk.terrain.fill(WATER);

			chunks.setIdx(i, chunk);
		}
	}

	public function chunkToWorld(chunkX:Int, chunkY:Int)
	{
		return {
			x: chunkX * chunkSize,
			y: chunkY * chunkSize,
		}
	}

	public function worldToChunk(worldX:Int, worldY:Int)
	{
		return {
			x: Math.floor(worldX / chunkSize),
			y: Math.floor(worldY / chunkSize),
		}
	}

	public inline function getChunkById(chunkIdx:Int):Chunk
	{
		return chunks.getAt(chunkIdx);
	}

	public inline function getChunk(cx:Int, cy:Int):Chunk
	{
		return chunks.get(cx, cy);
	}

	public inline function getChunkByWorld(wx:Int, wy:Int):Chunk
	{
		var coords = worldToChunk(wx, wy);

		return chunks.get(coords.x, coords.y);
	}

	public inline function getChunkByPx(px:Int, py:Int):Chunk
	{
		var wx = Math.floor(px / Game.instance.TSIZE);
		var wy = Math.floor(py / Game.instance.TSIZE);

		var coords = worldToChunk(wx, wy);

		return chunks.get(coords.x, coords.y);
	}
}
