package ecs.components;

import data.Gender;

class Person extends Component
{
	public var name(default, null):String;
	public var gender(default, null):Gender;

	public function new(name:String, gender:Gender)
	{
		this.name = name;
		this.gender = gender;
	}
}
