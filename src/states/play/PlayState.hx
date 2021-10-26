package states.play;

import common.struct.Coordinate;
import core.Frame;
import core.GameState;
import h2d.Interactive;
import h2d.Layers;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var root:h2d.Object;
	var interactive:h2d.Interactive;
	var mouse:Coordinate;

	var cursor:h2d.Bitmap;

	public function new() {}

	override function create()
	{
		mouse = new Coordinate(0, 0, SCREEN);
		root = new Layers();

		var sheet = hxd.Res.img.iso32.toTile();
		var cursorTile = sheet.sub(game.TILE_W * 3, game.TILE_H, game.TILE_W, game.TILE_H);
		cursor = new h2d.Bitmap(cursorTile);

		fpsText = new h2d.Text(hxd.res.DefaultFont.get());
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);

		interactive = new Interactive(scene.camera.viewportWidth, scene.camera.viewportHeight);

		interactive.onMove = function(event:hxd.Event)
		{
			mouse = new Coordinate(event.relX, event.relY, SCREEN);
		}

		world.container.addChild(cursor);
		root.addChild(world.container);
		root.addChild(fpsText);
		root.addChild(interactive);

		scene.add(root, 0);

		game.camera.zoom = 2;
	}

	override function update(frame:Frame)
	{
		// game.camera.x += .1 * frame.tmod;
		// game.camera.y += .1 * frame.tmod;
		// game.camera.zoom -= .002 * frame.tmod;

		var p = mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		var chunk = world.chunks.getChunk(c.x, c.y);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(world.bg);
		}
		var cpx = w.toPx();

		var txt = '';
		txt += '\ncam=${camera.x.round()},${camera.y.round()}';
		txt += '\nzoom=${camera.zoom}';
		txt += '\nchunk=${c.toString()}';
		txt += '\nworld=${w.toString()}';
		txt += '\npixel=${p.x.floor()},${p.y.floor()}';
		txt += '\n' + frame.fps.round().toString();

		cursor.x = cpx.x - game.TILE_W_HALF;
		cursor.y = cpx.y;

		fpsText.text = txt;

		fpsText.alignBottom(scene, game.TILE_H);
		fpsText.alignLeft(scene, game.TILE_H);
	}
}
