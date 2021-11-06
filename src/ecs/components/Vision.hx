package ecs.components;

class Vision extends Component
{
	public var range:Int;

	/**
	 * Bonus vision is grants extra range, but only marks tiles as "Explored" rather than visible
	 */
	public var bonus:Int;

	public function new(range:Int = 6, bonus:Int = 0)
	{
		this.range = range;
		this.bonus = bonus;
	}
}
