package data.storylines.nodes.effects;

import domain.storylines.Storyline;

class StoryEffct
{
	public var type(default, null):String;

	public function new(type:String)
	{
		this.type = type;
	}

	public function applyToStoryline(storyline:Storyline) {}
}
