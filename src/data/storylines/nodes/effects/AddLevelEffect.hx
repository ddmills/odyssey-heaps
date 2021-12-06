package data.storylines.nodes.effects;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;
import domain.storylines.Storyline;
import ecs.components.Level;

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

	override function applyToStoryline(storyline:Storyline)
	{
		var person = storyline.getPerson(params.person);
		person.get(Level).lvl += params.count;
	}
}
