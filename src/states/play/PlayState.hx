package states.play;

import core.GameState;
import data.storylines.Stories;
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

		world.storylines.tryAddStory(Stories.TEST_STORY);

		var squid1 = SquidPrefab.Create();
		squid1.x = 368;
		squid1.y = 420;
		world.add(squid1);

		var squid2 = SquidPrefab.Create();
		squid2.x = 367;
		squid2.y = 424;
		world.add(squid2);

		var squid3 = SquidPrefab.Create();
		squid3.x = 362;
		squid3.y = 424;
		world.add(squid3);

		game.screens.set(new SailScreen());
	}
}
