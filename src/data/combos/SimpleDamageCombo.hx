package data.combos;

import domain.combat.dice.DiceCombo;
import domain.screens.CombatScreen.Crew;
import ecs.components.Health;

class SimpleDamageCombo extends DiceCombo
{
	var damage:Int;

	public function new(name:String, dice:Array<DieFace>, damage:Int)
	{
		super(name, 'Deal ${damage} damage to target enemy.', dice);
		this.damage = damage;
	}

	public override function apply(enemies:Array<Crew>, allies:Array<Crew>)
	{
		var target = getTarget(enemies);
		var hp = target.entity.get(Health);
		hp.current -= damage;
	}
}
