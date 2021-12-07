package data.storylines.parameters;

import domain.storylines.Storyline;

class StoryParameter
{
	public var type(default, null):String;
	public var key(default, null):String;

	public function new(type:String, key:String)
	{
		this.type = type;
		this.key = key;
	}

	public function tryPopulate(storyline:Storyline):Bool
	{
		return true;
	}
}
