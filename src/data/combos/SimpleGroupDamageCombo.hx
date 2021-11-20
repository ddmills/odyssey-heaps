package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class SimpleGroupDamageCombo extends DiceCombo
{
	var damage:Int;

	public function new(name:String, dice:Array<DieFace>, damage:Int)
	{
		super(name, 'Deal ${damage} damage to all enemies!', dice);
		this.damage = damage;
	}

	public override function apply(enemies:Array<Crew>, allies:Array<Crew>)
	{
		for (enemy in enemies)
		{
			var hp = enemy.entity.get(Health);
			hp.current -= damage;
		}
	}
}
