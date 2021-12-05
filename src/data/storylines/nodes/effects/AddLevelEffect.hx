package data.storylines.nodes.effects;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;

typedef AddLevelEffectArgs =
{
	var type:String;
	var count:Int;
	var person:String;
}

class AddLevelEffect extends StoryEffct
{
	public var params:AddLevelEffectArgs;

	public function new(params:AddLevelEffectArgs)
	{
		super(params.type);
		this.params = params;
	}
}
