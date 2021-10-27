package domain.terrain;

import common.struct.Grid;
import core.Game;
import h2d.TileGroup;

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

		terrain = Game.instance.world.chunkGen.generateTerrain(cx, cy, size);

		tiles = toTileGroup();

		parent.addChildAt(tiles, chunkId);

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
		var sheet = hxd.Res.img.iso32.toTile();
		var imgs = sheet.split(4);
		var water = imgs[1];
		var land = imgs[2];

		var tiles = new h2d.TileGroup();

		for (t in terrain)
		{
			var tile = t.value == WATER ? water : land;
			var pix = Game.instance.world.worldToPx(t.x, t.y);

			var offsetX = pix.x - Game.instance.TILE_W_HALF;
			var offsetY = pix.y - Game.instance.TILE_H;

			tiles.add(offsetX, offsetY, tile);
		}

		return tiles;
	}
}
