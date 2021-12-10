package data.storylines.nodes;

import domain.ui.Button.ButtonType;
import haxe.EnumTools;

typedef TextNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var buttonText:String;
	var buttonType:ButtonType;
	var nextNode:String;
}

class TextNode extends StoryNode
{
	public var params:TextNodeArgs;

	public function new(params:TextNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):TextNode
	{
		var buttonTypeTxt:String = json.buttonType == null ? 'DEFAULT' : json.buttonType;
		var buttonType = EnumTools.createByName(ButtonType, buttonTypeTxt);
		var buttonText = json.buttonText == null ? 'Okay' : json.buttonText;

		return new TextNode({
			key: json.key,
			type: json.type,
			prompt: json.prompt,
			buttonText: buttonText,
			buttonType: buttonType,
			nextNode: json.nextNode,
		});
	}
}
