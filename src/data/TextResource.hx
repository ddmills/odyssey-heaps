package data;

import h2d.Font;

class TextResource
{
	public static var BIZCAT:Font;

	public static function Init()
	{
		BIZCAT = hxd.Res.fnt.bizcat.toFont();
	}

	public static function MakeText()
	{
		var text = new h2d.Text(BIZCAT);
		text.color = 0xd2d6b6.toHxdColor();
		text.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x1b1f23,
			alpha: .75
		};

		return text;
	}
}
