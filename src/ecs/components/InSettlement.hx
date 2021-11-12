package ecs.components;

class InSettlement extends Component
{
	public var settlementId(default, null):Int;

	public function new(settlementId:Int)
	{
		this.settlementId = settlementId;
	}
}
