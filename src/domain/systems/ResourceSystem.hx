package domain.systems;

import core.Frame;

class ResourceSystem extends System
{
	public var food(default, null):Resource;
	public var water(default, null):Resource;

	public function new()
	{
		food = new Resource(80, 100);
		water = new Resource(80, 100);
	}

	override function update(frame:Frame)
	{
		if (world.clock.turnDelta <= 0)
		{
			return;
		}

		food.value -= 1;
	}
}
