package ecs.components;

class Settlement extends Component
{
	public var name(default, null):String;

	public function new(name:String)
	{
		this.name = name;
	}
}
