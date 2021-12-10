package domain.screens.components;

import common.struct.FloatPoint;
import core.Game;
import domain.ui.Box;

typedef DialogOptions =
{
	width:Int,
	height:Int,
}

class Dialog extends h2d.Object
{
	var box:Box;
	var opts:DialogOptions;

	public var width(get, null):Int;
	public var height(get, null):Int;
	public var center(get, set):FloatPoint;

	public function new(opts:DialogOptions)
	{
		super();
		this.opts = opts;
		box = new Box({
			width: (opts.width / 32).floor(),
			height: (opts.height / 32).floor(),
			scale: 2,
			size: 16,
		});
		addChild(box);
		recenter();
	}

	public function recenter()
	{
		center = {
			x: Game.instance.window.width / 2,
			y: Game.instance.window.height / 2,
		};
	}

	function get_width():Int
	{
		return (opts.width / 32).floor() * 32;
	}

	function get_height():Int
	{
		return (opts.height / 32).floor() * 32;
	}

	function get_center():FloatPoint
	{
		return {
			x: x + width / 2,
			y: y + height / 2,
		}
	}

	function set_center(value:FloatPoint):FloatPoint
	{
		x = value.x - width / 2;
		y = value.y - height / 2;

		return value;
	}
}
