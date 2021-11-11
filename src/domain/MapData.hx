package domain;

import common.struct.Grid;
import common.util.FloodFill;
import core.Game;
import domain.terrain.TerrainType;
import rand.PoissonDiscSampler;
import tools.Performance;

class MapData
{
	var hxdPerlin:hxd.Perlin;
	var seed:Int;
	var settlementDensity:Int;

	public var islands:Array<IslandData>;
	public var settlements:Array<SettlementData>;
	public var data:Grid<MapTile>;

	var world(get, never):World;

	function get_world():World
	{
		return Game.instance.world;
	}

	public function new(seed:Int)
	{
		this.seed = seed;
		hxdPerlin = new hxd.Perlin();
		hxdPerlin.normalize = true;
		settlementDensity = 40;

		islands = new Array();
		settlements = new Array();
		data = new Grid(world.mapWidth, world.mapHeight);
		data.fillFn(function(idx)
		{
			return new MapTile(idx, this);
		});

		Performance.start('map');
		generateHeight();
		generateTerrain();
		generateIslands();
		generateSettlements();
		Performance.stop('map');

		trace(Performance.friendly('map'));
		trace('islands', islands.length);
	}

	function perlin(x:Float, y:Float, octaves:Int)
	{
		var n = hxdPerlin.perlin(seed, x, y, 8);

		return (n + 1) / 2;
	}

	public function getTerrain(wx:Float, wy:Float):TerrainType
	{
		return data.get(wx.floor(), wy.floor()).terrain;
	}

	public function getIsland(wx:Float, wy:Float):IslandData
	{
		var tile = data.get(wx.floor(), wy.floor());

		return tile.island;
	}

	public function hasSettlement(wx:Float, wy:Float):Bool
	{
		var tile = data.get(wx.floor(), wy.floor());

		return tile.settlement != null;
	}

	function generateHeight()
	{
		var zoom = 80;

		for (tile in data)
		{
			var x = tile.x / zoom;
			var y = tile.y / zoom;

			tile.value.height = perlin(x, y, 8);
		}
	}

	function heightToTerrain(h:Float)
	{
		var waterline = .6;

		if (h < waterline - .04)
		{
			return WATER;
		}

		if (h < waterline)
		{
			return SHALLOWS;
		}

		if (h < waterline + .01)
		{
			return SAND;
		}

		return GRASS;
	}

	function generateTerrain()
	{
		for (tile in data)
		{
			tile.value.terrain = heightToTerrain(tile.value.height);
		}
	}

	function generateIslands()
	{
		while (generateIsland()) {};
	}

	var _isleIndex = 0;

	function generateIsland()
	{
		var islandId = islands.length;
		var start = null;
		var island = new IslandData(islandId, this);

		for (idx in _isleIndex...data.size)
		{
			var tile = data.getAt(idx);

			if ((tile.terrain == GRASS || tile.terrain == SAND) && !tile.hasIsland)
			{
				start = data.coord(idx);
				_isleIndex = idx;
				break;
			}
		}

		if (start == null)
		{
			return false;
		}

		FloodFill.flood(start, function(point)
		{
			var tile = data.get(point.x, point.y);
			if (tile == null)
			{
				return false;
			}

			var terrain = tile.terrain;

			if ((terrain == GRASS || terrain == SAND) && !tile.hasIsland)
			{
				tile.islandId = islandId;
				island.tiles.push(point);
				return true;
			}

			return false;
		});

		trace('island generated', island.id, island.size);

		islands.push(island);

		return true;
	}

	function generateSettlements()
	{
		var sampler = new PoissonDiscSampler(world.mapWidth, world.mapHeight, settlementDensity);
		var point = sampler.sample();

		while (point != null)
		{
			var tile = data.get(point.x, point.y);

			if (tile.terrain == GRASS || tile.terrain == SAND)
			{
				var settlementId = settlements.length;
				var settlement = new SettlementData(settlementId, this);

				settlement.x = point.x;
				settlement.y = point.y;
				settlements.push(settlement);

				tile.settlementId = settlementId;
			}

			point = sampler.sample();
		}
	}
}
