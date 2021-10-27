package rand;

import common.struct.Grid;
import domain.terrain.TerrainType;
import hxd.Perlin;

class ChunkGen
{
	var perlin:Perlin;
	var seed:Int;

	public function new(seed:Int)
	{
		this.seed = seed;
		perlin = new hxd.Perlin();
		perlin.normalize = true;
	}

	public function generateTerrain(chunkX:Int, chunkY:Int, size:Int):Grid<TerrainType>
	{
		var terrain = new Grid<TerrainType>(size, size);
		terrain.fill(WATER);

		for (i in terrain)
		{
			var zoom = 20;
			var x = (chunkX * size + i.x) / zoom;
			var y = (chunkY * size + i.y) / zoom;
			var n = perlin.perlin(seed, x, y, 8);
			var v = (n + 1) / 2;
			var tile = v < .66 ? WATER : SAND;

			terrain.setIdx(i.idx, tile);
		}

		return terrain;
	}
}
