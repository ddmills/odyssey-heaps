package domain.terrain;

import common.struct.Grid;
import common.struct.GridMap;
import common.util.Projection;
import core.Game;
import data.TileResources;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Tile;
import shaders.ShroudShader;

class Chunk
{
	var tiles:h2d.Object; // TODO: switch to h2d.SpriteBatch
	var shroud:ShroudShader;

	public var exploration(default, null):Grid<Null<Bool>>;
	public var entities(default, null):GridMap<String>;
	public var bitmaps(default, null):Grid<Bitmap>;
	public var isLoaded(default, null):Bool;

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
		exploration = new Grid(size, size);
		entities = new GridMap(size, size);
		bitmaps = new Grid(size, size);
		shroud = new ShroudShader(.16, .7);
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

		exploration.setIdx(idx, isExplored);

		var bm = bitmaps.get(x, y);

		if (bm == null)
		{
			return;
		}

		bm.removeShader(shroud);

		if (isExplored)
		{
			bm.visible = true;
			if (!isVisible)
			{
				bm.addShader(shroud);
			}
		}
		else
		{
			bm.addShader(shroud);
			bm.visible = false;
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

		buildTiles();

		Game.instance.render(GROUND, tiles);

		var pix = Projection.chunkToPx(cx, cy);
		tiles.x = pix.x;
		tiles.y = pix.y;

		isLoaded = true;
	}

	public function unload()
	{
		if (!isLoaded)
		{
			return;
		}

		tiles.remove();
		tiles.removeChildren();
		bitmaps.clear();
		tiles = null;
		isLoaded = false;
	}

	function buildTiles()
	{
		tiles = new h2d.Object();

		for (t in bitmaps)
		{
			var wx = cx * size + t.x;
			var wy = cy * size + t.y;

			var terrain = Game.instance.world.map.getTerrain(wx, wy);
			var tile = getTerrainTile(terrain);
			var bm = new h2d.Bitmap(tile);
			bm.visible = false;

			var pix = Projection.worldToPx(t.x, t.y);
			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y;

			bm.x = offsetX;
			bm.y = offsetY;

			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	function getTerrainTile(type:TerrainType):Tile
	{
		switch (type)
		{
			case WATER:
				return TileResources.GROUND_WATER;
			case SHALLOWS | RIVER:
				return TileResources.GROUND_SHALLOWS;
			case SAND:
				return TileResources.GROUND_GRASS;
			case GRASS:
				return TileResources.GROUND_GRASS;
		}
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
