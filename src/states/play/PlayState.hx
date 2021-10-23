package states.play;

import core.Frame;
import core.GameState;
import h2d.Layers;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var root:h2d.Object;

	public function new() {}

	override function create()
	{
		root = new Layers();

		fpsText = new h2d.Text(hxd.res.DefaultFont.get(), root);
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(1, .4, .4);

		scene.add(root, 0);
	}

	override function update(frame:Frame)
	{
		fpsText.text = '${Math.round(frame.fps)}';
	}
}
