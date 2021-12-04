package domain.systems;

import common.util.Timeout;
import core.Frame;
import ecs.EntityRef;
import ecs.Query;
import ecs.components.Energy;
import ecs.components.IsPlayer;
import ecs.components.Turn;

class TurnSystem extends System
{
	var timeout:Timeout;

	public var current(default, null):EntityRef;

	public function new()
	{
		current = new EntityRef();
		timeout = new Timeout(.05);
	}

	override function update(frame:Frame)
	{
		timeout.update();
		var e = current.entity;

		if (e == null)
		{
			return;
		}

		var turn = e.get(Turn);

		if (!turn.isStarted)
		{
			if (e.has(IsPlayer))
			{
				trace('START PLAYER TURN');
				world.player.startTurn();
				turn.isStarted = true;
			}
			else
			{
				trace('START ENEMY TURN');
				turn.isStarted = true;
				timeout.onComplete = () ->
				{
					e.get(Energy).consumeEnergy(1000);
				};
				timeout.reset();
			}
		}

		if (!e.get(Energy).hasEnergy)
		{
			trace('TURN OVER');
			e.remove(Turn);
			current.entity = null;
		}
	}
}
