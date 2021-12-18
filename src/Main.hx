import core.Game;
import data.TextResource;
import data.TileResources;
import data.portraits.PortraitData;
import data.storylines.Stories;
import states.splash.SplashState;

class Main extends hxd.App
{
	var game:Game;

	static function main()
	{
		hxd.Res.initEmbed();
		new Main();
	}

	override function init()
	{
		TextResource.Init();
		TileResources.Init();
		PortraitData.Init();
		Stories.Init();
		hxd.Window.getInstance().title = "Privateers";
		game = Game.Create(this, new SplashState(1));
		game.backgroundColor = 0x1b1f23;
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
