package data.storylines.nodes.effects;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;

typedef KillEffectArgs =
{
	var type:String;
	var person:String;
}

class KillEffect extends StoryEffct
{
	public var params:KillEffectArgs;

	public function new(params:KillEffectArgs)
	{
		super(params.type);
		this.params = params;
	}
}
