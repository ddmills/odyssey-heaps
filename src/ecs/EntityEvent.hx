package ecs;

class EntityEvent
{
	public var name(default, null):String;

	public function new(name:String)
	{
		this.name = name;
	}

	public inline function is(name:String):Bool
	{
		return this.name == name;
	}
}
