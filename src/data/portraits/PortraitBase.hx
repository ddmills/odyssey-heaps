package data.portraits;

class PortraitBase
{
	public var tile(default, null):h2d.Tile;

	public function new(tile:h2d.Tile)
	{
		this.tile = tile;
	}
}
