package states.play;

import common.struct.Coordinate;
import common.util.Bresenham;
import core.Frame;
import core.GameState;
import data.TileResources;
import domain.screens.SailScreen;
import ecs.Entity;
import ecs.components.Direction;
import ecs.components.Explored;
import ecs.components.Moniker;
import ecs.components.Move;
import ecs.components.MoveComplete;
import ecs.components.Sprite;
import ecs.components.Vision;
import h2d.Anim;
import h2d.Bitmap;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var infoText:h2d.Text;
	var sloop:Entity;
	var path:Array<{x:Int, y:Int}>;
	var curPathIdx:Int;

	public function new() {}

	override function create()
	{
		game.screens.set(new SailScreen());
		// game.screens.push(new StatsScreen());

		sloop = new Entity();
		sloop.x = 358;
		sloop.y = 535;
		sloop.add(new Moniker('Sloop'));
		sloop.add(new Sprite(new Anim(TileResources.SLOOP.split(8), 0), game.TILE_W_HALF, game.TILE_H));
		sloop.add(new Direction());
		sloop.add(new Vision(6, 1));
		world.add(sloop);

		var settlement = new Entity();
		settlement.x = 344;
		settlement.y = 525;
		settlement.add(new Sprite(new Bitmap(TileResources.SETTLEMENT), game.TILE_W_HALF, game.TILE_H));
		settlement.add(new Moniker('Settlement'));
		settlement.add(new Vision(3));
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

		game.render(HUD, fpsText);
		game.render(HUD, infoText);

		scene.add(world.layers.root, 0);

		game.camera.zoom = 2;
		game.camera.x = 0;
		game.camera.y = 0;
		game.camera.follow = sloop;
	}

	override function update(frame:Frame)
	{
		var p = camera.mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

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

					sloop.add(new Move(target, .1, LINEAR));
				}
			}
		}

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

		var entities = world.getEntitiesAt(camera.mouse);
		var withNames = Lambda.filter(entities, function(e)
		{
			return e.has(Moniker) && e.has(Explored);
		});
		var names = Lambda.map(withNames, function(e)
		{
			var moniker = e.get(Moniker);
			return '${moniker.displayName} (${e.id})';
		});
		infoText.text = names.join('\n');
		infoText.alignBottom(scene, game.TILE_H);
		infoText.alignRight(scene, game.TILE_H);
	}

	override function onMouseDown(pos:Coordinate)
	{
		var goal = pos.toWorld().floor();
		path = Bresenham.getLine(sloop.x.floor(), sloop.y.floor(), goal.x.floor(), goal.y.floor());
		curPathIdx = 0;
	}
}
