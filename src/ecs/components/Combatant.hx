package ecs.components;

import domain.combat.dice.DiceSet;

class Combatant extends Component
{
	public var dice(default, null):DiceSet;

	public function new(dice:DiceSet)
	{
		this.dice = dice;
	}
}
