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
	public static var SLOOP:h2d.Tile;
	public static var SQUID:Array<h2d.Tile>;

	public static var UI_BORDER_L:h2d.Tile;
	public static var UI_BORDER_R:h2d.Tile;
	public static var UI_BORDER_T:h2d.Tile;
	public static var UI_BORDER_B:h2d.Tile;
	public static var UI_BORDER_TL:h2d.Tile;
	public static var UI_BORDER_TR:h2d.Tile;
	public static var UI_BORDER_BR:h2d.Tile;
	public static var UI_BORDER_BL:h2d.Tile;
	public static var UI_FILL:h2d.Tile;

	public static var DICE_ATK_EMPTY:h2d.Tile;
	public static var DICE_ATK_SWORD:h2d.Tile;
	public static var DICE_ATK_DBL_SWORD:h2d.Tile;
	public static var DICE_ATK_BOMB:h2d.Tile;
	public static var DICE_DEF_EMPTY:h2d.Tile;
	public static var DICE_DEF_SHIELD:h2d.Tile;
	public static var DICE_DEF_HEAL:h2d.Tile;
	public static var DICE_ODD_EMPTY:h2d.Tile;
	public static var DICE_ODD_SKULL:h2d.Tile;
	public static var DICE_ODD_BLOOD:h2d.Tile;
	public static var DICE_SQUID_EMPTY:h2d.Tile;
	public static var DICE_SQUID_TENTACLE:h2d.Tile;
	public static var DICE_SQUID_WAVE:h2d.Tile;

	public static var VIGNETTE_WATER:h2d.Tile;

	public function new() {}

	public static function Init()
	{
		var landmarkSheet = hxd.Res.img.landmarks_png.toTile();
		var landmarks = landmarkSheet.divide(4, 4);

		SETTLEMENT = landmarks[0][0];
		FARM = landmarks[0][1];
		WINDMILL = [landmarks[0][2], landmarks[0][3]];

		var terrainSheet = hxd.Res.img.iso40.toTile();
		var terrains = terrainSheet.divide(4, 4);
		var grass = hxd.Res.img.grass40.toTile();

		GROUND_WATER = terrains[0][1];
		GROUND_SHALLOWS = terrains[0][0];
		GROUND_SAND = terrains[0][2];
		GROUND_GRASS = grass; // terrains[0][3];
		CURSOR = terrains[1][0];

		var treeSheet = hxd.Res.img.trees.toTile();
		var trees = treeSheet.divide(2, 1);

		TREE = trees[0][1];

		SLOOP = hxd.Res.img.sloop40.toTile();

		var uiSheet = hxd.Res.img.ui16_2.toTile();
		var ui = uiSheet.divide(8, 8);

		UI_FILL = ui[1][1];
		UI_BORDER_L = ui[1][0];
		UI_BORDER_R = ui[1][2];
		UI_BORDER_T = ui[0][1];
		UI_BORDER_B = ui[2][1];
		UI_BORDER_TL = ui[0][0];
		UI_BORDER_TR = ui[0][2];
		UI_BORDER_BR = ui[2][2];
		UI_BORDER_BL = ui[2][0];

		var diceSheet = hxd.Res.img.dice16_png.toTile();
		var dice = diceSheet.divide(6, 6);

		DICE_ATK_EMPTY = dice[0][0];
		DICE_ATK_SWORD = dice[0][1];
		DICE_ATK_DBL_SWORD = dice[0][2];
		DICE_ATK_BOMB = dice[0][3];
		DICE_DEF_EMPTY = dice[1][0];
		DICE_DEF_SHIELD = dice[1][1];
		DICE_DEF_HEAL = dice[1][2];
		DICE_ODD_EMPTY = dice[2][0];
		DICE_ODD_SKULL = dice[2][1];
		DICE_ODD_BLOOD = dice[2][2];
		DICE_SQUID_EMPTY = dice[3][0];
		DICE_SQUID_TENTACLE = dice[3][1];
		DICE_SQUID_WAVE = dice[3][2];

		var monsterSheet = hxd.Res.img.monster40.toTile();
		var monsters = monsterSheet.divide(4, 4);

		SQUID = [monsters[0][0], monsters[0][1], monsters[0][2], monsters[0][1]];

		VIGNETTE_WATER = hxd.Res.img.vignette.water2.toTile();
	}

	public static function getDie(die:DieFace):h2d.Tile
	{
		switch die
		{
			case ATK_EMPTY:
				return DICE_ATK_EMPTY;
			case ATK_SWORD:
				return DICE_ATK_SWORD;
			case ATK_DBL_SWORD:
				return DICE_ATK_DBL_SWORD;
			case ATK_BOMB:
				return DICE_ATK_BOMB;
			case DEF_EMPTY:
				return DICE_DEF_EMPTY;
			case DEF_SHIELD:
				return DICE_DEF_SHIELD;
			case DEF_HEAL:
				return DICE_DEF_HEAL;
			case ODD_EMPTY:
				return DICE_ODD_EMPTY;
			case ODD_SKULL:
				return DICE_ODD_SKULL;
			case ODD_BLOOD:
				return DICE_ODD_BLOOD;
			case SQUID_EMPTY:
				return DICE_SQUID_EMPTY;
			case SQUID_TENTACLE:
				return DICE_SQUID_TENTACLE;
			case SQUID_WAVE:
				return DICE_SQUID_WAVE;
		}
	}
}
