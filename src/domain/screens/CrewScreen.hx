package domain.screens;

import core.Screen;
import data.Keybindings.Keybinding;
import data.TextResource;
import ecs.Query;
import ecs.components.CrewMember;
import ecs.components.Person;

class CrewScreen extends Screen
{
	var query:Query;
	var text:h2d.Text;

	public function new()
	{
		query = new Query({
			all: [CrewMember, Person]
		});
		text = TextResource.MakeText();
	}

	public override function onDestroy()
	{
		query.dispose();
		text.remove();
	}

	public override function onEnter()
	{
		text.text = 'Your Crew';

		for (entity in query)
		{
			var p = entity.get(Person);
			text.text += '\n  ${p.name}';
		}

		game.render(HUD, text);
	}

	override function onKeyUp(key:Int)
	{
		if (Keybinding.BACK.is(key) || Keybinding.CREW_SCREEN.is(key))
		{
			game.screens.pop();
			return;
		}
		if (Keybinding.MAP_SCREEN.is(key))
		{
			game.screens.replace(new MapScreen());
			return;
		}
	}
}
