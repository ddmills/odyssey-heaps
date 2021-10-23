package states.splash;

import core.Frame;
import core.GameState;
import h2d.Layers;
import states.menu.MenuState;

using common.util.TextExtensions;

class SplashState extends GameState
{
	var text:h2d.Text;
	var root:h2d.Object;
	var duration:Int;

	public function new(duration:Int = 3)
	{
		this.duration = duration;
	}

	override function create()
	{
		root = new Layers();

		text = new h2d.Text(hxd.res.DefaultFont.get(), root);
		text.setScale(3);
		text.text = "Odyssey";
		text.color = new h3d.Vector(.4, .6, 1);

		scene.add(root, 0);
	}

	override function update(frame:Frame)
	{
		text.center(scene);

		if (frame.elapsed >= duration)
		{
			game.setState(new MenuState());
		}
	}
}
