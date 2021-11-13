package data;

class TileResources
{
	public static var SETTLEMENT:h2d.Tile;
	public static var FARM:h2d.Tile;
	public static var WINDMILL:Array<h2d.Tile>;
	public static var GROUND_WATER:h2d.Tile;
	public static var GROUND_SHALLOWS:h2d.Tile;
	public static var GROUND_SAND:h2d.Tile;
	public static var GROUND_GRASS:h2d.Tile;
	public static var CURSOR:h2d.Tile;
	public static var TREE:h2d.Tile;
	public static var FOG:h2d.Tile;
	public static var SLOOP:h2d.Tile;

	public static var UI_BORDER_L:h2d.Tile;
	public static var UI_BORDER_R:h2d.Tile;
	public static var UI_BORDER_T:h2d.Tile;
	public static var UI_BORDER_B:h2d.Tile;
	public static var UI_BORDER_TL:h2d.Tile;
	public static var UI_BORDER_TR:h2d.Tile;
	public static var UI_BORDER_BR:h2d.Tile;
	public static var UI_BORDER_BL:h2d.Tile;
	public static var UI_FILL:h2d.Tile;

	public function new() {}

	public static function Init()
	{
		var landmarkSheet = hxd.Res.img.landmarks_png.toTile();
		var landmarks = landmarkSheet.divide(4, 4);

		SETTLEMENT = landmarks[0][0];
		FARM = landmarks[0][1];
		WINDMILL = [landmarks[0][2], landmarks[0][3]];

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

		var uiSheet = hxd.Res.img.ui16_png.toTile();
		var uis = uiSheet.divide(8, 8);

		UI_FILL = uis[1][1];
		UI_BORDER_L = uis[1][0];
		UI_BORDER_R = uis[1][2];
		UI_BORDER_T = uis[0][1];
		UI_BORDER_B = uis[2][1];
		UI_BORDER_TL = uis[0][0];
		UI_BORDER_TR = uis[0][2];
		UI_BORDER_BR = uis[2][2];
		UI_BORDER_BL = uis[2][0];
	}
}
