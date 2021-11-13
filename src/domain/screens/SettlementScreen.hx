package domain.screens;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import data.TextResource;
import domain.ui.Box;
import ecs.Entity;
import ecs.Query;
import ecs.components.CrewMember;
import ecs.components.InSettlement;
import ecs.components.Person;
import ecs.components.Settlement;

class SettlementScreen extends Screen
{
	var settlement:Entity;
	var text:h2d.Text;
	var people:Array<Person>;
	var peopleText:h2d.Text;
	var query:Query;
	var box:Box;

	public function new(settlement:Entity)
	{
		this.settlement = settlement;
		people = new Array();
		peopleText = TextResource.MakeText();
		peopleText.color = 0x1b1f23.toHxdColor();
		peopleText.dropShadow = null;
		peopleText.setScale(1);

		text = TextResource.MakeText();
		text.setScale(2);
		text.text = settlement.get(Settlement).name;

		query = new Query({
			all: [Person, InSettlement]
		});

		box = new Box({
			width: 1,
			height: 1,
			scale: 2,
			size: 16,
		});
	}

	function redrawPeople()
	{
		var settlementId = settlement.get(Settlement).id;
		people = query.filter((e) -> e.get(InSettlement).settlementId == settlementId)
			.map((e) -> e.get(Person));

		peopleText.text = 'Settlers of ${settlement.get(Settlement).name}';
		var i = 1;
		for (person in people)
		{
			peopleText.text += '\n [${i++}] ${person.name}';
		}

		var boxW = (peopleText.textWidth / 32).ciel();
		var boxH = (peopleText.textHeight / 32).ciel();

		box.redraw({
			width: boxW + 2,
			height: boxH + 2,
			scale: 2,
			size: 16,
		});

		box.x = 16;
		box.y = 16;
		peopleText.x = box.x + 32;
		peopleText.y = box.y + 32;
	}

	override function onEnter()
	{
		game.render(HUD, box);
		game.render(HUD, text);
		game.render(HUD, peopleText);
		redrawPeople();
	}

	override function onDestroy()
	{
		text.remove();
		peopleText.remove();
		box.remove();
		query.dispose();
	}

	override function onMouseDown(click:Coordinate)
	{
		game.screens.pop();
	}

	override function onKeyUp(key:Int)
	{
		// allow key 1-9
		var n = (key - 48);
		if (n > 0 && n < 10)
		{
			var person = people[n - 1];
			if (person != null)
			{
				people.remove(person);
				person.entity.remove(InSettlement);
				person.entity.add(new CrewMember());
				redrawPeople();
			}
		}
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		var screen = settlement.pos.toScreen();
		text.textAlign = Center;
		text.x = screen.x;
		text.y = screen.y - 64;
	}
}
