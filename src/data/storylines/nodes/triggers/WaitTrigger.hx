package data.storylines.nodes.triggers;

import core.Game;
import domain.storylines.Storyline;

typedef WaitTriggerArgs =
{
	var type:String;
	var turns:Int;
	var key:String;
}

class WaitTrigger extends StoryTrigger
{
	public var params:WaitTriggerArgs;

	public function new(params:WaitTriggerArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	override function checkTrigger(storyline:Storyline):Bool
	{
		var now = Game.instance.world.clock.turn;
		var data = storyline.getTriggerData(key);
		var start = now;

		if (data == null)
		{
			storyline.setTriggerData(key, {
				start: start
			});
		}
		else
		{
			start = data.start;
		}

		return now - start >= params.turns;
	}
}
