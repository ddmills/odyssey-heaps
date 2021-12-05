package data.storylines;

import data.storylines.nodes.StoryNodeFactory;
import data.storylines.parameters.StoryParameterFactory;

class StoryFactory
{
	public static function FromJson(json:Dynamic):Story
	{
		var name = json.name;
		var parameters = json.parameters.map((param) ->
		{
			return StoryParameterFactory.FromJson(param);
		});

		var nodes = json.nodes.map((node) ->
		{
			return StoryNodeFactory.FromJson(node);
		});

		return new Story(name, parameters, nodes, json.startNode);
	}
}
