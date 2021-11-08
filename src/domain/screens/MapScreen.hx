package domain.screens;

import core.Screen;
import domain.terrain.TerrainType;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import rand.ChunkGen;

class MapScreen extends Screen
{
	var ob:Object;

	public function new()
	{
		ob = new Object();
	}

	function terrainToColor(type:TerrainType)
	{
		switch type
		{
			case WATER | SHALLOWS:
				return 0x40596a;
			case SAND | GRASS:
				return 0x517342;
		}
	}

	function populateTile(wx:Int, wy:Int, granularity:Int, size:Int)
	{
		var type = world.chunkGen.getTerrain(wx, wy);
		var color = terrainToColor(type);
		var tile = Tile.fromColor(color, size, size);
		var bm = new Bitmap(tile);
		bm.x = (wx / granularity) * size;
		bm.y = (wy / granularity) * size;
		ob.addChild(bm);
	}

	function populate()
	{
		var mapWidth = game.world.mapWidth;
		var mapHeight = game.world.mapHeight;
		var granularity = 8;
		var size = 4;

		var w = (mapWidth / granularity).floor();
		var h = (mapHeight / granularity).floor();

		for (x in 0...w)
		{
			for (y in 0...h)
			{
				var wx = (x * granularity + (granularity / 2)).floor();
				var wy = (y * granularity + (granularity / 2)).floor();

				populateTile(wx, wy, granularity, size);
			}
		}

		var white = Tile.fromColor(0xffffff, size, size);
		var red = Tile.fromColor(0xff0000, size, size);
		var blink = new Anim([white, red], 4);

		blink.x = (world.player.x / granularity).floor() * size;
		blink.y = (world.player.y / granularity).floor() * size;
		ob.addChild(blink);
	}

	public override function onEnter()
	{
		populate();
		game.render(HUD, ob);
	}

	public override function onDestroy()
	{
		ob.remove();
	}

	override function onKeyUp(keyCode:Int)
	{
		if (keyCode == 77)
		{
			game.screens.pop();
		}
	}
}
