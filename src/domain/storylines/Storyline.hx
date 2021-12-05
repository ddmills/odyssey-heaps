package domain.storylines;

import data.storylines.Story;
import data.storylines.nodes.StoryNode;

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
}
