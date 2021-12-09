package data.storylines.nodes.effects;

import data.storylines.nodes.effects.StoryEffect.StoryEffct;

class StoryEffectFactory
{
	public static function FromJson(json:Dynamic):StoryEffct
	{
		switch json.type
		{
			case 'ADD_LVL':
				return new AddLevelEffect({
					type: json.type,
					count: json.count,
					person: json.person,
				});
			case 'KILL':
				return new KillEffect({
					type: json.type,
					person: json.person,
				});
			case 'SPAWN':
				return SpawnEffect.FromJson(json);
		}

		trace('StoryEffect not found', json);

		return null;
	}
}
