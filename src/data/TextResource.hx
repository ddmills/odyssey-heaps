package data;

class TextResource
{
	public static function MakeText()
	{
		var bizcat = hxd.Res.fnt.bizcat.toFont();
		var text = new h2d.Text(bizcat);
		text.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);
		text.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x000000,
			alpha: .75
		};

		return text;
	}
}
