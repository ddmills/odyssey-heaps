package common.extensions;

import h2d.Tile;

class TileExtensions
{
	public static function divide(tile:Tile, sizeX:Int, sizeY:Int):Array<Array<Tile>>
	{
		var tileW = Math.floor(tile.width / sizeX);
		var tileH = Math.floor(tile.height / sizeY);
		var tiles = new Array<Array<Tile>>();

		for (y in 0...sizeY)
		{
			var row = new Array<Tile>();

			for (x in 0...sizeX)
			{
				row.push(tile.sub(x * tileW, y * tileH, tileW, tileH));
			}

			tiles.push(row);
		}

		return tiles;
	}
}
