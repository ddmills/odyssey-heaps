package data;

import data.DieData.Dice;
import domain.combat.dice.DiceSet;

class DiceSets
{
	public static var SOLDIER = new DiceSet(DiceCategory.ATTACK, [[Dice.SOLDIER_LVL_1], [Dice.SOLDIER_LVL_2], [Dice.SOLDIER_LVL_3]]);
	public static var OFFICER = new DiceSet(DiceCategory.ATTACK, [[Dice.OFFICER_LVL_1], [Dice.OFFICER_LVL_2], [Dice.OFFICER_LVL_3]]);
	public static var COOK = new DiceSet(DiceCategory.ATTACK, [[Dice.COOK_LVL_1], [Dice.COOK_LVL_2], [Dice.COOK_LVL_3]]);
	public static var TENTACLE = new DiceSet(DiceCategory.SQUID, [[Dice.SQUID]]);
}
