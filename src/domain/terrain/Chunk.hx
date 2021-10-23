package domain.terrain;

import common.struct.Grid;
import h2d.TileGroup;

class Chunk
{
	var terrain:Grid<TerrainType>;
	var size:Int;
	var chunkX:Int;
	var chunkY:Int;

	public var x(get, null):Int;
	public var y(get, null):Int;

	function get_x()
	{
		return chunkX * size * 8;
	}

	function get_y()
	{
		return chunkY * size * 8;
	}

	public function new(chunkX:Int, chunkY:Int, size:Int, terrain:Grid<TerrainType>)
	{
		this.size = size;
		this.terrain = terrain;
		this.chunkX = chunkX;
		this.chunkY = chunkY;
	}

	public function setTerrainTile(x:Int, y:Int, value:TerrainType)
	{
		terrain.set(x, y, value);
	}

	public function toTileGroup():TileGroup
	{
		var sheet = hxd.Res.img.spritesheet.toTile();
		var t1 = sheet.sub(8, 0, 8, 8);
		var t2 = sheet.sub(16, 0, 8, 8);
		var t3 = sheet.sub(24, 0, 8, 8);

		var tiles = new h2d.TileGroup();
		tiles.x = x;
		tiles.y = y;

		for (t in terrain)
		{
			var tile = t.value == WATER ? t1 : t3;
			var x = 8 * t.x;
			var y = 8 * t.y;

			tiles.add(x, y, tile);
		}

		return tiles;
	}
}
