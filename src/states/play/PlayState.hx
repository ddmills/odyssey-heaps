package states.play;

import core.Frame;
import core.GameState;
import h2d.Interactive;
import h2d.Layers;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var root:h2d.Object;
	var interactive:h2d.Interactive;
	var mx:Int;
	var my:Int;

	public function new() {}

	override function create()
	{
		root = new Layers();

		fpsText = new h2d.Text(hxd.res.DefaultFont.get());
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(.8, 1, .3);

		interactive = new Interactive(scene.camera.viewportWidth, scene.camera.viewportHeight);

		interactive.onMove = function(event:hxd.Event)
		{
			mx = Math.round(event.relX);
			my = Math.round(event.relY);
		}

		root.addChild(world.bg);
		root.addChild(fpsText);
		root.addChild(interactive);

		scene.add(root, 0);
	}

	override function update(frame:Frame)
	{
		world.bg.x -= frame.tmod;
		world.bg.y -= frame.tmod;

		// var wx = Math.floor((mx - map.x) / game.TSIZE);
		// var wy = Math.floor((my - map.y) / game.TSIZE);

		var px = mx - world.bg.x;
		var py = my - world.bg.y;

		var chunk = game.world.chunks.getChunkByPx(px, py);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(world.bg);
		}

		fpsText.text = Math.round(frame.fps).toString();
		fpsText.alignBottom(scene, game.TSIZE);
		fpsText.alignLeft(scene, game.TSIZE);
	}
}
