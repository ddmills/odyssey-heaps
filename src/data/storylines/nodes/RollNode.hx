package data.storylines.nodes;

import data.DieFace;
import haxe.EnumTools;

typedef RollNodeArgs =
{
	var key:String;
	var type:String;
	var prompt:String;
	var person:String;
	var faces:Array<DieFace>;
	var onSuccessNode:String;
	var onFailureNode:String;
}

class RollNode extends StoryNode
{
	public var params:RollNodeArgs;

	public function new(params:RollNodeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryNode
	{
		var faces = json.faces.map((face) -> EnumTools.createByName(DieFace, face));

		return new RollNode({
			key: json.key,
			type: json.type,
			prompt: json.prompt,
			person: json.person,
			onSuccessNode: json.onSuccessNode,
			onFailureNode: json.onFailureNode,
			faces: faces
		});
	}
}
