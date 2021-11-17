package ecs.components;

import domain.combat.dice.DiceCombo;
import domain.combat.dice.DiceSet;

class Mob extends Component
{
	public var dice(default, null):DiceSet;
	public var combos(default, null):Array<DiceCombo>;

	public function new(dice:DiceSet, combos:Array<DiceCombo>)
	{
		this.dice = dice;
		this.combos = combos;
	}
}
