package ecs.components;

class Nationality extends Component
{
	public var nation(default, null):data.Nationality;

	public function new(nation:data.Nationality)
	{
		this.nation = nation;
	}
}
