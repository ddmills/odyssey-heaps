package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class ShieldBashCombo extends DiceCombo
{
	public function new()
	{
		super('Shield bash', '', [DieFace.ATK_SWORD, DieFace.DEF_SHIELD]);
	}

	public override function apply(mobs:Array<Crew>)
	{
		for (mob in mobs)
		{
			var hp = mob.entity.get(Health);
			hp.current -= 1;
		}
	}
}
