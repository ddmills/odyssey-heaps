package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class ShieldBashCombo extends DiceCombo
{
	public function new()
	{
		super('Shield bash', 'Deal 1 damage to target and add 2 armor.', [DieFace.ATK_SWORD, DieFace.DEF_SHIELD]);
	}

	public override function apply(enemies:Array<Crew>, allies:Array<Crew>)
	{
		var target = getTarget(enemies);
		var hp = target.entity.get(Health);
		hp.current -= 1;
	}
}
