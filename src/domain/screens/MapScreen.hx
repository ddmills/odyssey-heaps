package domain.screens;

import common.struct.Coordinate;
import core.Screen;
import domain.terrain.TerrainType;
import domain.ui.Box;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;

class MapScreen extends Screen
{
	var map:Object;
	var box:Box;
	var granularity = 4;
	var tileSize = 2;

	public function new()
	{
		map = new Object();
	}

	function terrainToColor(type:TerrainType, explored:Bool)
	{
		switch type
		{
			case SHALLOWS | RIVER:
				return explored ? 0x326475 : 0xb2b5a2;
			case WATER:
				return explored ? 0x235465 : 0xd2d6b6;
			case SAND:
				return explored ? 0xb3904d : 0xc0c3b2;
			case GRASS:
				return explored ? 0x57723a : 0xb2b5a2;
		}
	}

	function populateTile(wx:Int, wy:Int)
	{
		var coord = new Coordinate(wx, wy, WORLD);
		var explored = world.isExplored(coord);
		var type = world.map.getTerrain(wx, wy);
		var color = terrainToColor(type, explored);
		var tile = Tile.fromColor(color, tileSize, tileSize);
		var bm = new Bitmap(tile);

		bm.x = (wx / granularity).floor() * tileSize;
		bm.y = (wy / granularity).floor() * tileSize;
		map.addChild(bm);
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

		for (s in world.map.settlements)
		{
			var coord = new Coordinate(s.x, s.y, WORLD);
			var isExplored = world.isExplored(coord);

			var color = isExplored ? 0x804c36 : 0x8e907e;
			var tile = Tile.fromColor(color, tileSize, tileSize);
			var point = new Bitmap(tile);

			point.x = (s.x / granularity).floor() * tileSize;
			point.y = (s.y / granularity).floor() * tileSize;
			map.addChild(point);
		}

		var white = Tile.fromColor(0xd2d6b6, tileSize, tileSize, 0);
		var red = Tile.fromColor(0xe91e63, tileSize, tileSize);
		var blink = new Anim([white, red], 6);

		blink.x = (world.player.x / granularity).floor() * tileSize;
		blink.y = (world.player.y / granularity).floor() * tileSize;
		map.addChild(blink);
	}

	public override function onEnter()
	{
		populate();

		var mapWidth = (tileSize * (game.world.mapWidth / granularity).floor()) / 32;
		var mapHeight = (tileSize * (game.world.mapHeight / granularity).floor()) / 32;

		box = new Box({
			width: mapWidth.floor() + 2,
			height: mapHeight.floor() + 2,
			scale: 2,
			size: 16,
		});

		box.addChild(map);
		map.x = 32;
		map.y = 32;

		box.x = 64;
		box.y = 64;
		game.render(HUD, box);
	}

	public override function onDestroy()
	{
		map.remove();
		box.remove();
	}

	override function onKeyUp(keyCode:Int)
	{
		if (keyCode == 77)
		{
			game.screens.pop();
		}
	}
}
