package states.play;

import common.struct.Cardinal;
import common.struct.Coordinate;
import common.util.Bresenham;
import common.util.Buffer;
import core.Frame;
import core.GameState;
import data.TileResources;
import domain.systems.MovementSystem;
import domain.systems.System;
import domain.systems.VisionSystem;
import ecs.Entity;
import ecs.Query;
import ecs.components.Direction;
import ecs.components.Explored;
import ecs.components.Moniker;
import ecs.components.Move;
import ecs.components.MoveComplete;
import ecs.components.Sprite;
import ecs.components.Visible;
import ecs.components.Vision;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Layers;
import shaders.ShroudShader;
import tools.MonitorGraph;
import tools.Performance;
import tools.Stats;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var infoText:h2d.Text;
	var root:h2d.Object;
	var interactive:h2d.Interactive;
	var mouse:Coordinate;
	var click:Coordinate;
	var cursor:Entity;
	var sloop:Entity;
	var path:Array<{x:Int, y:Int}>;
	var curPathIdx:Int;
	var frames:Buffer<Float>;
	var graphs:Array<MonitorGraph>;
	var stats:Stats;
	var movement:System;
	var vision:System;

	public function new() {}

	override function create()
	{
		movement = new MovementSystem();
		vision = new VisionSystem();

		mouse = new Coordinate(0, 0, SCREEN);
		root = new Layers();

		cursor = new Entity();
		cursor.add(new Sprite(new Bitmap(TileResources.CURSOR), game.TILE_W_HALF));
		world.add(cursor);

		sloop = new Entity();
		sloop.x = 278;
		sloop.y = 488;
		sloop.add(new Moniker('Sloop'));
		sloop.add(new Sprite(new Anim(TileResources.SLOOP.split(8), 0), game.TILE_W_HALF, game.TILE_H));
		sloop.add(new Direction());
		sloop.add(new Vision(8, 1));
		world.add(sloop);

		var settlement = new Entity();
		settlement.x = 272;
		settlement.y = 485;
		settlement.add(new Sprite(new Bitmap(TileResources.SETTLEMENT), game.TILE_W_HALF, game.TILE_H));
		settlement.add(new Moniker('Settlement'));
		settlement.add(new Vision(2));
		world.add(settlement);

		var bizcat = hxd.Res.fnt.bizcat.toFont();
		infoText = new h2d.Text(bizcat);
		infoText.textAlign = Right;
		fpsText = new h2d.Text(bizcat);
		infoText.setScale(1);
		fpsText.setScale(1);
		infoText.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);
		fpsText.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);
		infoText.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x000000,
			alpha: .5
		};
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
		root.addChild(infoText);
		root.addChild(interactive);

		stats = new Stats();
		stats.attach(root);
		stats.show('movement');
		stats.show('vision');

		frames = new Buffer(128);
		hxd.Window.getInstance().addResizeEvent(onResize);

		scene.add(root, 0);

		game.camera.zoom = 2;
		game.camera.x = 0;
		game.camera.y = 0;
	}

	function onResize()
	{
		interactive.width = camera.width;
		interactive.height = camera.height;
	}

	override function update(frame:Frame)
	{
		Performance.start('movement');
		movement.update(frame);
		Performance.stop('movement');
		Performance.start('vision');
		vision.update(frame);
		Performance.stop('vision');

		var p = mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		cursor.pos = w;

		if (click != null)
		{
			var goal = click.toWorld().floor();
			path = Bresenham.getLine(sloop.x.floor(), sloop.y.floor(), goal.x.floor(), goal.y.floor());
			curPathIdx = 0;
			click = null;
		}

		if (path != null)
		{
			if (sloop.has(MoveComplete) || !sloop.has(Move))
			{
				curPathIdx++;
				if (curPathIdx == path.length)
				{
					path = null;
				}
				else
				{
					var goal = path[curPathIdx];
					var target = new Coordinate(goal.x, goal.y, WORLD);
					var tween = curPathIdx == path.length - 1 ? LERP : LINEAR;

					sloop.add(new Move(target, .1, tween));
				}
			}
		}

		game.camera.focus = game.camera.focus.lerp(sloop.pos, .1 * frame.tmod);

		world.entities.ysort(0);

		var txt = '';
		txt += '\n' + frame.fps.round().toString();
		txt += '\npixel ${p.toString()}';
		txt += '\nworld ${w.toString()}';
		txt += '\nchunk ${c.toString()} (${c.toChunkIdx()})';
		txt += '\nlocal ${w.toChunkLocal(c.x.floor(), c.y.floor()).toString()}';
		txt += '\nentities ${game.registry.size}';

		fpsText.text = txt;

		fpsText.alignBottom(scene, game.TILE_H);
		fpsText.alignLeft(scene, game.TILE_H);

		var entities = world.getEntitiesAt(mouse);
		var withNames = Lambda.filter(entities, function(e)
		{
			return e.has(Moniker);
		});
		var names = Lambda.map(withNames, function(e)
		{
			var moniker = e.get(Moniker);
			return '${moniker.displayName} (${e.id})';
		});
		infoText.text = names.join('\n');
		infoText.alignBottom(scene, game.TILE_H);
		infoText.alignRight(scene, game.TILE_H);

		frames.push(frame.fps / 60);
		stats.update();
	}

	override function destroy()
	{
		hxd.Window.getInstance().removeResizeEvent(onResize);
	}
}
