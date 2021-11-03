package states.menu;

import core.GameState;
import data.TileResources;
import states.play.PlayState;

class MenuState extends GameState
{
	public function new() {}

	override function create()
	{
		TileResources.Init();
		game.setState(new PlayState());
	}
}
