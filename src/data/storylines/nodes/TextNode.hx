package data.storylines.nodes;

typedef TextNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var actionText:String;
	var node:String;
}

class TextNode extends StoryNode
{
	public var params:TextNodeArgs;

	public function new(params:TextNodeArgs)
	{
		super(params.key, params.type);
		this.params = params;
	}
}
