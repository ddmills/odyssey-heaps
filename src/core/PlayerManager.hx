package core;

import common.struct.Coordinate;
import common.util.Timeout;
import ecs.Entity;
import ecs.EntityRef;
import ecs.components.Energy;
import ecs.prefabs.PlayerPrefab;

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
		var e = PlayerPrefab.Create();

		Game.instance.world.add(e);

		entityRef.entity = e;
	}

	public function getNextAction():() -> Void
	{
		// return () ->
		// {
		// 	entity.get(Energy).consumeEnergy(1);
		// };
		return null;
	}

	public function startTurn()
	{
		var action = getNextAction();

		if (action != null)
		{
			action();
		}
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
