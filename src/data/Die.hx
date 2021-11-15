package data;

class Die
{
	var r:hxd.Rand;

	public var category(default, null):DiceCategory;
	public var faces(default, null):Array<DieFace>;

	public function new(category:DiceCategory, faces:Array<DieFace>)
	{
		this.category = category;
		this.faces = faces;
		r = new hxd.Rand(0);
	}

	public inline function roll(seed:Int):DieRoll
	{
		r.init(seed);

		return {
			value: r.pick(faces),
			tumbles: [0...10 + r.random(10)].map((n) -> r.pick(faces))
		}
	}
}
