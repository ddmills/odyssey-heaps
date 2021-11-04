package domain.terrain;

import common.struct.Grid;
import common.struct.GridMap;
import core.Game;
import data.TileResources;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Tile;
import h2d.TileGroup;

class Chunk
{
	public var terrain(default, null):Grid<TerrainType>;
	public var exploration(default, null):Grid<Null<Bool>>;
	public var entities(default, null):GridMap<String>;
	public var isLoaded(default, null):Bool;

	var tiles:TileGroup;
	var fog:h2d.Object;

	public var size(default, null):Int;

	public var chunkId(default, null):Int;
	public var cx(default, null):Int;
	public var cy(default, null):Int;
	public var wx(get, null):Int;
	public var wy(get, null):Int;

	public function new(chunkId:Int, chunkX:Int, chunkY:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;

		cx = chunkX;
		cy = chunkY;
		terrain = new Grid(size, size);
		exploration = new Grid(size, size);
		entities = new GridMap(size, size);
	}

	public function setExplore(x:Int, y:Int, isExplored:Bool, isVisible:Bool)
	{
		if (!isLoaded)
		{
			load();
			return;
		}
		var idx = exploration.idx(x, y);
		if (idx < 0)
		{
			return;
		}

		var child = fog.getChildAt(idx);
		if (child != null)
		{
			child.remove();
		}

		if (isExplored)
		{
			if (isVisible)
			{
				fog.addChildAt(new h2d.Object(), idx);
			}
			else
			{
				var pix = Game.instance.world.worldToPx(x, y);
				var offsetX = pix.x - Game.instance.TILE_W_HALF;
				var offsetY = pix.y;
				var ob = new Bitmap(TileResources.FOG);
				ob.alpha = .5;
				ob.x = offsetX;
				ob.y = offsetY;

				fog.addChildAt(ob, idx);
			}
		}
		else
		{
			var pix = Game.instance.world.worldToPx(x, y);
			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y;
			var ob = new Bitmap(TileResources.FOG);

			ob.x = offsetX;
			ob.y = offsetY;

			fog.addChildAt(ob, idx);
		}
	}

	public function load()
	{
		if (isLoaded)
		{
			return;
		}

		Game.instance.world.chunkGen.generate(this);
		exploration.fill(false);

		tiles = buildTerrainTileGroup();
		fog = buildFogObject();

		Game.instance.world.bg.addChildAt(tiles, chunkId);
		Game.instance.world.fog.addChildAt(fog, chunkId);

		var pix = Game.instance.world.chunkToPx(cx, cy);
		tiles.x = pix.x;
		tiles.y = pix.y;
		fog.x = pix.x;
		fog.y = pix.y;

		isLoaded = true;
	}

	public function unload()
	{
		if (!isLoaded)
		{
			return;
		}

		tiles.clear();
		tiles.remove();
		tiles = null;
		isLoaded = false;
	}

	public function buildTerrainTileGroup():TileGroup
	{
		var tiles = new h2d.TileGroup();

		for (t in terrain)
		{
			var tile = getTerrainTile(t.value);
			var pix = Game.instance.world.worldToPx(t.x, t.y);

			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y;

			tiles.add(offsetX, offsetY, tile);
		}

		return tiles;
	}

	function getTerrainTile(type:TerrainType):Tile
	{
		switch (type)
		{
			case WATER:
				return TileResources.GROUND_WATER;
			case SHALLOWS:
				return TileResources.GROUND_SHALLOWS;
			case SAND:
				return TileResources.GROUND_SAND;
			case GRASS:
				return TileResources.GROUND_GRASS;
		}
	}

	public function buildFogObject():h2d.Object
	{
		var tiles = new h2d.Object();

		for (t in exploration)
		{
			if (!t.value)
			{
				var pix = Game.instance.world.worldToPx(t.x, t.y);
				var offsetX = pix.x - Game.instance.TILE_W_HALF;
				var offsetY = pix.y;
				var ob = new Bitmap(TileResources.FOG);
				ob.x = offsetX;
				ob.y = offsetY;

				tiles.addChildAt(ob, t.idx);
			}
			else
			{
				tiles.addChildAt(new h2d.Object(), t.idx);
			}
		}

		return tiles;
	}

	function get_wx():Int
	{
		return cx * size;
	}

	function get_wy():Int
	{
		return cy * size;
	}

	public function removeEntity(entity:Entity)
	{
		entities.remove(entity.id);
	}

	public function setEntityPosition(entity:Entity)
	{
		var local = entity.pos.toChunkLocal(cx, cy).toWorld();
		entities.set(local.x.floor(), local.y.floor(), entity.id);
	}

	public function getEntityIdsAt(x:Float, y:Float):Array<String>
	{
		return entities.get(x.floor(), y.floor());
	}
}
