package data;

class TileResources
{
	public static var SETTLEMENT:h2d.Tile;
	public static var GROUND_WATER:h2d.Tile;
	public static var GROUND_SHALLOWS:h2d.Tile;
	public static var GROUND_SAND:h2d.Tile;
	public static var GROUND_GRASS:h2d.Tile;
	public static var CURSOR:h2d.Tile;
	public static var TREE:h2d.Tile;
	public static var FOG:h2d.Tile;
	public static var SLOOP:h2d.Tile;

	public function new() {}

	public static function Init()
	{
		var landmarkSheet = hxd.Res.img.landmarks_png.toTile();
		var landmarks = landmarkSheet.divide(4, 4);

		SETTLEMENT = landmarks[0][0];

		var terrainSheet = hxd.Res.img.iso32_png.toTile();
		var terrains = terrainSheet.divide(4, 2);

		GROUND_WATER = terrains[0][1];
		GROUND_SHALLOWS = terrains[1][1];
		GROUND_SAND = terrains[0][0];
		GROUND_GRASS = terrains[0][2];
		CURSOR = terrains[0][3];

		var treeSheet = hxd.Res.img.trees.toTile();
		var trees = treeSheet.divide(2, 1);

		TREE = trees[0][1];

		var fogSheet = hxd.Res.img.mask32.toTile();
		var fogs = fogSheet.divide(4, 1);

		FOG = fogs[0][0];

		SLOOP = hxd.Res.img.sloop_png.toTile();
	}
}
