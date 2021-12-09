package data.storylines.nodes.triggers;

import core.Game;
import domain.storylines.Storyline;
import ecs.components.IsDead;

typedef DeadTriggerArgs =
{
	var type:String;
	var key:String;
	var entity:String;
}

class DeadTrigger extends StoryTrigger
{
	public var params:DeadTriggerArgs;

	public function new(params:DeadTriggerArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	override function checkTrigger(storyline:Storyline):Bool
	{
		var dat = storyline.getData(params.entity);
		var entity = Game.instance.registry.getEntity(dat.entityId);

		return entity == null || entity.has(IsDead);
	}
}
