package domain.entities;

class Ship extends Entity
{
	public function new()
	{
		var sloopTiles = hxd.Res.img.sloop.toTile().split(8);
		var anim = new h2d.Anim(sloopTiles, 0);

		anim.currentFrame = 4;

		super(anim);
	}
}
