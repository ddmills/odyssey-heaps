package rand;

import common.struct.Grid;
import core.Game;
import domain.Entity;
import domain.entities.Tree;
import domain.terrain.Chunk;
import domain.terrain.TerrainType;
import h2d.Bitmap;
import hxd.Perlin;

class ChunkGen
{
	var perlin:Perlin;
	var seed:Int;
	var treeTile:h2d.Tile;

	public function new(seed:Int)
	{
		treeTile = hxd.Res.img.trees.toTile().split(2)[0];

		this.seed = seed;
		perlin = new hxd.Perlin();
		perlin.normalize = true;
	}

	public function generate(chunk:Chunk)
	{
		chunk.terrain.fill(WATER);

		for (i in chunk.terrain)
		{
			var zoom = 24;
			var wx = chunk.cx * chunk.size + i.x;
			var wy = chunk.cy * chunk.size + i.y;
			var x = wx / zoom;
			var y = wy / zoom;
			var n = perlin.perlin(seed, x, y, 8);
			var v = (n + 1) / 2;
			var tile = v < .55 ? WATER : SAND;
			if (v > .58)
			{
				tile = GRASS;
			}

			if (v > .58)
			{
				var treen = perlin.perlin(seed, wx / 4, wy / 4, 9);
				var treev = (treen + 1) / 2;
				if (treev > .5)
				{
					var tree = createTree();
					tree.x = wx;
					tree.y = wy;
					Game.instance.world.add(tree);
				}
			}

			chunk.terrain.setIdx(i.idx, tile);
		}
	}

	function createTree()
	{
		var tree = new Tree(new Bitmap(treeTile));
		return tree;
	}
}
