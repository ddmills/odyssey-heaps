package data.storylines.nodes;

typedef ChoiceNodeOption =
{
	var title:String;
	var key:String;
	var nextNode:String;
}

typedef ChoiceNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var options:Array<ChoiceNodeOption>;
}

class ChoiceNode extends StoryNode
{
	public var params:ChoiceNodeArgs;

	public function new(params:ChoiceNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}
}
