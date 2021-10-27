package domain;

import core.Game;

class Entity
{
	public var world(get, null):World;
	public var x(default, set):Float;
	public var y(default, set):Float;

	public var ob(default, null):h2d.Object;
	public var offsetX(default, null):Float;
	public var offsetY(default, null):Float;

	public function new(ob:h2d.Object)
	{
		this.ob = ob;
		offsetX = Game.instance.TILE_W_HALF;
		offsetY = Game.instance.TILE_H;
	}

	function get_world():World
	{
		return Game.instance.world;
	}

	function set_x(v:Float):Float
	{
		var c = world.worldToPx(v, y);
		ob.x = c.x - offsetX;
		ob.y = c.y - offsetY;
		x = v;
		return v;
	}

	function set_y(v:Float):Float
	{
		var c = world.worldToPx(x, v);
		ob.x = c.x - offsetX;
		ob.y = c.y - offsetY;
		y = v;
		return v;
	}
}
