package data.storylines.parameters;

class StoryParameterFactory
{
	public static function FromJson(json:Dynamic):StoryParameter
	{
		switch json.type
		{
			case 'PERSON':
				return new PersonParameter(json);
		}

		trace('StoryParameter not found', json);

		return null;
	}
}
