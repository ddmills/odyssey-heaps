package domain;

import common.struct.Coordinate;
import core.Game;
import core.PlayerManager;
import core.rendering.RenderLayerManager;
import domain.systems.CameraSystem;
import domain.systems.MovementSystem;
import domain.systems.PathFollowSystem;
import domain.systems.StatsSystem;
import domain.systems.VisionSystem;
import domain.terrain.ChunkManager;
import ecs.Entity;
import ecs.components.Explored;
import ecs.components.Sprite;
import ecs.components.Visible;
import rand.ChunkGen;
import tools.Performance;

class World
{
	public var chunkSize(default, null):Int = 16;
	public var chunkCountX(default, null):Int = 64;
	public var chunkCountY(default, null):Int = 40;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var game(get, null):Game;
	public var chunks(default, null):ChunkManager;
	public var chunkGen(default, null):ChunkGen;

	var visible:Array<Coordinate>;

	public var movement(default, null):MovementSystem;
	public var vision(default, null):VisionSystem;
	public var camera(default, null):CameraSystem;
	public var pathing(default, null):PathFollowSystem;
	public var stats(default, null):StatsSystem;

	public var layers(default, null):RenderLayerManager;
	public var player(default, null):PlayerManager;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new() {}

	public function InitSystems()
	{
		layers = new RenderLayerManager();
		player = new PlayerManager();
		chunkGen = new ChunkGen(1);
		chunks = new ChunkManager(chunkCountX, chunkCountY, chunkSize);
		visible = new Array<Coordinate>();

		movement = new MovementSystem();
		vision = new VisionSystem();
		camera = new CameraSystem();
		pathing = new PathFollowSystem();
		stats = new StatsSystem();
	}

	function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}

	public function add(entity:Entity)
	{
		var sprite = entity.get(Sprite);

		if (sprite != null)
		{
			layers.render(OBJECTS, sprite.ob);
		}
	}

	public function getEntitiesAt(pos:Coordinate):Array<Entity>
	{
		var idx = pos.toChunkIdx();
		var chunk = chunks.getChunkById(idx);
		if (chunk == null)
		{
			return new Array<Entity>();
		}
		var local = pos.toWorld().toChunkLocal(chunk.cx, chunk.cy);
		var ids = chunk.getEntityIdsAt(local.x, local.y);

		return Lambda.map(ids, function(id:String)
		{
			return game.registry.getEntity(id);
		});
	}

	public function setVisible(values:Array<Coordinate>)
	{
		for (value in visible)
		{
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk != null)
			{
				var local = value.toChunkLocal(chunk.cx, chunk.cy);

				chunk.setExplore(local.x.floor(), local.y.floor(), true, false);
				for (entity in getEntitiesAt(value))
				{
					if (entity.has(Visible))
					{
						entity.remove(entity.get(Visible));
					}
				}
			}
		}
		for (value in values)
		{
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk != null)
			{
				var local = value.toChunkLocal(chunk.cx, chunk.cy);

				chunk.setExplore(local.x.floor(), local.y.floor(), true, true);
				for (entity in getEntitiesAt(value))
				{
					if (!entity.has(Visible))
					{
						entity.add(new Visible());
					}
					if (!entity.has(Explored))
					{
						entity.add(new Explored());
					}
				}
			}
		}
		visible = values;
	}

	public function explore(coord:Coordinate)
	{
		var c = coord.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk != null)
		{
			var local = coord.toChunkLocal(c.x, c.y);
			chunk.setExplore(local.x.floor(), local.y.floor(), true, false);

			for (entity in getEntitiesAt(coord))
			{
				if (!entity.has(Explored))
				{
					entity.add(new Explored());
				}
			}
		}
	}

	public function updateSystems()
	{
		var frame = game.frame;

		movement.update(frame);
		vision.update(frame);
		camera.update(frame);
		pathing.update(frame);
		stats.update(frame);
	}
}
