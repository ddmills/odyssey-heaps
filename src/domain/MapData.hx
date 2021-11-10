package domain;

import common.struct.Grid;
import common.util.FloodFill;
import core.Game;
import domain.terrain.TerrainType;
import rand.PoissonDiscSampler;
import tools.Meter;
import tools.Performance;

class MapData
{
	var hxdPerlin:hxd.Perlin;
	var seed:Int;
	var settlementDensity:Int;
	var height:Grid<Null<Float>>;
	var terrain:Grid<TerrainType>;
	var islands:Grid<Null<Int>>;

	public var islandDat:Array<Array<{x:Int, y:Int}>>;

	public var settlements:Array<{x:Int, y:Int}>;

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

		height = new Grid(world.mapWidth, world.mapHeight);
		terrain = new Grid(world.mapWidth, world.mapHeight);
		islands = new Grid(world.mapWidth, world.mapHeight);
		settlements = new Array();
		islandDat = new Array();

		Performance.start('map');
		generateHeight();
		generateTerrain();
		generateIslands();
		generateSettlements();
		Performance.stop('map');
		trace(Performance.friendly('map'));
	}

	function perlin(x:Float, y:Float, octaves:Int)
	{
		var n = hxdPerlin.perlin(seed, x, y, 8);

		return (n + 1) / 2;
	}

	public function getTerrain(wx:Float, wy:Float):TerrainType
	{
		return terrain.get(wx.floor(), wy.floor());
	}

	public function hasSettlement(wx:Float, wy:Float):Bool
	{
		var fx = wx.floor();
		var fy = wy.floor();
		return Lambda.exists(settlements, function(p)
		{
			return fx == p.x && fy == p.y;
		});
	}

	function generateHeight()
	{
		var zoom = 80;

		height.fillFn(function(idx:Int)
		{
			var w = height.coord(idx);
			var x = w.x / zoom;
			var y = w.y / zoom;
			return perlin(x, y, 8);
		});
	}

	function generateTerrain()
	{
		var waterline = .6;

		terrain.fillFn(function(idx:Int)
		{
			var h = height.getAt(idx);

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
		});
	}

	function generateIslands()
	{
		islands.fill(-1);
		while (generateIsland()) {};
	}

	var _isleIndex = 0;

	function generateIsland()
	{
		var islandId = islandDat.length + 1;
		var start = null;

		for (idx in _isleIndex...terrain.size)
		{
			var land = terrain.getAt(idx);
			var isGrass = land == GRASS;
			var isUnassigned = islands.getAt(idx) == -1;

			if (isGrass && isUnassigned)
			{
				start = terrain.coord(idx);
				_isleIndex = idx;
				break;
			}
		}

		if (start == null || islandId > 500)
		{
			return false;
		}

		var isle = new Array<{x:Int, y:Int}>();

		FloodFill.flood(start, function(point)
		{
			var current = islands.get(point.x, point.y);
			var land = terrain.get(point.x, point.y);

			if (land == GRASS && current == -1)
			{
				isle.push(point);
				islands.set(point.x, point.y, islandId);
				return true;
			}

			return false;
		});

		islandDat.push(isle);

		return true;
	}

	function generateSettlements()
	{
		var sampler = new PoissonDiscSampler(world.mapWidth, world.mapHeight, settlementDensity);

		var s = sampler.sample();
		while (s != null)
		{
			var t = terrain.get(s.x, s.y);

			if (t == GRASS || t == SAND)
			{
				settlements.push(s);
			}

			s = sampler.sample();
		}
	}
}
