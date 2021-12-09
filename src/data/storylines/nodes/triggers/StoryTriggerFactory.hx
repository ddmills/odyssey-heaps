package data.storylines.nodes.triggers;

class StoryTriggerFactory
{
	public static function FromJson(json:Dynamic, key:String):StoryTrigger
	{
		switch json.type
		{
			case 'WAIT':
				return new WaitTrigger({
					type: json.type,
					turns: json.turns,
					key: key,
				});
		}

		trace('StoryTrigger not found', json);

		return null;
	}
}
