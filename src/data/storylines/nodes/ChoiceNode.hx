package data.storylines.nodes;

import domain.ui.Button.ButtonType;
import haxe.EnumTools;

typedef ChoiceNodeOption =
{
	var key:String;
	var nextNode:String;
	var ?value:String;
	var ?buttonText:String;
	var ?buttonType:ButtonType;
}

typedef ChoiceNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var options:Array<ChoiceNodeOption>;
	var ?resultVariable:String;
}

class ChoiceNode extends StoryNode
{
	public var params:ChoiceNodeArgs;

	public function new(params:ChoiceNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):ChoiceNode
	{
		var options = json.options.map((opt) ->
		{
			var buttonType = opt.buttonType == null ? null : EnumTools.createByName(ButtonType, opt.buttonType);

			return {
				key: opt.key,
				nextNode: opt.nextNode,
				buttonText: opt.buttonText,
				buttonType: buttonType,
				value: opt.value,
			};
		});

		return new ChoiceNode({
			key: json.key,
			type: json.type,
			prompt: json.prompt,
			options: options,
			resultVariable: json.resultVariable,
		});
	}
}
