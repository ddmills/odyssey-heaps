package domain.components;

import common.struct.Cardinal;

class Direction extends Component
{
	public var cardinal(default, set):Cardinal;

	public function new(value:Cardinal = NORTH)
	{
		cardinal = value;
	}

	function set_cardinal(value:Cardinal):Cardinal
	{
		cardinal = value;
		if (isAttached)
		{
			var anim = entity.get(Sprite);
			if (anim != null)
			{
				cast(anim.ob, h2d.Anim).currentFrame = value.toFrame();
			}
		}
		return cardinal;
	}
}
