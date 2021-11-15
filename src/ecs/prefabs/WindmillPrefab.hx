package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Moniker;
import ecs.components.Sprite;

class WindmillPrefab
{
	public static function Create(seed:Int)
	{
		var windmill = new Entity();

		var animation = new h2d.Anim(TileResources.WINDMILL, 2);

		windmill.add(new Sprite(animation, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		windmill.add(new Moniker('Windmill'));

		return windmill;
	}
}
