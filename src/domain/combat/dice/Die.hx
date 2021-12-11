package domain.combat.dice;

import data.DiceCategory;
import data.DieFace;
import data.DieRoll;

class Die
{
	public var category(default, null):DiceCategory;
	public var faces(default, null):Array<DieFace>;

	public function new(category:DiceCategory, faces:Array<DieFace>)
	{
		this.category = category;
		this.faces = faces;
	}

	public inline function roll(seed:Int):DieRoll
	{
		var r = new hxd.Rand(seed);

		return {
			value: r.pick(faces),
			tumbles: [0...10 + r.random(10)].map((n) -> r.pick(faces))
		}
	}
}
