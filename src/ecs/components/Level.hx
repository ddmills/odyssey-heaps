package ecs.components;

class Level extends Component
{
	public var lvl(default, null):Int;

	public function new(lvl:Int = 1)
	{
		this.lvl = lvl;
	}
}
