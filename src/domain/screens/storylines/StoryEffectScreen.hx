package domain.screens.storylines;

import core.Screen;
import data.storylines.nodes.EffectNode;
import domain.storylines.Storyline;

class StoryEffectScreen extends Screen
{
	var storyline:Storyline;
	var effectNode:EffectNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		effectNode = cast(storyline.currentNode, EffectNode);
	}

	public override function onEnter()
	{
		effectNode.params.effects.each((effect) ->
		{
			effect.applyToStoryline(storyline);
		});

		storyline.currentNodeKey = effectNode.params.nextNode;
		game.screens.pop();
	}
}
