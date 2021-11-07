package domain.screens;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import ecs.Entity;
import ecs.components.Settlement;

class SettlementScreen extends Screen
{
	var settlement:Entity;
	var text:h2d.Text;

	public function new(settlement:Entity)
	{
		this.settlement = settlement;
		var bizcat = hxd.Res.fnt.bizcat.toFont();
		text = new h2d.Text(bizcat);
		text.setScale(2);
		text.color = new h3d.Vector(204 / 256, 207 / 255, 201 / 255);
		text.dropShadow = {
			dx: 1,
			dy: 1,
			color: 0x000000,
			alpha: .75
		};
		text.text = settlement.get(Settlement).name;
	}

	override function onEnter()
	{
		game.render(HUD, text);
	}

	override function onDestroy()
	{
		text.remove();
	}

	override function onMouseDown(click:Coordinate)
	{
		game.screens.pop();
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		text.alignCenter(game.state.scene);
	}
}
