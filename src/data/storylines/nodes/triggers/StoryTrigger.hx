package data.storylines.nodes.triggers;

import domain.storylines.Storyline;

class StoryTrigger
{
	public var type(default, null):String;
	public var key(default, null):String;

	public function new(type:String, key:String)
	{
		this.type = type;
		this.key = key;
	}

	public function checkTrigger(storyline:Storyline):Bool
	{
		return true;
	}
}
