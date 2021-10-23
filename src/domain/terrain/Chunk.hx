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
	public var wx(get, null):Int;
	public var wy(get, null):Int;
	public var px(get, null):Int;
	public var py(get, null):Int;

	inline function get_wx()
	{
		return cx * size;
	}

	inline function get_wy()
	{
		return cy * size;
	}

	inline function get_px()
	{
		return wx * Game.instance.TSIZE;
	}

	inline function get_py()
	{
		return wy * Game.instance.TSIZE;
	}

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

		tiles.x = px;
		tiles.y = py;

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
		var sheet = hxd.Res.img.spritesheet.toTile();
		var t1 = sheet.sub(8, 0, 8, 8);
		var t2 = sheet.sub(16, 0, 8, 8);
		var t3 = sheet.sub(24, 0, 8, 8);

		var tiles = new h2d.TileGroup();

		for (t in terrain)
		{
			var tile = t.value == WATER ? t1 : t3;
			var x = Game.instance.TSIZE * t.x;
			var y = Game.instance.TSIZE * t.y;

			tiles.add(x, y, tile);
		}

		return tiles;
	}
}
