package states.menu;

import core.GameState;
import data.TileResources;
import data.portraits.PortraitData;
import data.storylines.Stories;
import states.play.PlayState;

class MenuState extends GameState
{
	public function new() {}

	override function create()
	{
		TileResources.Init();
		PortraitData.Init();
		Stories.Init();

		game.setState(new PlayState());
	}
}
