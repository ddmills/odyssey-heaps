package ecs.components;

class Energy extends Component
{
	public var value(default, null):Int;
	public var hasEnergy(get, never):Bool;

	public function new(value:Int = 0)
	{
		this.value = value;
	}

	public function addEnergy(value:Int)
	{
		this.value += value;

		if (this.value > 0)
		{
			this.value = 0;
		}
	}

	public function consumeEnergy(value:Int)
	{
		addEnergy(-1 * value);
	}

	inline function get_hasEnergy():Bool
	{
		return value >= 0;
	}
}
