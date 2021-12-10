package data.storylines.nodes;

class StoryNodeFactory
{
	public static function FromJson(json:Dynamic):StoryNode
	{
		switch json.type
		{
			case 'CHOICE':
				return ChoiceNode.FromJson(json);
			case 'ROLL':
				return RollNode.FromJson(json);
			case 'EFFECT':
				return EffectNode.FromJson(json);
			case 'TRIGGER':
				return TriggerNode.FromJson(json);
			case 'TEXT':
				return TextNode.FromJson(json);
		}

		trace('StoryNode not found', json);

		return null;
	}
}
