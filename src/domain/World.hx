package domain;

import common.struct.Coordinate;
import core.Game;
import domain.terrain.ChunkManager;
import ecs.Entity;
import ecs.components.Explored;
import ecs.components.Sprite;
import ecs.components.Visible;
import h2d.Layers;
import rand.ChunkGen;

class World
{
	public var chunkSize(default, null):Int = 16;
	public var chunkCountX(default, null):Int = 64;
	public var chunkCountY(default, null):Int = 64;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var game(get, null):Game;
	public var chunks(default, null):ChunkManager;
	public var bg(default, null):h2d.Layers;
	public var fog(default, null):h2d.Layers;
	public var entities(default, null):h2d.Layers;
	public var container(default, null):h2d.Layers;
	public var chunkGen(default, null):ChunkGen;

	var visible:Array<Coordinate>;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		chunkGen = new ChunkGen(1);
		chunks = new ChunkManager(chunkCountX, chunkCountY, chunkSize);
		container = new Layers();
		visible = new Array<Coordinate>();

		bg = new Layers();
		entities = new Layers();
		fog = new Layers();

		container.addChildAt(bg, 0);
		container.addChildAt(fog, 1);
		container.addChildAt(entities, 2);
	}

	function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}

	public function worldToPx(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate((wx - wy) * game.TILE_W_HALF, (wx + wy) * game.TILE_H_HALF, PIXEL);
	}

	public function pxToWorld(px:Float, py:Float):Coordinate
	{
		var wx = (px / game.TILE_W_HALF + py / game.TILE_H_HALF) / 2;
		var wy = (py / game.TILE_H_HALF - px / game.TILE_W_HALF) / 2;

		return new Coordinate(wx, wy, WORLD);
	}

	public function screenToPx(sx:Float, sy:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);
		var px = (sx + camWorld.x) / game.camera.zoom;
		var py = (sy + camWorld.y) / game.camera.zoom;
		return new Coordinate(px, py, PIXEL);
	}

	public function pxToScreen(px:Float, py:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);

		var sx = (px * game.camera.zoom) - camWorld.x;
		var sy = (py * game.camera.zoom) - camWorld.y;

		return new Coordinate(sx, sy, SCREEN);
	}

	public function screenToWorld(sx:Float, sy:Float):Coordinate
	{
		var p = screenToPx(sx, sy);
		return pxToWorld(p.x, p.y);
	}

	public function screenToChunk(sx:Float, sy:Float):Coordinate
	{
		var w = screenToWorld(sx, sy);
		return worldToChunk(w.x, w.y);
	}

	public function pxToChunk(px:Float, py:Float):Coordinate
	{
		var world = pxToWorld(px, py);
		return new Coordinate(world.x / chunkSize, world.y / chunkSize, CHUNK);
	}

	public function chunkToPx(cx:Float, cy:Float):Coordinate
	{
		var world = chunkToWorld(cx, cy);
		return worldToPx(world.x, world.y);
	}

	public function worldToChunk(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize), CHUNK);
	}

	public function worldToScreen(wx:Float, wy:Float):Coordinate
	{
		var px = worldToPx(wx, wy);
		return pxToScreen(px.x, px.y);
	}

	public function chunkToWorld(chunkX:Float, chunkY:Float):Coordinate
	{
		return new Coordinate(chunkX * chunkSize, chunkY * chunkSize, WORLD);
	}

	public function chunkToScreen(cx:Float, cy:Float):Coordinate
	{
		var px = chunkToPx(cx, cy);
		return pxToScreen(px.x, px.y);
	}

	public function add(entity:Entity)
	{
		var sprite = entity.get(Sprite);

		if (sprite != null)
		{
			entities.addChild(sprite.ob);
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
}
