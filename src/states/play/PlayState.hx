package states.play;

import core.Frame;
import core.GameState;
import domain.terrain.Chunk;
import domain.terrain.ChunkManager;
import h2d.Interactive;
import h2d.Layers;

class PlayState extends GameState
{
	var fpsText:h2d.Text;
	var root:h2d.Object;
	var map:h2d.Object;
	var chunks:ChunkManager;
	var interactive:h2d.Interactive;
	var mx:Int;
	var my:Int;

	public function new() {}

	override function create()
	{
		root = new Layers();
		map = new Layers();

		fpsText = new h2d.Text(hxd.res.DefaultFont.get());
		fpsText.setScale(2);
		fpsText.color = new h3d.Vector(.8, 1, .3);

		chunks = new ChunkManager();
		interactive = new Interactive(scene.camera.viewportWidth, scene.camera.viewportHeight);

		interactive.onMove = function(event:hxd.Event)
		{
			mx = Math.round(event.relX);
			my = Math.round(event.relY);
		}

		root.addChild(map);
		root.addChild(fpsText);
		root.addChild(interactive);

		scene.add(root, 0);
	}

	override function update(frame:Frame)
	{
		map.x -= frame.tmod;
		map.y -= frame.tmod;

		var wx = Math.floor((mx - map.x) / game.TSIZE);
		var wy = Math.floor((my - map.y) / game.TSIZE);

		var chunk = chunks.getChunkByWorld(wx, wy);

		if (chunk != null && !chunk.isLoaded)
		{
			chunk.load(map);
		}

		fpsText.text = '${Math.round(frame.fps)} c=${chunk.cx},${chunk.cy} w=${wx},${wy}';
		fpsText.alignBottom(scene, game.TSIZE);
		fpsText.alignLeft(scene, game.TSIZE);
	}
}
