package states.play;

import core.GameState;
import domain.screens.SailScreen;

class PlayState extends GameState
{
	public function new() {}

	override function create()
	{
		world.InitSystems();
		world.player.initialize();
		world.player.x = 311;
		world.player.y = 506;

		scene.add(world.layers.root, 0);

		game.screens.set(new SailScreen());
	}
}
