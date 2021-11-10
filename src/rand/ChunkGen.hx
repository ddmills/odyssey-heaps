package rand;

import common.struct.Coordinate;
import core.Game;
import data.TileResources;
import domain.terrain.Chunk;
import ecs.Entity;
import ecs.components.Moniker;
import ecs.components.Sprite;
import ecs.prefabs.SettlementPrefab;
import h2d.Bitmap;
import hxd.Perlin;
import rand.names.SpanishNameGenerator;

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
		var map = Game.instance.world.map;

		for (i in chunk.exploration)
		{
			var wx = chunk.cx * chunk.size + i.x;
			var wy = chunk.cy * chunk.size + i.y;
			var tile = map.getTerrain(wx, wy);

			if (map.hasSettlement(wx, wy))
			{
				var s = wx + (wy * 2000);
				var settlement = SettlementPrefab.Create(s);
				settlement.x = wx;
				settlement.y = wy;
				Game.instance.world.add(settlement);
			}
			else if (tile == GRASS)
			{
				var treen = perlin.perlin(seed, wx / 4, wy / 4, 9);
				var treev = (treen + 1) / 2;
				if (treev > .5)
				{
					var tree = createTree(wx, wy);
					if (tree != null)
					{
						tree.pos = new Coordinate(wx, wy, WORLD);
						Game.instance.world.add(tree);
					}
				}
			}
		}
	}

	function createTree(x:Int, y:Int)
	{
		var settlements = Game.instance.world.map.settlements;

		if (!Lambda.exists(settlements, function(p)
		{
			return Math.abs(x - p.x) < 3 && Math.abs(y - p.y) < 3;
		}))
		{
			var seed = x + (y * 2000);
			var tree = new Entity();
			var bm = new Bitmap(TileResources.TREE);
			tree.add(new Sprite(bm, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
			var name = seed % 2 == 0 ? SpanishNameGenerator.getMaleName(seed) : SpanishNameGenerator.getFemaleName(seed);

			tree.add(new Moniker('${name} [${seed}]'));
			return tree;
		}

		return null;
	}
}
