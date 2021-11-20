package ecs.components;

class Health extends Component
{
	public var current(default, set):Int;
	public var max(default, null):Int;

	public function new(current:Int, max:Int)
	{
		this.current = current;
		this.max = max;
	}

	function set_current(value:Int):Int
	{
		current = value <= 0 ? 0 : value;

		if (isAttached && entity.has(Incapacitated) && current > 0)
		{
			entity.remove(Incapacitated);
		}
		else if (current <= 0)
		{
			entity.add(new Incapacitated());
		}

		return current;
	}
}
