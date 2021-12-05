package domain.storylines;

import core.Frame;
import data.storylines.Story;
import domain.screens.StoryChoiceScreen;
import domain.systems.System;
import ecs.Entity;
import ecs.components.Person;

class Storylines extends System
{
	public var active:Array<Storyline>;

	public function new()
	{
		active = new Array<Storyline>();
	}

	public function tryAddStory(story:Story, e:Entity)
	{
		var storyline = new Storyline(story);

		storyline.parameters.push({
			key: 'c',
			entityId: e.id,
			display: e.get(Person).name,
		});

		active.push(storyline);

		return storyline;
	}

	override function update(frame:Frame)
	{
		active.each((s:Storyline) ->
		{
			if (s.currentNode.isEnd)
			{
				active.remove(s);
			}
			else
			{
				game.screens.push(new StoryChoiceScreen(s));
			}
		});
	}
}
