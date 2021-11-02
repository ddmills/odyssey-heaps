package domain;

import core.Game;

abstract class Component
{
	private var _bit:Int = 0;

	public var bit(get, null):Int;

	public var type(get, null):String;

	inline function get_type():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	function get_bit():Int
	{
		if (_bit > 0)
		{
			return _bit;
		}

		_bit = Game.instance.registry.getBit(Type.getClass(this));

		return _bit;
	}
}
