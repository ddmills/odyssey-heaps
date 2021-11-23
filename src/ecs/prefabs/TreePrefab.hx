package ecs.prefabs;

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
		tree.add(new Sprite(bm, 16, 16));
		tree.add(new Moniker('Tree'));

		return tree;
	}
}
