package data.storylines.nodes;

class StoryNode
{
	public var type(default, null):String;
	public var key(default, null):String;
	public var isEnd(get, null):Bool;

	public function new(type:String, key:String)
	{
		this.type = type;
		this.key = key;
	}

	function get_isEnd():Bool
	{
		return key.toLowerCase() == 'end';
	}
}
