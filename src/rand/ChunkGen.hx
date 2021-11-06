package rand;

import common.struct.Coordinate;
import common.struct.Grid;
import core.Game;
import data.TileResources;
import domain.terrain.Chunk;
import domain.terrain.TerrainType;
import ecs.Entity;
import ecs.components.Moniker;
import ecs.components.Sprite;
import h2d.Bitmap;
import hxd.Perlin;
import shaders.ShroudShader;

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
			var zoom = 38;
			var wx = chunk.cx * chunk.size + i.x;
			var wy = chunk.cy * chunk.size + i.y;
			var x = wx / zoom;
			var y = wy / zoom;
			var n = perlin.perlin(seed, x, y, 8);
			var v = (n + 1) / 2;
			var tile = WATER;
			if (v > .58)
			{
				tile = SHALLOWS;
			}
			if (v > .62)
			{
				tile = SAND;
			}
			if (v > .63)
			{
				tile = GRASS;
			}
			if (v > .63)
			{
				var treen = perlin.perlin(seed, wx / 4, wy / 4, 9);
				var treev = (treen + 1) / 2;
				if (treev > .5)
				{
					var tree = createTree();
					tree.pos = new Coordinate(wx, wy, WORLD);

					Game.instance.world.add(tree);
				}
			}

			chunk.terrain.setIdx(i.idx, tile);
		}
	}

	function createTree()
	{
		var tree = new Entity();
		var bm = new Bitmap(TileResources.TREE);
		tree.add(new Sprite(bm, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		tree.add(new Moniker('Tree'));
		return tree;
	}
}
