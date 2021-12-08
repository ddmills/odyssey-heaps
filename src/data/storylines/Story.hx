package data.storylines;

import data.storylines.nodes.StoryNode;
import data.storylines.types.StoryType;

class Story
{
	public var name(default, null):String;
	public var parameters(default, null):Map<String, StoryType>;
	public var variables(default, null):Map<String, StoryType>;
	public var nodes(default, null):Map<String, StoryNode>;
	public var startNode(get, never):StoryNode;

	var startNodeName:String;

	public function new(name:String, parameters:Array<StoryType>, variables:Array<StoryType>, nodes:Array<StoryNode>, startNodeName:String)
	{
		this.name = name;
		this.parameters = parameters.toMap((p) -> p.key);
		this.variables = variables.toMap((v) -> v.key);
		this.nodes = nodes.toMap((n) -> n.key);
		this.startNodeName = startNodeName;
	}

	public function getNode(key:String):StoryNode
	{
		return nodes.get(key);
	}

	public function getParameter(key:String):StoryType
	{
		return parameters.get(key);
	}

	public function getVariable(key:String):StoryType
	{
		return variables.get(key);
	}

	function get_startNode():StoryNode
	{
		return getNode(startNodeName);
	}
}
