package ecs.components;

import data.Gender;
import data.Nationality;

class Person extends Component
{
	public var name(default, null):String;
	public var gender(default, null):Gender;
	public var nationality(default, null):Nationality;

	public function new(name:String, gender:Gender, nationality:Nationality)
	{
		this.name = name;
		this.gender = gender;
		this.nationality = nationality;
	}
}
