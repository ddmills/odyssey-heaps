package domain.combat.dice;

import data.DiceCategory;
import data.DieRoll;

class DiceSet
{
	var category:DiceCategory;
	var dice:Array<Array<Die>>;

	public function new(category:DiceCategory, dice:Array<Array<Die>>)
	{
		this.category = category;
		this.dice = dice;
	}

	public function roll(level:Int, seed:Int):Array<DieRoll>
	{
		var set = getSet(level);

		if (set == null)
		{
			return new Array<DieRoll>();
		}

		return set.map((die) -> die.roll(seed));
	}

	public function getSet(level:Int):Array<Die>
	{
		return dice[level - 1];
	}
}
