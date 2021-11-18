package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class SquidWaveCombo extends DiceCombo
{
	public function new()
	{
		super('Wave', '', [DieFace.SQUID_TENTACLE, DieFace.SQUID_WAVE]);
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
