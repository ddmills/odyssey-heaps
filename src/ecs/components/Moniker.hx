package ecs.components;

class Moniker extends Component
{
	public var displayName = 'Hello world';

	public function new(displayName:String)
	{
		this.displayName = displayName;
	}
}
