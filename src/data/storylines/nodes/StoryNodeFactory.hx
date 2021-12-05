package data.storylines.nodes;

class StoryNodeFactory
{
	public static function FromJson(json:Dynamic):StoryNode
	{
		switch json.type
		{
			case 'CHOICE':
				return new ChoiceNode(json);
			case 'ROLL':
				return RollNode.FromJson(json);
			case 'EFFECT':
				return EffectNode.FromJson(json);
			case 'TEXT':
				return new TextNode(json);
		}

		trace('StoryNode not found', json);

		return null;
	}
}
