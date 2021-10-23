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

	static public function center(text:h2d.Text, within:h2d.Scene)
	{
		text.x = (within.width / 2) - (realWidth(text) / 2);
		text.y = (within.height / 2) - (realHeight(text) / 2);
	}
}
