package states.play;

import common.struct.Cardinal;
import common.struct.Coordinate;
import common.util.Bresenham;
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
	var path:Array<{x:Int, y:Int}>;
	var curPathIdx:Int;

	public function new() {}

	override function create()
	{
		mouse = new Coordinate(0, 0, SCREEN);
		root = new Layers();

		var tiles = hxd.Res.img.iso32.toTile().split(4);
		cursor = new Entity(new h2d.Bitmap(tiles[3]));
		building = new Entity(new h2d.Bitmap(tiles[0]));

		sloop = new Ship();

		sloop.x = 1;
		sloop.y = 1;

		building.x = 30;
		building.y = 15;

		world.add(cursor);
		world.add(building);
		world.add(sloop);

		fpsText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		fpsText.setScale(1);
		fpsText.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);
		fpsText.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x000000,
			alpha: .5
		};

		interactive = new Interactive(camera.width, camera.height);
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

		hxd.Window.getInstance().addResizeEvent(onResize);

		scene.add(root, 0);

		game.camera.zoom = 3;
		game.camera.x = -1;
		game.camera.y = 0;
	}

	function onResize()
	{
		interactive.width = camera.width;
		interactive.height = camera.height;
	}

	override function update(frame:Frame)
	{
		var p = mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		cursor.pos = w;

		if (click != null)
		{
			var goal = click.toWorld().floor();
			path = Bresenham.getLine(sloop.x.floor(), sloop.y.floor(), goal.x.floor(), goal.y.floor());
			curPathIdx = 1;
			click = null;
		}

		if (path != null && curPathIdx < path.length)
		{
			var goal = path[curPathIdx];
			var target = new Coordinate(goal.x, goal.y, WORLD);

			var angle = target.sub(sloop.pos).angle();
			var cardinal = Cardinal.fromDegrees(angle.toDegrees());
			sloop.cardinal = cardinal;

			var direction = target.sub(sloop.pos).normalized();

			sloop.x += direction.x * frame.tmod * .05;
			sloop.y += direction.y * frame.tmod * .05;

			var distance = sloop.pos.manhattan(target);

			if (distance < .1)
			{
				sloop.pos = target;
				curPathIdx++;
			}
		}

		world.entities.ysort(0);

		var chunk = world.chunks.getChunk(c.x, c.y);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(world.bg, world.fog);
		}

		game.camera.focus = game.camera.focus.lerp(sloop.pos, .1 * frame.tmod);

		var visCircle = Bresenham.getCircle(sloop.x.floor(), sloop.y.floor(), 4, true);
		var vis = Coordinate.FromPoints(visCircle, WORLD);
		world.setVisible(vis);

		var txt = '';
		txt += '\npixel ${p.toString()}';
		txt += '\nworld ${w.toString()}';
		txt += '\nchunk ${c.toString()}';
		txt += '\nlocal ${w.toChunkLocal(c.x.floor(), c.y.floor()).toString()}';
		txt += '\n' + frame.fps.round().toString();

		fpsText.text = txt;

		fpsText.alignBottom(scene, game.TILE_H);
		fpsText.alignLeft(scene, game.TILE_H);
	}

	override function destroy()
	{
		hxd.Window.getInstance().removeResizeEvent(onResize);
	}
}
