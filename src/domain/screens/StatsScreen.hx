package domain.screens;

import core.Frame;
import core.Screen;
import tools.Stats;

class StatsScreen extends Screen
{
	var stats:Stats;

	public function new()
	{
		stats = new Stats();
		stats.show('movement');
		stats.show('vision');
	}

	public override function onEnter()
	{
		stats.attach(game.state.scene);
	}

	public override function onDestroy()
	{
		stats.detach();
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		stats.update();
	}
}
