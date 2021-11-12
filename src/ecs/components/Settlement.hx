package ecs.components;

class Settlement extends Component
{
	public var name(default, null):String;
	public var id(default, null):Int;

	public function new(id:Int, name:String)
	{
		this.name = name;
		this.id = id;
	}
}
