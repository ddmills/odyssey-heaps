package domain.ui;

import data.TileResources;
import h2d.Object;
import h2d.Tile;

typedef BoxOptions =
{
	width:Int,
	height:Int,
	scale:Float,
	size:Int,
};

class Box extends h2d.Object
{
	var opts:BoxOptions;

	public function new(opts:BoxOptions)
	{
		super();
		this.opts = opts;
		drawWindow();
	}

	function drawWindow()
	{
		removeChildren();

		var w = opts.width - 1;
		var h = opts.height - 1;

		for (x in 1...w)
		{
			addTile(TileResources.UI_BORDER_T, x, 0);
			addTile(TileResources.UI_BORDER_B, x, h);
			for (y in 1...h)
			{
				addTile(TileResources.UI_FILL, x, y);
			}
		}
		for (y in 1...h)
		{
			addTile(TileResources.UI_BORDER_L, 0, y);
			addTile(TileResources.UI_BORDER_R, w, y);
		}
		addTile(TileResources.UI_BORDER_TL, 0, 0);
		addTile(TileResources.UI_BORDER_TR, w, 0);
		addTile(TileResources.UI_BORDER_BR, w, h);
		addTile(TileResources.UI_BORDER_BL, 0, h);
	}

	function addTile(tile:Tile, x:Int, y:Int)
	{
		var bm = new h2d.Bitmap(tile);
		bm.x = (x * opts.size) * opts.scale;
		bm.y = (y * opts.size) * opts.scale;
		bm.scaleX = opts.scale;
		bm.scaleY = opts.scale;
		addChild(bm);
	}
}
