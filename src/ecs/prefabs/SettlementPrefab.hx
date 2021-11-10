package ecs.prefabs;

import core.Game;
import data.TileResources;
import ecs.components.Moniker;
import ecs.components.Settlement;
import ecs.components.Sprite;
import rand.names.SpanishNameGenerator;

class SettlementPrefab
{
	public static function Create(seed:Int)
	{
		var settlement = new Entity();
		settlement.add(new Sprite(new h2d.Bitmap(TileResources.SETTLEMENT), Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		settlement.add(new Moniker('Settlement'));
		var name = SpanishNameGenerator.getSettlementName(seed);
		settlement.add(new Settlement(name));

		return settlement;
	}
}
