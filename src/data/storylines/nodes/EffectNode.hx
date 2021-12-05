package data.storylines.nodes;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;
import data.storylines.nodes.effects.StoryEffectFactory;

typedef EffectNodeArgs =
{
	var key:String;
	var type:String;
	var effects:Array<StoryEffct>;
	var nextNode:String;
}

class EffectNode extends StoryNode
{
	public var params:EffectNodeArgs;

	public function new(params:EffectNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryNode
	{
		var effects = json.effects.map((e) -> StoryEffectFactory.FromJson(e));

		return new EffectNode({
			key: json.key,
			type: json.type,
			effects: effects,
			nextNode: json.nextNode,
		});
	}
}
