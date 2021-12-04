package ecs;

import core.Game;

class EntityRef
{
	var entityId:String;

	public var entity(get, set):Entity;

	public function new(id:String = '')
	{
		entityId = id;
	}

	inline function get_entity():Entity
	{
		return Game.instance.registry.getEntity(entityId);
	}

	inline function set_entity(value:Entity):Entity
	{
		entityId = value == null ? '' : value.id;

		return value;
	}
}
