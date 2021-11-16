package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class SlashCombo extends DiceCombo
{
	public function new()
	{
		super('Slash', '', [DieFace.ATK_SWORD]);
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
