package domain.storylines;

import core.Game;
import data.storylines.Story;
import data.storylines.nodes.StoryNode;
import ecs.Entity;
import hxd.Rand;

typedef Param =
{
	key:String,
	entityId:String,
	display:String,
};

class Storyline
{
	public var story(default, null):Story;
	public var parameters:Map<String, Param>;
	public var variables:Map<String, Param>;
	public var currentNodeKey:String;
	public var currentNode(get, null):StoryNode;
	public var isEnd(get, never):Bool;
	public var seed:Int;
	public var rand:Rand;

	public function new(story:Story, seed:Int)
	{
		this.story = story;
		parameters = new Map();
		variables = new Map();
		currentNodeKey = story.startNode.key;
		this.seed = seed;
		rand = new Rand(seed);
	}

	function get_currentNode():StoryNode
	{
		return story.getNode(currentNodeKey);
	}

	public function getParameter(key:String):Param
	{
		return parameters.find((p) -> p.key == key);
	}

	public function getVariable(key:String):Param
	{
		return variables.find((v) -> v.key == key);
	}

	public function getData(key:String):Param
	{
		return getParameter(key);
	}

	public function setVariable(key:String, data:Param)
	{
		variables.set(key, {
			key: key,
			entityId: data.entityId,
			display: data.display,
		});
	}

	public function setParameter(key:String, data:Param)
	{
		parameters.set(key, {
			key: key,
			entityId: data.entityId,
			display: data.display,
		});
	}

	public function textReplace(text:String):String
	{
		var text2 = parameters.fold((p, res) ->
		{
			var key = '[${p.key}]';

			return StringTools.replace(res, key, p.display);
		}, text);

		return variables.fold((v, res) ->
		{
			var key = '[${v.key}]';

			return StringTools.replace(res, key, v.display);
		}, text2);
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
