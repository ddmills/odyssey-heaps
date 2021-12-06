package domain.storylines;

import core.Game;
import data.storylines.Story;
import data.storylines.nodes.StoryNode;
import ecs.Entity;

typedef Param =
{
	key:String,
	entityId:String,
	display:String,
};

class Storyline
{
	public var story(default, null):Story;
	public var parameters:Array<Param>;
	public var currentNodeKey:String;
	public var currentNode(get, null):StoryNode;
	public var isEnd(get, never):Bool;

	public function new(story:Story)
	{
		this.story = story;
		parameters = new Array();
		currentNodeKey = story.startNode.key;
	}

	function get_currentNode():StoryNode
	{
		return story.getNode(currentNodeKey);
	}

	public function textReplace(text:String):String
	{
		return parameters.fold((p, res) ->
		{
			var key = '[${p.key}]';

			return StringTools.replace(res, key, p.display);
		}, text);
	}

	public function getPerson(key:String):Entity
	{
		var param = parameters.find((p) -> p.key == key);

		return Game.instance.registry.getEntity(param.entityId);
	}

	function get_isEnd():Bool
	{
		return currentNodeKey.toLowerCase() == 'end';
	}
}
