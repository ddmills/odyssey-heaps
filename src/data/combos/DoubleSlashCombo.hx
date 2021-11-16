package data.combos;

import domain.combat.dice.DiceCombo;

class DoubleSlashCombo extends DiceCombo
{
	public function new()
	{
		super('Double slash', '', [DieFace.ATK_SWORD, DieFace.ATK_SWORD]);
	}
}
