import core.Game;
import states.menu.MenuState;
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
		game = Game.Create(this, new SplashState(1));
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
