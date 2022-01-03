package core;

import data.storylines.Stories;
import data.storylines.Story;
import ecs.Entity;
import ecs.components.Inventory;
import ecs.components.Moniker;
import ecs.components.Stackable;
import h2d.Console;

class ConsoleConfig
{
	public static function Config(console:Console)
	{
		console.log('Type "help" for list of commands.');

		console.addCommand('exit', 'Close the console', [], () ->
		{
			Game.instance.screens.pop();
		});

		console.addAlias('quit', 'exit');
		console.addAlias('q', 'exit');

		console.addCommand('food', 'Set food value', [
			{
				name: 'value',
				opt: true,
				t: AInt,
			}
		], (value:Null<Int>) -> foodCommand(console, value));

		console.addCommand('story', 'Add a storyline', [
			{
				name: 'name',
				opt: false,
				t: AString,
			}
		], (name:String) -> storyCommand(console, name));

		console.addCommand('stories', 'List all stories', [], () -> storiesCommand(console));
		console.addAlias('storylines', 'stories');

		console.addCommand('inventory', 'List player inventory', [], () -> inventoryCommand(console));
	}

	static function foodCommand(console:Console, value:Null<Int>)
	{
		var food = value == null ? Game.instance.world.resources.food.max : value;
		console.log('Setting food to ${food}');
		Game.instance.world.resources.food.value = food;
	}

	static function inventoryCommand(console:Console)
	{
		var i = Game.instance.world.player.entity.get(Inventory);
		console.log('Player inventory ${i.content.length}/${i.size}');
		i.content.each((e:Entity) ->
		{
			var stackable = e.get(Stackable);
			if (stackable != null)
			{
				console.log('    ${e.get(Moniker).displayName} x${stackable.quantity}');
			}
			else
			{
				console.log('    ${e.get(Moniker).displayName}');
			}
		});
	}

	static function storiesCommand(console:Console)
	{
		var stories = Stories.STORIES;

		console.log('Stories (${stories.length})');

		stories.each((s:Story) ->
		{
			if (Game.instance.world.storylines.hasStoryline(s))
			{
				console.log('    ${s.name} [ACTIVE]');
			}
			else
			{
				console.log('    ${s.name}');
			}
		});
	}

	static function storyCommand(console:Console, name:String)
	{
		var story = Stories.GetStory(name);

		if (story == null)
		{
			console.log('Story "${name}" not found', 0xffff00);
		}
		else
		{
			var added = Game.instance.world.storylines.tryAddStory(story);
			if (added == null)
			{
				console.log('Story "${name}" could not be added', 0xff0000);
			}
			else
			{
				console.log('Story "${added.story.name}" added');
			}
		}
	}
}
