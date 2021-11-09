package states.play;

import core.Frame;
import core.GameState;
import data.TileResources;
import domain.screens.SailScreen;
import ecs.Entity;
import ecs.components.Moniker;
import ecs.components.Settlement;
import ecs.components.Sprite;
import ecs.components.Vision;
import ecs.prefabs.SettlementPrefab;
import h2d.Bitmap;
import rand.names.SpanishNameGenerator;

class PlayState extends GameState
{
	public function new() {}

	override function create()
	{
		world.InitSystems();
		world.player.initialize();
		world.player.x = 358;
		world.player.y = 535;

		var settlement = SettlementPrefab.Create();
		settlement.x = 353;
		settlement.y = 530;
		world.add(settlement);

		scene.add(world.layers.root, 0);

		game.screens.set(new SailScreen());
	}
}
