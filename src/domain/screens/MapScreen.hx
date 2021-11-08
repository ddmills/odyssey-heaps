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
			case SHALLOWS:
				return 0x326475;
			case WATER:
				return 0x235465;
			case SAND:
				return 0xb3904d;
			case GRASS:
				return 0x57723a;
		}
	}

	function populateTile(wx:Int, wy:Int, granularity:Int, size:Int)
	{
		var type = world.chunkGen.getTerrain(wx, wy);
		var color = terrainToColor(type);
		var tile = Tile.fromColor(color, size, size);
		var bm = new Bitmap(tile);
		bm.x = (wx / granularity).floor() * size;
		bm.y = (wy / granularity).floor() * size;
		ob.addChild(bm);
	}

	function populate()
	{
		var mapWidth = game.world.mapWidth;
		var mapHeight = game.world.mapHeight;
		var granularity = 4;
		var size = 2;

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

		var white = Tile.fromColor(0xffffff, size, size, 0);
		var red = Tile.fromColor(0xe91e63, size, size);
		var blink = new Anim([white, red], 6);

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