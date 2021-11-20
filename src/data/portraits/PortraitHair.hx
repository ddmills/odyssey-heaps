package data.portraits;

class PortraitHair
{
	public var front(default, null):h2d.Tile;
	public var back(default, null):h2d.Tile;

	public function new(front:h2d.Tile, back:h2d.Tile = null)
	{
		this.front = front;
		this.back = back;
	}
}
