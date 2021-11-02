package domain;

abstract class Component
{
	public var type(get, null):String;

	inline function get_type():String
	{
		return Type.getClassName(Type.getClass(this));
	}
}
