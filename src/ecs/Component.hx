package ecs;

import core.Game;

abstract class Component
{
	private var _bit:Int = 0;

	public var bit(get, null):Int;
	public var type(get, null):String;
	public var entity(default, null):Entity;
	public var isAttached(get, null):Bool;

	inline function get_type():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	inline function get_entity():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	function get_bit():Int
	{
		if (_bit > 0)
		{
			return _bit;
		}

		_bit = Game.instance.registry.register(Type.getClass(this));

		return _bit;
	}

	function onRemove() {}

	@:allow(ecs.Entity)
	function onEvent(evt:EntityEvent) {}

	@:allow(ecs.Entity)
	function _attach(entity:Entity)
	{
		this.entity = entity;
	}

	@:allow(ecs.Entity)
	function _remove()
	{
		onRemove();
		entity = null;
	}

	function get_isAttached():Bool
	{
		return entity != null;
	}
}
