package states.play;

import core.Frame;
import core.GameState;
import data.TileResources;
import domain.screens.SailScreen;
import ecs.Entity;
import ecs.components.Explored;
import ecs.components.Moniker;
import ecs.components.Sprite;
import ecs.components.Vision;
import h2d.Bitmap;

class PlayState extends GameState
{
	public function new() {}

	override function create()
	{
		world.player.initialize();
		world.player.x = 358;
		world.player.y = 535;

		var settlement = new Entity();
		settlement.x = 353;
		settlement.y = 530;
		settlement.add(new Sprite(new Bitmap(TileResources.SETTLEMENT), game.TILE_W_HALF, game.TILE_H));
		settlement.add(new Moniker('Settlement'));
		settlement.add(new Vision(3));
		world.add(settlement);

		scene.add(world.layers.root, 0);

		game.screens.set(new SailScreen());
	}
}
