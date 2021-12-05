package data.storylines;

import data.storylines.nodes.StoryNode;
import data.storylines.parameters.StoryParameter;

class Story
{
	public var name(default, null):String;
	public var parameters(default, null):Array<StoryParameter>;
	public var nodes(default, null):Array<StoryNode>;

	public function new(name:String, parameters:Array<StoryParameter>, nodes:Array<StoryNode>)
	{
		this.name = name;
		this.parameters = parameters;
		this.nodes = nodes;
	}
}
