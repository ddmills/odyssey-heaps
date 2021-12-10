package ecs.components;

class IsDestroying extends Component
{
	public var isFlagged(default, null):Bool;

	public function new()
	{
		isFlagged = false;
	}

	public inline function flag()
	{
		isFlagged = true;
	}
}
