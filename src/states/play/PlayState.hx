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

	var cursor:h2d.Bitmap;

	public function new() {}

	override function create()
	{
		root = new Layers();

		var sheet = hxd.Res.img.iso64.toTile();
		var cursorTile = sheet.sub(game.TILE_W * 3, 0, game.TILE_W, game.TILE_H);
		cursor = new h2d.Bitmap(cursorTile);

		fpsText = new h2d.Text(hxd.res.DefaultFont.get());
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(.8, 1, .3);

		interactive = new Interactive(scene.camera.viewportWidth, scene.camera.viewportHeight);

		interactive.onMove = function(event:hxd.Event)
		{
			mx = Math.round(event.relX);
			my = Math.round(event.relY);
		}

		root.addChild(world.container);
		world.container.addChild(cursor);
		// root.addChild(cursor);
		root.addChild(fpsText);
		root.addChild(interactive);

		scene.add(root, 0);
	}

	override function update(frame:Frame)
	{
		world.container.x -= frame.tmod / 4;
		world.container.y -= frame.tmod / 2;

		var p = world.screenToPx(mx, my);
		var w = world.pxToWorld(p.x, p.y);
		var c = world.pxToChunk(p.x, p.y);
		var chunk = world.chunks.getChunkByPx(p.x, p.y);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(world.bg);
		}

		var txt = Math.round(frame.fps).toString();

		txt += ' w=${w.x},${w.y} c=${c.x},${c.y} p=${p.x},${p.y} s=${mx},${my}';

		var cpx = world.worldToPx(w.x, w.y);
		cursor.x = cpx.x - game.TILE_W_HALF;
		cursor.y = cpx.y;

		fpsText.text = txt;
		// fpsText.text = Math.round(frame.fps).toString();

		fpsText.alignBottom(scene, game.TILE_H);
		fpsText.alignLeft(scene, game.TILE_H);
	}
}
