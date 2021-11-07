package domain.overlays;

import core.Game;
import ecs.components.Explored;
import ecs.components.Moniker;
import tools.Stats;

class StatsOverlay extends h2d.Object
{
	var stats:Stats;
	var fpsText:h2d.Text;
	var infoText:h2d.Text;

	public function new(stats:Stats)
	{
		super();
		this.stats = stats;

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
			alpha: .75
		};
		fpsText.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x000000,
			alpha: .75
		};

		addChild(stats.ob);
		addChild(fpsText);
		addChild(infoText);
	}

	public function update()
	{
		stats.update();

		var game = Game.instance;
		var world = game.world;

		var p = game.camera.mouse.toPx().floor();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		var txt = '';
		txt += '\n' + game.frame.fps.round().toString();
		txt += '\npixel ${p.toString()}';
		txt += '\nworld ${w.toString()}';
		txt += '\nchunk ${c.toString()} (${c.toChunkIdx()})';
		txt += '\nlocal ${w.toChunkLocal(c.x.floor(), c.y.floor()).toString()}';
		txt += '\nentities ${game.registry.size}';

		fpsText.text = txt;
		fpsText.alignBottom(game.state.scene, game.TILE_H);
		fpsText.alignLeft(game.state.scene, game.TILE_H);

		var entities = world.getEntitiesAt(p);
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
		infoText.alignBottom(game.state.scene, game.TILE_H);
		infoText.alignRight(game.state.scene, game.TILE_H);
	}
}
