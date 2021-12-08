package data.storylines;

import data.storylines.nodes.StoryNodeFactory;
import data.storylines.types.StoryTypeFactory;

class StoryFactory
{
	public static function FromJson(json:Dynamic):Story
	{
		var name = json.name;
		var parameters = json.parameters.map((param) ->
		{
			return StoryTypeFactory.FromJson(param);
		});

		var variables = json.variables.map((param) ->
		{
			return StoryTypeFactory.FromJson(param);
		});

		var nodes = json.nodes.map((node) ->
		{
			return StoryNodeFactory.FromJson(node);
		});

		return new Story(name, parameters, variables, nodes, json.startNode);
	}
}
