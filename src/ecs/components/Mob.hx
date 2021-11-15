package ecs.components;

import data.DiceSet;

class Mob extends Component
{
	public var dice(default, null):DiceSet;

	public function new(dice:DiceSet)
	{
		this.dice = dice;
	}
}
