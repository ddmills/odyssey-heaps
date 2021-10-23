package states.menu;

import core.GameState;
import states.play.PlayState;

class MenuState extends GameState
{
	public function new() {}

	override function create()
	{
		game.setState(new PlayState());
	}
}
