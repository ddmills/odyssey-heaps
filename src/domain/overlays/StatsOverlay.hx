package domain.overlays;

import core.Game;
import data.TextResource;
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

		fpsText = TextResource.MakeText();
		infoText = TextResource.MakeText();
		infoText.textAlign = Right;

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
		var f = game.camera.focus.toPx();
		var cam = game.camera.pos.toPx();
		var w = p.toWorld().floor();
		var c = p.toChunk().floor();

		var island = world.map.getIsland(w.x, w.y);

		var txt = '';
		txt += '\n' + game.frame.fps.round().toString();
		txt += '\nfocus ${f.toString()}';
		txt += '\ncamera ${cam.toString()}';
		txt += '\npixel ${p.toString()}';
		txt += '\nworld ${w.toString()}';
		txt += '\nchunk ${c.toString()} (${c.toChunkIdx()})';
		txt += '\nlocal ${w.toChunkLocal(c.x.floor(), c.y.floor()).toString()}';
		txt += '\nentities ${game.registry.size}';

		if (island != null)
		{
			txt += '\nisland ${island.id.toString()} (${island.tiles.length.toString()} tiles)';
		}
		else
		{
			txt += '\nocean';
		}

		fpsText.text = txt;
		fpsText.alignBottom(game.state.scene, game.TILE_H);
		fpsText.alignLeft(game.state.scene, game.TILE_H);

		var entities = world.getEntitiesAt(p);
		var names = entities.filter((e) ->
		{
			return e.has(Moniker) && e.has(Explored);
		}).map((e) ->
		{
			var moniker = e.get(Moniker);
			return '${moniker.displayName} (${e.id})';
		});
		infoText.text = names.join('\n');
		infoText.alignBottom(game.state.scene, game.TILE_H);
		infoText.alignRight(game.state.scene, game.TILE_H);
	}
}
