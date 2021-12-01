package data.portraits;

import data.portraits.PortraitClothes;
import data.portraits.PortraitHair;
import data.portraits.PortraitNose;

typedef PortraitParts =
{
	var BASE:Array<PortraitBase>;
	var CLOTHES:Array<PortraitClothes>;
	var HAIR:Array<PortraitHair>;
	var EYES:Array<PortraitEyes>;
	var NOSE:Array<PortraitNose>;
}

class PortraitData
{
	public static var PORTRAIT_BG:h2d.Tile;
	public static var PORTRAIT_TRIM:h2d.Tile;
	public static var PORTRAIT_TENTACLE:h2d.Tile;

	public static var BASE_1:PortraitBase;
	public static var BASE_2:PortraitBase;

	public static var BASE_F:Array<PortraitBase>;
	public static var BASE_M:Array<PortraitBase>;

	public static var HAIR_F_1:PortraitHair;
	public static var HAIR_F_2:PortraitHair;
	public static var HAIR_F_3:PortraitHair;
	public static var HAIR_F_4:PortraitHair;
	public static var HAIR_M_1:PortraitHair;
	public static var HAIR_M_2:PortraitHair;
	public static var HAIR_M_3:PortraitHair;

	public static var HAIR_F:Array<PortraitHair>;
	public static var HAIR_M:Array<PortraitHair>;

	public static var EYES_F_1:PortraitEyes;
	public static var EYES_F_2:PortraitEyes;
	public static var EYES_F_3:PortraitEyes;
	public static var EYES_M_1:PortraitEyes;
	public static var EYES_M_2:PortraitEyes;
	public static var EYES_M_3:PortraitEyes;

	public static var EYES_F:Array<PortraitEyes>;
	public static var EYES_M:Array<PortraitEyes>;

	public static var CLOTHES_1:PortraitClothes;
	public static var CLOTHES_2:PortraitClothes;
	public static var CLOTHES_3:PortraitClothes;

	public static var CLOTHES_F:Array<PortraitClothes>;
	public static var CLOTHES_M:Array<PortraitClothes>;

	public static var NOSE_F_1:PortraitNose;
	public static var NOSE_F_2:PortraitNose;
	public static var NOSE_F_3:PortraitNose;
	public static var NOSE_M_1:PortraitNose;
	public static var NOSE_M_2:PortraitNose;

	public static var NOSE_F:Array<PortraitNose>;
	public static var NOSE_M:Array<PortraitNose>;

	public static var PARTS_M:PortraitParts;
	public static var PARTS_F:PortraitParts;

	public static function Init()
	{
		var dat = hxd.Res.img.portraits;
		var dat2 = hxd.Res.img.portrait;

		PORTRAIT_BG = dat2.background.toTile();
		PORTRAIT_TRIM = dat2.trim.toTile();

		PORTRAIT_TENTACLE = dat.monster.tentacle.toTile();

		BASE_1 = new PortraitBase(dat2.base.base_1.toTile());
		BASE_2 = new PortraitBase(dat.base2.toTile());
		BASE_F = [BASE_1];
		BASE_M = [BASE_1];

		EYES_F_1 = new PortraitEyes(dat.eyes_f_1.toTile());
		EYES_F_2 = new PortraitEyes(dat.eyes_f_2.toTile());
		EYES_F_3 = new PortraitEyes(dat.eyes_f_3.toTile());
		EYES_M_1 = new PortraitEyes(dat2.eyes.eyes_m_1.toTile());
		EYES_M_2 = new PortraitEyes(dat2.eyes.eyes_m_2.toTile());
		EYES_M_3 = new PortraitEyes(dat2.eyes.eyes_m_3.toTile());

		EYES_F = [EYES_F_1, EYES_F_2, EYES_F_3];
		EYES_M = [EYES_M_1, EYES_M_2, EYES_M_3];

		CLOTHES_1 = new PortraitClothes(dat2.clothing.clothing1.toTile());
		CLOTHES_2 = new PortraitClothes(dat.clothing2.toTile());
		CLOTHES_3 = new PortraitClothes(dat.clothing3.toTile());

		CLOTHES_F = [CLOTHES_1];
		CLOTHES_M = [CLOTHES_1];

		HAIR_F_1 = new PortraitHair(dat.hair_f_1_front.toTile(), dat.hair_f_1_back.toTile());
		HAIR_F_2 = new PortraitHair(dat.hair_f_2_front.toTile());
		HAIR_F_3 = new PortraitHair(dat.hair_f_3_front.toTile(), dat.hair_f_3_back.toTile());
		HAIR_F_4 = new PortraitHair(dat.hair_f_4_front.toTile());
		HAIR_M_1 = new PortraitHair(dat2.hair.hair_m_1_front.toTile(), dat2.hair.hair_m_1_back.toTile());
		HAIR_M_2 = new PortraitHair(dat2.hair.hair_m_2_front.toTile(), dat2.hair.hair_m_2_back.toTile());
		HAIR_M_3 = new PortraitHair(dat.hair_m_3_front.toTile());

		HAIR_F = [HAIR_F_1, HAIR_F_2, HAIR_F_3, HAIR_F_4];
		HAIR_M = [HAIR_M_1, HAIR_M_2];

		NOSE_F_1 = new PortraitNose(dat.nose_f_1.toTile());
		NOSE_F_2 = new PortraitNose(dat.nose_f_2.toTile());
		NOSE_F_3 = new PortraitNose(dat.nose_f_3.toTile());
		NOSE_M_1 = new PortraitNose(dat2.nose.nose_m_1.toTile());
		NOSE_M_2 = new PortraitNose(dat2.nose.nose_m_2.toTile());

		NOSE_F = [NOSE_F_1, NOSE_F_2, NOSE_F_3];
		NOSE_M = [NOSE_M_1, NOSE_M_2];

		PARTS_M = {
			BASE: BASE_M,
			HAIR: HAIR_M,
			EYES: EYES_M,
			CLOTHES: CLOTHES_M,
			NOSE: NOSE_M,
		};
		PARTS_F = {
			BASE: BASE_F,
			HAIR: HAIR_F,
			EYES: EYES_F,
			CLOTHES: CLOTHES_F,
			NOSE: NOSE_F,
		};
	}
}
