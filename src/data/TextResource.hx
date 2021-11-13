package data;

class TextResource
{
	public static function MakeText()
	{
		var bizcat = hxd.Res.fnt.bizcat.toFont();
		var text = new h2d.Text(bizcat);
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
