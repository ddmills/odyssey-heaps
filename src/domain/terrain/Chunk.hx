package domain.terrain;

import common.struct.Grid;
import core.Game;
import h2d.TileGroup;
import rand.ChunkGen;

class Chunk
{
	public var terrain(default, null):Grid<TerrainType>;
	public var isLoaded(default, null):Bool;

	var tiles:TileGroup;
	var size:Int;
	var chunkId:Int;

	public var cx(default, null):Int;
	public var cy(default, null):Int;

	public function new(chunkId:Int, chunkX:Int, chunkY:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;

		cx = chunkX;
		cy = chunkY;
		terrain = new Grid<TerrainType>(size, size);
	}

	public function setTerrainTile(x:Int, y:Int, value:TerrainType)
	{
		terrain.set(x, y, value);
	}

	public function load(parent:h2d.Object)
	{
		if (isLoaded)
		{
			return;
		}

		terrain = ChunkGen.generateTerrain(cx, cy, size);

		tiles = toTileGroup();

		parent.addChild(tiles);

		var pix = Game.instance.world.chunkToPx(cx, cy);
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

		tiles.clear();
		tiles.remove();
		tiles = null;
		isLoaded = false;
	}

	public function toTileGroup():TileGroup
	{
		var width = Game.instance.TILE_W;
		var height = Game.instance.TILE_H;
		var sheet = hxd.Res.img.iso64.toTile();
		var t1 = sheet.sub(width, 0, width, height);
		var t2 = sheet.sub(width * 2, 0, width, height);
		var t3 = sheet.sub(width * 3, 0, width, height);

		var tiles = new h2d.TileGroup();

		for (t in terrain)
		{
			var tile = t.value == WATER ? t1 : t2;
			var pix = Game.instance.world.worldToPx(t.x, t.y);

			var realX = pix.x - Game.instance.TILE_W_HALF;
			// var realX = pix.x - Game.instance.TILE_W_HALF;

			tiles.add(realX, pix.y, tile);
		}

		return tiles;
	}
}
