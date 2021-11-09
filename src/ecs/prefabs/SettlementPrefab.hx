package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Moniker;
import ecs.components.Settlement;
import ecs.components.Sprite;

class SettlementPrefab
{
	public static function Create()
	{
		var settlement = new Entity();
		settlement.add(new Sprite(new h2d.Bitmap(TileResources.SETTLEMENT), Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		settlement.add(new Moniker('Settlement'));
		settlement.add(new Settlement('Port Troutberk'));

		return settlement;
	}
}
