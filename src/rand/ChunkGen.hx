package rand;

import common.struct.Grid;
import domain.terrain.Chunk;
import domain.terrain.TerrainType;

class ChunkGen
{
	static var CHUNK_SIZE = 32;

	public static function makeChunk(chunkX:Int, chunkY:Int):Chunk
	{
		var terrain = new Grid<TerrainType>(CHUNK_SIZE, CHUNK_SIZE);
		terrain.fill(WATER);

		for (i in 0...terrain.size)
		{
			var tile = Math.random() < .5 ? WATER : SAND;
			terrain.setIdx(i, tile);
		}

		return new Chunk(chunkX, chunkY, CHUNK_SIZE, terrain);
	}
}
