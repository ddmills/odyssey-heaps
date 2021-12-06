package ecs.components;

class Level extends Component
{
	public var lvl:Int;

	public function new(lvl:Int = 1)
	{
		this.lvl = lvl;
	}
}
