package data.combos;

import domain.combat.dice.DiceCombo;

class SlashCombo extends DiceCombo
{
	public function new()
	{
		super('Slash', '', [DieFace.ATK_SWORD]);
	}

	public override function apply()
	{
		trace('slash!');
	}
}
