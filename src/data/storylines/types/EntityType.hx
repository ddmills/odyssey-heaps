package data.storylines.types;

import domain.storylines.Storyline;

typedef EntityTypeArgs =
{
	var key:String;
	var type:String;
}

class EntityType extends StoryType
{
	var params:EntityTypeArgs;

	public function new(params:EntityTypeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryType
	{
		return new EntityType({
			key: json.key,
			type: json.type,
		});
	}

	override function tryPopulate(storyline:Storyline):Bool
	{
		return false;
	}
}
