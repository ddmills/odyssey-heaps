package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Moniker;
import ecs.components.Sprite;

class FarmPrefab
{
	public static function Create(seed:Int)
	{
		var farm = new Entity();
		farm.add(new Sprite(new h2d.Bitmap(TileResources.FARM), Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		farm.add(new Moniker('Farm'));

		return farm;
	}
}
