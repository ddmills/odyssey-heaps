package data;

class TileResources
{
	public static var SETTLEMENT:h2d.Tile;

	public function new() {}

	public static function Init()
	{
		var landmarkSheet = hxd.Res.img.landmarks.toTile();

		var landmarks = landmarkSheet.cut(4, 4);
		SETTLEMENT = landmarks[0][0];
	}
}
