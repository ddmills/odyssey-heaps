package data.combos;

import domain.combat.dice.DiceCombo;

class ShieldBashCombo extends DiceCombo
{
	public function new()
	{
		super('Shield bash', '', [DieFace.ATK_SWORD, DieFace.DEF_SHIELD]);
	}
}
