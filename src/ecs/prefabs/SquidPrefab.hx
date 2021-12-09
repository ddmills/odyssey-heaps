package ecs.prefabs;

import core.Game;
import data.DiceCombos;
import data.TileResources;
import ecs.components.Energy;
import ecs.components.Mob;
import ecs.components.Moniker;
import ecs.components.Sprite;

class SquidPrefab
{
	public static function Create()
	{
		var squid = new Entity();
		var animation = new h2d.Anim(TileResources.SQUID, 6);

		squid.add(new Sprite(animation, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		squid.add(new Moniker('Giant squid'));
		squid.add(new Energy(-5));
		squid.add(new Mob([TENTACLE, TENTACLE], DiceCombos.SQUID));

		return squid;
	}
}
