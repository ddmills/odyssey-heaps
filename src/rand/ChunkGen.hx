package rand;

import common.struct.Coordinate;
import core.Game;
import data.TileResources;
import domain.terrain.Chunk;
import ecs.Entity;
import ecs.components.Moniker;
import ecs.components.Sprite;
import ecs.prefabs.FarmPrefab;
import ecs.prefabs.SettlementPrefab;
import ecs.prefabs.TreePrefab;
import ecs.prefabs.WindmillPrefab;
import h2d.Bitmap;
import hxd.Perlin;
import hxd.Rand;
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
		var r = new Rand(seed + chunk.chunkId);

		for (i in chunk.exploration)
		{
			var wx = chunk.cx * chunk.size + i.x;
			var wy = chunk.cy * chunk.size + i.y;
			var tile = map.getTerrain(wx, wy);
			var settlementData = map.getSettlement(wx, wy);

			if (settlementData != null)
			{
				var s = wx + (wy * 2000);
				var settlement = SettlementPrefab.Create(settlementData.id, s);
				settlement.x = wx;
				settlement.y = wy;
				Game.instance.world.add(settlement);
				var neighbors = map.data.getNeighbors(wx, wy);
				var hasWindmill = false;
				r.shuffle(neighbors);

				for (neighbor in neighbors)
				{
					if (neighbor != null && neighbor.terrain == GRASS)
					{
						if (!hasWindmill)
						{
							var windmill = WindmillPrefab.Create(s);
							windmill.x = neighbor.x;
							windmill.y = neighbor.y;
							Game.instance.world.add(windmill);
							hasWindmill = true;
						}
						else
						{
							var farm = FarmPrefab.Create(s);
							farm.x = neighbor.x;
							farm.y = neighbor.y;
							Game.instance.world.add(farm);
						}
					}
				}
			}
			else if (tile == GRASS)
			{
				var treen = perlin.perlin(seed, wx / 4, wy / 4, 9);
				var treev = (treen + 1) / 2;
				if (treev > .6 && !nearSettlement(wx, wy))
				{
					var tree = TreePrefab.Create();
					tree.pos = new Coordinate(wx, wy, WORLD);
					Game.instance.world.add(tree);
				}
			}
		}
	}

	function nearSettlement(x:Int, y:Int)
	{
		var settlements = Game.instance.world.map.settlements;

		return settlements.exists((p) -> (x - p.x).abs() < 3 && (y - p.y).abs() < 3);
	}
}
