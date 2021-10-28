package states.play;

import common.struct.Coordinate;
import core.Frame;
import core.GameState;
import domain.Entity;
import domain.entities.Ship;
import h2d.Interactive;
import h2d.Layers;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var root:h2d.Object;
	var interactive:h2d.Interactive;
	var mouse:Coordinate;
	var click:Coordinate;
	var cursor:Entity;
	var building:Entity;
	var sloop:Ship;
	var target:Coordinate;

	public function new() {}

	override function create()
	{
		mouse = new Coordinate(0, 0, SCREEN);
		root = new Layers();

		var tiles = hxd.Res.img.iso32.toTile().split(4);
		cursor = new Entity(new h2d.Bitmap(tiles[3]));
		building = new Entity(new h2d.Bitmap(tiles[0]));

		sloop = new Ship();

		building.x = 280;
		building.y = 280;

		world.add(cursor);
		world.add(building);
		world.add(sloop);

		fpsText = new h2d.Text(hxd.res.DefaultFont.get());
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);

		interactive = new Interactive(scene.camera.viewportWidth, scene.camera.viewportHeight);

		interactive.onMove = function(event:hxd.Event)
		{
			mouse = new Coordinate(event.relX, event.relY, SCREEN);
		}

		interactive.onClick = function(event:hxd.Event)
		{
			click = new Coordinate(event.relX, event.relY, SCREEN);
		}

		root.addChild(world.container);
		root.addChild(fpsText);
		root.addChild(interactive);

		scene.add(root, 0);

		game.camera.zoom = 2;
		game.camera.x = 23;
		game.camera.y = 23;
	}

	override function update(frame:Frame)
	{
		// game.camera.x += .04 * frame.tmod;
		// game.camera.y += .04 * frame.tmod;
		// game.camera.zoom -= .002 * frame.tmod;

		var p = mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		if (click != null)
		{
			target = click.toWorld().floor();
			click = null;
		}

		if (target != null)
		{
			sloop.pos = sloop.pos.lerp(target, frame.tmod * .1);
		}

		world.entities.ysort(0);

		var chunk = world.chunks.getChunk(c.x, c.y);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(world.bg);
		}

		var txt = '';
		txt += '\ncam=${camera.x.round()},${camera.y.round()}';
		txt += '\nzoom=${camera.zoom}';
		txt += '\nchunk=${c.toString()}';
		txt += '\nworld=${w.toString()}';
		txt += '\npixel=${p.x.floor()},${p.y.floor()}';
		txt += '\n' + frame.fps.round().toString();

		fpsText.text = txt;

		fpsText.alignBottom(scene, game.TILE_H);
		fpsText.alignLeft(scene, game.TILE_H);
	}
}
