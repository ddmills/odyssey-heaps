package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Moniker;
import ecs.components.Sprite;
import h2d.Bitmap;

class TreePrefab
{
	public static function Create()
	{
		var tree = new Entity();
		var bm = new Bitmap(TileResources.TREE);
		tree.add(new Sprite(bm, Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		tree.add(new Moniker('Tree'));

		return tree;
	}
}
