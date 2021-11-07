package core;

import common.struct.Coordinate;
import data.TileResources;
import ecs.Entity;
import ecs.EntityRef;
import ecs.components.Direction;
import ecs.components.Moniker;
import ecs.components.Sprite;
import ecs.components.Vision;
import h2d.Anim;

class PlayerManager
{
	var entityRef:EntityRef;

	public var entity(get, never):Entity;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var pos(get, set):Coordinate;

	inline function get_entity():Entity
	{
		return entityRef.entity;
	}

	public function new()
	{
		entityRef = new EntityRef();
	}

	public function initialize()
	{
		var e = new Entity();
		e.add(new Moniker('Sloop'));
		e.add(new Sprite(new Anim(TileResources.SLOOP.split(8), 0), Game.instance.TILE_W_HALF, Game.instance.TILE_H));
		e.add(new Direction());
		e.add(new Vision(6, 1));

		Game.instance.world.add(e);

		entityRef.entity = e;
	}

	inline function get_x():Float
	{
		return entity.x;
	}

	inline function get_y():Float
	{
		return entity.y;
	}

	inline function get_pos():Coordinate
	{
		return entity.pos;
	}

	inline function set_pos(value:Coordinate):Coordinate
	{
		return entity.pos = value;
	}

	inline function set_y(value:Float):Float
	{
		return entity.y = value;
	}

	inline function set_x(value:Float):Float
	{
		return entity.x = value;
	}
}
