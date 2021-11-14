package data;

import hxd.Rand;

class DiceSet
{
	var category:DiceCategory;
	var dice:Array<Array<Array<Dice>>>;
	var r:Rand;

	public function new(category:DiceCategory, dice:Array<Array<Array<Dice>>>, seed:Int)
	{
		this.category = category;
		this.dice = dice;
		r = new hxd.Rand(seed);
	}

	public function roll(level:Int):Array<Dice>
	{
		var sets = getSet(level);

		if (sets == null)
		{
			return new Array<Dice>();
		}

		return sets.map((die) -> r.pick(die));
	}

	public function getSet(level:Int):Array<Array<Dice>>
	{
		return dice[level - 1];
	}
}
