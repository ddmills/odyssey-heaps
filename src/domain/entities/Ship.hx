package domain.entities;

import common.struct.Cardinal;

class Ship extends Entity
{
	var anim:h2d.Anim;

	public var cardinal(default, set):Cardinal;

	public function new()
	{
		var sloopTiles = hxd.Res.img.sloop_png.toTile().split(8);
		anim = new h2d.Anim(sloopTiles, 0);
		set_cardinal(WEST);
		super(anim);
		offsetY = sloopTiles[0].height / 2;
	}

	function set_cardinal(value:Cardinal):Cardinal
	{
		cardinal = value;
		anim.currentFrame = value.toFrame();
		return cardinal;
	}
}