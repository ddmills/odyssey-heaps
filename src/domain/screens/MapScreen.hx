package domain.screens;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import domain.terrain.TerrainType;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import rand.ChunkGen;
import rand.PoissonDiscSampler;

class MapScreen extends Screen
{
	var ob:Object;
	var sampler:PoissonDiscSampler;
	var granularity = 4;
	var tileSize = 3;

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

	function populateTile(wx:Int, wy:Int)
	{
		var type = world.chunkGen.getTerrain(wx, wy);
		var color = terrainToColor(type);
		var tile = Tile.fromColor(color, tileSize, tileSize);
		var bm = new Bitmap(tile);
		bm.x = (wx / granularity).floor() * tileSize;
		bm.y = (wy / granularity).floor() * tileSize;
		ob.addChild(bm);
	}

	function populate()
	{
		var mapWidth = game.world.mapWidth;
		var mapHeight = game.world.mapHeight;

		var w = (mapWidth / granularity).floor();
		var h = (mapHeight / granularity).floor();

		for (x in 0...w)
		{
			for (y in 0...h)
			{
				var wx = (x * granularity + (granularity / 2)).floor();
				var wy = (y * granularity + (granularity / 2)).floor();

				populateTile(wx, wy);
			}
		}

		var white = Tile.fromColor(0xffffff, tileSize, tileSize, 0);
		var red = Tile.fromColor(0xe91e63, tileSize, tileSize);
		var blink = new Anim([white, red], 6);

		blink.x = (world.player.x / granularity).floor() * tileSize;
		blink.y = (world.player.y / granularity).floor() * tileSize;
		ob.addChild(blink);
	}

	public override function onEnter()
	{
		populate();
		game.render(HUD, ob);
		sampler = new PoissonDiscSampler(game.world.mapWidth, game.world.mapHeight, 40);
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

	override function update(frame:Frame)
	{
		var s = sampler.sample();
		if (s != null)
		{
			var t = world.chunkGen.getTerrain(s.x, s.y);

			if (t == GRASS || t == SAND)
			{
				var red = Tile.fromColor(0xe91e63, tileSize, tileSize);
				var point = new Bitmap(red);

				point.x = (s.x / granularity).floor() * tileSize;
				point.y = (s.y / granularity).floor() * tileSize;
				ob.addChild(point);
			}
			else
			{
				var blue = Tile.fromColor(0x0000ff, tileSize, tileSize);
				var point = new Bitmap(blue);

				point.x = (s.x / granularity).floor() * tileSize;
				point.y = (s.y / granularity).floor() * tileSize;
				ob.addChild(point);
			}
		}
	}
}
