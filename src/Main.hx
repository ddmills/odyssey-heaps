import core.Game;
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
		game.backgroundColor = 0x1f1e1d;
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
