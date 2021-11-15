package ecs.prefabs;

import core.Game;
import data.Professions;
import data.TileResources;
import ecs.components.Mob;
import ecs.components.Moniker;
import ecs.components.Profession;
import ecs.components.Sprite;

class SquidPrefab
{
	public static function Create(seed:Int)
	{
		var squid = new Entity();

		var animation = new h2d.Anim(TileResources.SQUID, 6);

		squid.add(new Sprite(animation, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		squid.add(new Profession(Professions.SQUID));
		squid.add(new Mob());
		squid.add(new Moniker('Giant squid'));

		return squid;
	}
}
