package domain;

class IslandData
{
	public var id(default, null):Int;
	public var map(default, null):MapData;
	public var size(get, never):Int;
	public var tiles:Array<{x:Int, y:Int}>;

	public function new(id:Int, map:MapData)
	{
		this.id = id;
		this.map = map;
		tiles = new Array();
	}

	public inline function get_size():Int
	{
		return tiles.length;
	}
}
