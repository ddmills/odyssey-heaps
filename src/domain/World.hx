package domain;

import common.struct.Coordinate;
import core.Game;
import domain.terrain.ChunkManager;
import h2d.Layers;
import rand.ChunkGen;

class World
{
	public var chunkSize(default, null):Int = 32;
	public var chunkCountX(default, null):Int = 128;
	public var chunkCountY(default, null):Int = 128;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var game(get, null):Game;
	public var chunks(default, null):ChunkManager;
	public var bg(default, null):h2d.Object;
	public var entities(default, null):h2d.Layers;
	public var container(default, null):h2d.Layers;
	public var chunkGen(default, null):ChunkGen;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		chunkGen = new ChunkGen(1);
		chunks = new ChunkManager(chunkCountX, chunkCountY, chunkSize);
		container = new Layers();

		bg = new Layers();
		entities = new Layers();

		container.addChildAt(bg, 0);
		container.addChildAt(entities, 1);
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
		var x = (sx + camWorld.x) / game.camera.zoom;
		var y = (sy + camWorld.y) / game.camera.zoom;
		return new Coordinate(x, y, PIXEL);
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

	public function worldToChunk(worldX:Float, worldY:Float):Coordinate
	{
		return new Coordinate(Math.floor(worldX / chunkSize), Math.floor(worldY / chunkSize), CHUNK);
	}

	public function chunkToWorld(chunkX:Float, chunkY:Float):Coordinate
	{
		return new Coordinate(chunkX * chunkSize, chunkY * chunkSize, WORLD);
	}

	public function add(entity:Entity)
	{
		entities.addChild(entity.ob);
	}
}
