package states.play;

import core.GameState;
import domain.screens.SailScreen;
import ecs.components.CrewMember;
import ecs.prefabs.PersonPrefab;
import ecs.prefabs.SquidPrefab;

class PlayState extends GameState
{
	public function new() {}

	override function create()
	{
		world.InitSystems();
		world.player.initialize();
		world.player.x = 360;
		world.player.y = 417;

		scene.add(world.layers.root, 0);

		var p1 = PersonPrefab.Create(50);
		p1.add(new CrewMember());
		var p2 = PersonPrefab.Create(64);
		p2.add(new CrewMember());
		var p3 = PersonPrefab.Create(65);
		p3.add(new CrewMember());
		var p4 = PersonPrefab.Create(52);
		p4.add(new CrewMember());

		var squid = SquidPrefab.Create(1);
		squid.x = 365;
		squid.y = 420;
		world.add(squid);

		var squid = SquidPrefab.Create(2);
		squid.x = 367;
		squid.y = 424;
		world.add(squid);

		var squid = SquidPrefab.Create(3);
		squid.x = 362;
		squid.y = 424;
		world.add(squid);

		game.screens.set(new SailScreen());
	}
}
