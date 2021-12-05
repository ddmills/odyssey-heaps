package data.storylines.parameters;

import data.DiceCategory;

typedef PersonParameterArgs =
{
	var key:String;
	var type:String;
	var ?inCrew:Bool;
	var ?diceCategory:DiceCategory;
}

class PersonParameter extends StoryParameter
{
	var params:PersonParameterArgs;

	public function new(params:PersonParameterArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}
}
