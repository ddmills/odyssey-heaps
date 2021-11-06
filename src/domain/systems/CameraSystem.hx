package domain.systems;

import core.Frame;
import ecs.Entity;
import ecs.EntityRef;

class CameraSystem extends System
{
	var ref:EntityRef;

	public var focus(get, set):Entity;

	inline function get_focus():Entity
	{
		return ref.entity;
	}

	inline function set_focus(value:Entity):Entity
	{
		ref.entity = value;
		return value;
	}

	public function new()
	{
		ref = new EntityRef();
	}

	public override function update(frame:Frame)
	{
		if (focus != null)
		{
			game.camera.focus = game.camera.focus.lerp(focus.pos, .1 * frame.tmod);
		}
		world.entities.ysort(0);
	}
}
