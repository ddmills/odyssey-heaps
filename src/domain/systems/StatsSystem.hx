package domain.systems;

import core.Frame;
import domain.overlays.StatsOverlay;
import tools.Stats;

class StatsSystem extends System
{
	var overlay:StatsOverlay;

	public function new()
	{
		var stats = new Stats();
		// stats.show('vision');

		overlay = new StatsOverlay(stats);

		game.render(HUD, overlay);
	}

	public override function update(frame:Frame)
	{
		overlay.update();
	}
}
