package data.storylines.nodes;

import data.storylines.nodes.triggers.StoryTrigger;
import data.storylines.nodes.triggers.StoryTriggerFactory;

typedef TriggerNodeArgs =
{
	var key:String;
	var type:String;
	var triggers:Array<StoryTrigger>;
	var nextNode:String;
}

class TriggerNode extends StoryNode
{
	public var params:TriggerNodeArgs;

	public function new(params:TriggerNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryNode
	{
		var key = json.key;
		var idx = 0;
		var triggers = json.triggers.map((e:Dynamic) ->
		{
			return StoryTriggerFactory.FromJson(e, key + "-" + (idx++).toString());
		});

		return new TriggerNode({
			key: json.key,
			type: json.type,
			triggers: triggers,
			nextNode: json.nextNode,
		});
	}
}
