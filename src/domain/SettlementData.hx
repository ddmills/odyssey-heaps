package domain;

class SettlementData
{
	public var id(default, null):Int;
	public var map(default, null):MapData;

	public var x:Int;
	public var y:Int;

	public function new(id:Int, map:MapData)
	{
		this.id = id;
		this.map = map;
		x = -1;
		y = -1;
	}
}
