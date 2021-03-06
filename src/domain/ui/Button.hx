package domain.ui;

import data.TextResource;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Text;

enum ButtonType
{
	DEFAULT;
	DANGER;
	SUCCESS;
}

typedef ButtonOptions =
{
	var text:String;
	var onClick:(e:hxd.Event) -> Void;
	var type:ButtonType;
}

class Button extends h2d.Object
{
	public var width(default, set):Int;
	public var height(default, set):Int;
	public var text(default, set):String;
	public var backgroundColor(default, set):Int;
	public var textColor(default, set):Int;
	public var textOb(default, null):Text;
	public var type(null, set):ButtonType;

	var bm:h2d.Bitmap;
	var interactive:h2d.Interactive;

	public function new()
	{
		super();

		bm = new Bitmap(h2d.Tile.fromColor(0x000000, 0, 0));

		textOb = TextResource.MakeText();
		textOb.text = '';
		textOb.textAlign = Center;

		interactive = new Interactive(0, 0);

		addChild(bm);
		addChild(textOb);
		addChild(interactive);

		interactive.onClick = (e) -> onClick(e);

		width = 128;
		height = 28;
		backgroundColor = 0x000000;
		text = '';
	}

	function set_width(value:Int):Int
	{
		bm.width = value;
		interactive.width = value;
		textOb.x = value / 2;
		width = value;
		return value;
	}

	function set_height(value:Int):Int
	{
		bm.height = value;
		interactive.height = value;
		textOb.y = (value / 2) - 8;
		height = value;
		return value;
	}

	function set_text(value:String):String
	{
		textOb.text = value;
		text = value;
		width = textOb.textWidth.round() + 32;
		return value;
	}

	function set_backgroundColor(value:Int):Int
	{
		bm.tile = h2d.Tile.fromColor(value, width, height);
		backgroundColor = value;
		return value;
	}

	function set_textColor(value:Int):Int
	{
		textOb.color = value.toHxdColor();
		textColor = value;
		return value;
	}

	public dynamic function onClick(e:hxd.Event) {}

	function set_type(value:ButtonType):ButtonType
	{
		var val = (value == null) ? DEFAULT : value;

		switch val
		{
			case DEFAULT:
				backgroundColor = 0x1c3e4e;
			case DANGER:
				backgroundColor = 0x804c36;
			case SUCCESS:
				backgroundColor = 0x57723a;
		}

		return val;
	}
}
