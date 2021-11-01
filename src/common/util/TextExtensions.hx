package common.util;

class TextExtensions
{
	static public function realWidth(text:h2d.Text)
	{
		return text.textWidth * text.scaleX;
	}

	static public function realHeight(text:h2d.Text)
	{
		return text.textHeight * text.scaleY;
	}

	static public function alignCenter(text:h2d.Text, within:h2d.Scene)
	{
		alignCenterX(text, within);
		alignCenterY(text, within);
	}

	static public function alignCenterX(text:h2d.Text, within:h2d.Scene)
	{
		text.x = (within.width / 2) - (realWidth(text) / 2);
	}

	static public function alignCenterY(text:h2d.Text, within:h2d.Scene)
	{
		text.y = (within.height / 2) - (realHeight(text) / 2);
	}

	static public function alignBottom(text:h2d.Text, within:h2d.Scene, padding:Float = 0)
	{
		text.y = within.height - realHeight(text) - padding;
	}

	static public function alignRight(text:h2d.Text, within:h2d.Scene, padding:Float = 0)
	{
		if (text.textAlign == Right)
		{
			text.x = within.width - padding;
		}
		else
		{
			text.x = within.width - realWidth(text) - padding;
		}
	}

	static public function alignTop(text:h2d.Text, within:h2d.Scene, padding:Float = 0)
	{
		text.y = 0 + padding;
	}

	static public function alignLeft(text:h2d.Text, within:h2d.Scene, padding:Float = 0)
	{
		text.x = 0 + padding;
	}
}
