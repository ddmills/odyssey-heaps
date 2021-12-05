package data.storylines.parameters;

class StoryParameter
{
	public var type(default, null):String;
	public var key(default, null):String;

	public function new(type:String, key:String)
	{
		this.type = type;
		this.key = key;
	}
}
