package domain.systems;

import core.Frame;
import data.storylines.Story;
import data.storylines.types.StoryType;
import domain.screens.storylines.StoryChoiceScreen;
import domain.screens.storylines.StoryEffectScreen;
import domain.screens.storylines.StoryRollScreen;
import domain.screens.storylines.StoryTextScreen;
import domain.screens.storylines.StoryTriggerScreen;
import domain.storylines.Storyline;
import domain.systems.System;
import ecs.Entity;
import ecs.components.Person;

class StorylineSystem extends System
{
	public var active:Array<Storyline>;

	public function new()
	{
		active = new Array<Storyline>();
	}

	public function tryAddStory(story:Story)
	{
		var storyline = new Storyline(story, 0);

		// for each parameter, find a suitable candidate
		var populated = story.parameters.every((p) -> p.tryPopulate(storyline));

		if (populated)
		{
			active.push(storyline);
			return storyline;
		}

		trace('Could not fulfill requirements for story');

		return null;
	}

	override function update(frame:Frame)
	{
		active.each((s:Storyline) ->
		{
			if (s.isEnd)
			{
				active.remove(s);
				return;
			}

			handleStoryNode(s);
		});
	}

	function handleStoryNode(s:Storyline)
	{
		switch (s.currentNode.type)
		{
			case 'CHOICE':
				game.screens.push(new StoryChoiceScreen(s));
			case 'ROLL':
				game.screens.push(new StoryRollScreen(s));
			case 'EFFECT':
				game.screens.push(new StoryEffectScreen(s));
			case 'TRIGGER':
				game.screens.push(new StoryTriggerScreen(s));
			case 'TEXT':
				game.screens.push(new StoryTextScreen(s));
		}
	}
}
