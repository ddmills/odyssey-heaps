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
import rand.names.SpanishNameGenerator;
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
		var waterline = .58;

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
			if (v > waterline - .04)
			{
				tile = SHALLOWS;
			}
			if (v > waterline)
			{
				tile = SAND;
			}
			if (v > waterline + .01)
			{
				tile = GRASS;
			}
			if (v > waterline + .02)
			{
				var treen = perlin.perlin(seed, wx / 4, wy / 4, 9);
				var treev = (treen + 1) / 2;
				if (treev > .5)
				{
					var tree = createTree(wx, wy);
					tree.pos = new Coordinate(wx, wy, WORLD);

					Game.instance.world.add(tree);
				}
			}

			chunk.terrain.setIdx(i.idx, tile);
		}
	}

	function createTree(x:Int, y:Int)
	{
		var seed = x + (y * 2000);
		var tree = new Entity();
		var bm = new Bitmap(TileResources.TREE);
		tree.add(new Sprite(bm, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		var name = seed % 2 == 0 ? SpanishNameGenerator.getMaleName(seed) : SpanishNameGenerator.getFemaleName(seed);

		tree.add(new Moniker('${name} [${seed}]'));
		return tree;
	}
}
