package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class DoubleSlashCombo extends DiceCombo
{
	public function new()
	{
		super('Double slash', '', [DieFace.ATK_SWORD, DieFace.ATK_SWORD]);
	}

	public override function apply(mobs:Array<Crew>)
	{
		for (mob in mobs)
		{
			var hp = mob.entity.get(Health);
			hp.current -= 2;
		}
	}
}
