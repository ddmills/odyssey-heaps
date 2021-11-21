package domain.screens.components;

import domain.screens.CombatScreen.GameDie;

abstract class CombatantCard extends h2d.Object
{
	public abstract function updateHp():Void;

	public abstract function updateDice(dice:Array<GameDie>):Void;

	public dynamic function onClick(e:hxd.Event) {}
}
