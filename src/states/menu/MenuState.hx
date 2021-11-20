package states.menu;

import core.GameState;
import data.TileResources;
import data.portraits.PortraitData;
import states.play.PlayState;

class MenuState extends GameState
{
	public function new() {}

	override function create()
	{
		TileResources.Init();
		PortraitData.Init();
		game.setState(new PlayState());
	}
}
