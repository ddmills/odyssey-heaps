package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class SquidTentacleCombo extends DiceCombo
{
	public function new()
	{
		super('Tentacle', '', [DieFace.SQUID_TENTACLE]);
	}

	public override function apply(mobs:Array<Crew>)
	{
		trace('TENTACLE COMBO', mobs);

		for (mob in mobs)
		{
			trace('dmg', mob);
			var hp = mob.entity.get(Health);
			hp.current -= 1;
		}
	}
}
