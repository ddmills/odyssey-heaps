package domain.terrain;

import common.struct.Grid;
import core.Game;
import h2d.Bitmap;
import h2d.TileGroup;

class Chunk
{
	public var terrain(default, null):Grid<TerrainType>;
	public var exploration(default, null):Grid<ExploreType>;
	public var isLoaded(default, null):Bool;

	var tiles:TileGroup;
	var fog:h2d.Object;
	var size:Int;

	public var chunkId(default, null):Int;
	public var cx(default, null):Int;
	public var cy(default, null):Int;

	var explorationTiles:Array<h2d.Tile>;
	var terrainTiles:Array<h2d.Tile>;

	public function new(chunkId:Int, chunkX:Int, chunkY:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;

		cx = chunkX;
		cy = chunkY;
		terrain = new Grid<TerrainType>(size, size);
		exploration = new Grid<ExploreType>(size, size);

		var explorationSheet = hxd.Res.img.mask32.toTile();
		explorationTiles = explorationSheet.split(4);

		var terrainSheet = hxd.Res.img.iso32.toTile();
		terrainTiles = terrainSheet.split(4);
	}

	public function setExplore(x:Int, y:Int, value:ExploreType)
	{
		var idx = exploration.idx(x, y);
		if (idx < 0)
		{
			return;
		}

		var isExplored = value == EXPLORED;
		var child = fog.getChildAt(idx);
		if (child != null)
		{
			child.remove();
		}

		if (isExplored)
		{
			fog.addChildAt(new h2d.Object(), idx);
		}
		else
		{
			var pix = Game.instance.world.worldToPx(x, y);
			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y;
			var ob = new Bitmap(explorationTiles[3]);
			ob.x = offsetX;
			ob.y = offsetY;

			tiles.addChildAt(ob, idx);
		}
	}

	public function load(bgLayer:h2d.Object, fogLayer:h2d.Object)
	{
		if (isLoaded)
		{
			return;
		}

		terrain = Game.instance.world.chunkGen.generateTerrain(cx, cy, size);
		exploration.fill(UNEXPLORED);

		tiles = buildTerrainTileGroup();
		fog = buildFogObject();

		bgLayer.addChildAt(tiles, chunkId);
		fogLayer.addChildAt(fog, chunkId);

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
		var water = terrainTiles[1];
		var land = terrainTiles[2];

		var tiles = new h2d.TileGroup();

		for (t in terrain)
		{
			var tile = t.value == WATER ? water : land;
			var pix = Game.instance.world.worldToPx(t.x, t.y);

			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y;

			tiles.add(offsetX, offsetY, tile);
		}

		return tiles;
	}

	public function buildFogObject():h2d.Object
	{
		var unexploredTile = explorationTiles[3];
		var tiles = new h2d.Object();

		for (t in exploration)
		{
			var isExplored = t.value == EXPLORED;

			if (!isExplored)
			{
				var pix = Game.instance.world.worldToPx(t.x, t.y);
				var offsetX = pix.x - Game.instance.TILE_W_HALF;
				var offsetY = pix.y;
				var ob = new Bitmap(unexploredTile);
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
}
