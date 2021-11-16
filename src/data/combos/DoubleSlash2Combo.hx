package data.combos;

import domain.combat.dice.DiceCombo;

class DoubleSlash2Combo extends DiceCombo
{
	public function new()
	{
		super('Double slash', '', [DieFace.ATK_DBL_SWORD]);
	}

	public override function apply()
	{
		trace('slash double!');
	}
}
