package ecs.components;

import data.Gender;

class Person extends Component
{
	public var name(default, null):String;
	public var gender(default, null):Gender;
	public var seed(default, null):Int;

	public function new(name:String, gender:Gender, seed:Int)
	{
		this.name = name;
		this.gender = gender;
		this.seed = seed;
	}
}
