package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Direction;
import ecs.components.Energy;
import ecs.components.Health;
import ecs.components.Inventory;
import ecs.components.IsPlayer;
import ecs.components.Moniker;
import ecs.components.Sprite;
import ecs.components.Vision;

class PlayerPrefab
{
	public static function Create()
	{
		var e = new Entity();

		e.add(new Moniker('Sloop'));
		e.add(new Sprite(new h2d.Anim(TileResources.SLOOP.split(8), 0), Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		e.add(new Direction());
		e.add(new Health(8, 8));
		e.add(new Vision(10, 1));
		e.add(new Energy());
		e.add(new Inventory());
		e.add(new IsPlayer());

		return e;
	}
}
