package domain.systems;

import core.Frame;

class CameraSystem extends System
{
	public function new() {}

	public override function update(frame:Frame)
	{
		if (game.camera.follow != null)
		{
			game.camera.focus = game.camera.focus.lerp(game.camera.follow.pos, .1 * frame.tmod);
		}
		world.layers.sort(OBJECTS);
	}
}
