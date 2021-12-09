package domain.screens.storylines;

import core.Screen;
import data.storylines.nodes.TriggerNode;
import domain.storylines.Storyline;

class StoryTriggerScreen extends Screen
{
	var storyline:Storyline;
	var triggerNode:TriggerNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		triggerNode = cast(storyline.currentNode, TriggerNode);
	}

	public override function onEnter()
	{
		var all = triggerNode.params.triggers.every((effect) ->
		{
			effect.checkTrigger(storyline);
		});

		if (all)
		{
			storyline.currentNodeKey = triggerNode.params.nextNode;
		}

		game.screens.pop();
	}
}
