package rand;

import common.struct.Grid;
import domain.terrain.TerrainType;

class ChunkGen
{
	public static function generateTerrain(chunkX:Int, chunkY:Int, size:Int):Grid<TerrainType>
	{
		var terrain = new Grid<TerrainType>(size, size);
		terrain.fill(WATER);

		for (i in 0...terrain.size)
		{
			var tile = Math.random() < .66 ? WATER : SAND;
			terrain.setIdx(i, tile);
		}

		return terrain;
	}
}
