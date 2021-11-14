package data;

class Profession
{
	public var dice(default, null):DiceSet;
	public var name(default, null):String;

	public function new(name:String, dice:DiceSet)
	{
		this.dice = dice;
		this.name = name;
	}
}
