package data.storylines.nodes;

typedef TextNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var actionText:String;
	var nextNode:String;
}

class TextNode extends StoryNode
{
	public var params:TextNodeArgs;

	public function new(params:TextNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}
}
