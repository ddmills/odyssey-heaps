package data.storylines.nodes.effects;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;
import domain.storylines.Storyline;
import ecs.components.Health;

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

	override function applyToStoryline(storyline:Storyline)
	{
		var person = storyline.getPerson(params.person);
		person.get(Health).current = 0;
	}
}
