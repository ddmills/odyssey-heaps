package states.play;

import common.struct.Cardinal;
import common.struct.Coordinate;
import common.util.Bresenham;
import common.util.Buffer;
import core.Frame;
import core.GameState;
import data.TileResources;
import ecs.Entity;
import ecs.Query;
import ecs.components.Direction;
import ecs.components.Explored;
import ecs.components.Moniker;
import ecs.components.Rendered;
import ecs.components.Sprite;
import ecs.components.Visible;
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
	var exploredQuery:Query;
	var frames:Buffer<Float>;
	var graphs:Array<MonitorGraph>;
	var stats:Stats;
	var moved = true;

	public function new() {}

	override function create()
	{
		exploredQuery = new Query({
			all: [Explored, Sprite],
			none: [Visible]
		});

		var shroud = new ShroudShader(.15, .7);
		exploredQuery.onEntityAdded(function(entity)
		{
			var sprite = entity.get(Sprite);
			sprite.visible = true;
			sprite.ob.addShader(shroud);
		});
		exploredQuery.onEntityRemoved(function(entity)
		{
			var sprite = entity.get(Sprite);
			sprite.ob.removeShader(shroud);
			if (!entity.has(Explored))
			{
				sprite.visible = false;
			}
		});

		mouse = new Coordinate(0, 0, SCREEN);
		root = new Layers();

		cursor = new Entity();
		cursor.add(new Sprite(new Bitmap(TileResources.CURSOR), game.TILE_W_HALF));
		world.add(cursor);

		sloop = new Entity();
		sloop.add(new Moniker('Sloop'));
		sloop.add(new Sprite(new Anim(TileResources.SLOOP.split(8), 0), game.TILE_W_HALF, game.TILE_H));
		sloop.add(new Direction());
		sloop.x = 278;
		sloop.y = 488;
		world.add(sloop);

		var settlement = new Entity();
		settlement.add(new Sprite(new Bitmap(TileResources.SETTLEMENT), game.TILE_W_HALF, game.TILE_H));
		settlement.add(new Moniker('Settlement'));
		settlement.x = 272;
		settlement.y = 485;
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
			var startPos = sloop.pos;
			var goal = path[curPathIdx];
			var target = new Coordinate(goal.x, goal.y, WORLD);

			if (curPathIdx == path.length - 1)
			{
				sloop.pos = sloop.pos.lerp(target, frame.tmod * .1);
				var angle = target.sub(sloop.pos).angle();
				var cardinal = Cardinal.fromDegrees(angle.toDegrees());
				sloop.get(Direction).cardinal = cardinal;
				var distanceSq = sloop.pos.distanceSq(target, WORLD);

				if (distanceSq < .01)
				{
					sloop.pos = target;
					curPathIdx++;
				}
			}
			else
			{
				var direction = target.sub(sloop.pos).normalized();

				var deltaPerFrame = .08;
				var dx = direction.x * frame.tmod * deltaPerFrame;
				var dy = direction.y * frame.tmod * deltaPerFrame;
				var speedSq = new Coordinate(dx, dy, WORLD).lengthSq();
				var distanceSq = sloop.pos.distanceSq(target, WORLD);

				if (distanceSq < speedSq)
				{
					sloop.pos = target;
					curPathIdx++;
				}
				else
				{
					sloop.x += dx;
					sloop.y += dy;

					var angle = target.sub(sloop.pos).angle();
					var cardinal = Cardinal.fromDegrees(angle.toDegrees());
					sloop.get(Direction).cardinal = cardinal;
				}
			}
			var curPos = sloop.pos;
			moved = curPos.x.floor() != startPos.x.floor() || curPos.y.floor() != startPos.y.floor();
		}

		game.camera.focus = game.camera.focus.lerp(sloop.pos, .1 * frame.tmod);

		Performance.start('explore');
		if (moved)
		{
			var exploreCircle = Bresenham.getCircle(sloop.x.floor(), sloop.y.floor(), 10, true);
			for (point in exploreCircle)
			{
				world.explore(new Coordinate(point.x, point.y, WORLD));
			}

			var visCircle = Bresenham.getCircle(sloop.x.floor(), sloop.y.floor(), 8, true);
			var vis = Coordinate.FromPoints(visCircle, WORLD);
			world.setVisible(vis);

			world.entities.ysort(0);
			moved = false;
		}
		Performance.stop('explore');

		var txt = '';
		txt += '\n' + frame.fps.round().toString();
		txt += '\npixel ${p.toString()}';
		txt += '\nworld ${w.toString()}';
		txt += '\nchunk ${c.toString()} (${c.toChunkIdx()})';
		txt += '\nlocal ${w.toChunkLocal(c.x.floor(), c.y.floor()).toString()}';
		txt += '\nentities ${game.registry.size}';
		txt += '\nexplored ${exploredQuery.size}';

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
