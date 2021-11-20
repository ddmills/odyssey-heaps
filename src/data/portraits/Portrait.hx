package data.portraits;

import h2d.Tile;

class Portrait
{
	public var base(default, null):PortraitBase;
	public var hair(default, null):PortraitHair;
	public var eyes(default, null):PortraitEyes;
	public var nose(default, null):PortraitNose;
	public var clothes(default, null):PortraitClothes;

	// public var ob(default, null):h2d.Object;

	public function new(base:PortraitBase, hair:PortraitHair, eyes:PortraitEyes, nose:PortraitNose, clothes:PortraitClothes)
	{
		this.base = base;
		this.hair = hair;
		this.eyes = eyes;
		this.nose = nose;
		this.clothes = clothes;
	}

	public function gen():h2d.Object
	{
		var ob = new h2d.Object();

		ob.addChild(new h2d.Bitmap(PortraitData.PORTRAIT_BG));
		// ob.addChild(new h2d.Bitmap(Tile.fromColor(0xd2d6b6, 40, 60)));

		if (hair.back != null)
		{
			ob.addChild(new h2d.Bitmap(hair.back));
		}
		ob.addChild(new h2d.Bitmap(clothes.tile));
		ob.addChild(new h2d.Bitmap(base.tile));
		ob.addChild(new h2d.Bitmap(eyes.tile));
		ob.addChild(new h2d.Bitmap(nose.tile));
		ob.addChild(new h2d.Bitmap(hair.front));
		ob.addChild(new h2d.Bitmap(PortraitData.PORTRAIT_TRIM));

		return ob;
	}
}
