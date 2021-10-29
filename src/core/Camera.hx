package core;

import h2d.Object;

class Camera
{
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var zoom(get, set):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;

	var scroller(get, null):h2d.Object;

	public function new() {}

	function get_x():Float
	{
		var c = Game.instance.world.pxToWorld(-scroller.x, -scroller.y);

		return c.x;
	}

	function set_x(value:Float):Float
	{
		var p = Game.instance.world.worldToPx(value, y);

		scroller.x = -p.x;
		scroller.y = -p.y;

		return value;
	}

	function get_y():Float
	{
		var c = Game.instance.world.pxToWorld(-scroller.x, -scroller.y);

		return c.y;
	}

	function set_y(value:Float):Float
	{
		var p = Game.instance.world.worldToPx(x, value);

		scroller.x = -p.x;
		scroller.y = -p.y;

		return value;
	}

	function get_zoom():Float
	{
		return scroller.scaleX;
	}

	function set_zoom(value:Float):Float
	{
		scroller.setScale(value);

		return value;
	}

	function get_scroller():Object
	{
		return Game.instance.world.container;
	}

	inline function get_width():Float
	{
		return hxd.Window.getInstance().width;
	}

	inline function get_height():Float
	{
		return hxd.Window.getInstance().height;
	}
}
