package domain.systems;

import core.Frame;

class CameraSystem extends System
{
	public function new() {}

	public override function update(frame:Frame)
	{
		if (game.camera.follow != null)
		{
			game.camera.focus = game.camera.focus.toPx().lerp(game.camera.follow.pos.toPx(), .1 * frame.tmod, 1);
		}
		world.layers.sort(OBJECTS);
	}
}
