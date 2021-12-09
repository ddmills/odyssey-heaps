package data.storylines.types;

class StoryTypeFactory
{
	public static function FromJson(json:Dynamic):StoryType
	{
		switch json.type
		{
			case 'PERSON':
				return PersonType.FromJson(json);
			case 'ENTITY':
				return EntityType.FromJson(json);
		}

		trace('StoryType not found', json);

		return null;
	}
}
