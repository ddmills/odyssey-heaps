package data.storylines;

import data.storylines.nodes.StoryNode;
import data.storylines.types.StoryType;

class Story
{
	public var name(default, null):String;
	public var parameters(default, null):Array<StoryType>;
	public var variables(default, null):Array<StoryType>;
	public var nodes(default, null):Array<StoryNode>;
	public var startNode(get, never):StoryNode;

	var startNodeName:String;

	public function new(name:String, parameters:Array<StoryType>, variables:Array<StoryType>, nodes:Array<StoryNode>, startNodeName:String)
	{
		this.name = name;
		this.parameters = parameters;
		this.variables = variables;
		this.nodes = nodes;
		this.startNodeName = startNodeName;
	}

	public function getNode(key:String):StoryNode
	{
		return nodes.find((n) -> n.key == key);
	}

	public function getParameter(key:String):StoryType
	{
		return parameters.find((p) -> p.key == key);
	}

	function get_startNode():StoryNode
	{
		return getNode(startNodeName);
	}
}
