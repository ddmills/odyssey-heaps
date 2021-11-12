package domain.screens;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import data.TextResource;
import ecs.Entity;
import ecs.Query;
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

	public function new(settlement:Entity)
	{
		this.settlement = settlement;
		people = new Array();
		peopleText = TextResource.MakeText();
		text = TextResource.MakeText();
		text.setScale(2);
		text.y = 256;
		text.text = settlement.get(Settlement).name;

		query = new Query({
			all: [Person, InSettlement]
		});
	}

	override function onEnter()
	{
		game.render(HUD, text);
		game.render(HUD, peopleText);

		var settlementId = settlement.get(Settlement).id;

		for (e in query)
		{
			if (e.get(InSettlement).settlementId == settlementId)
			{
				people.push(e.get(Person));
			};
		}
	}

	override function onDestroy()
	{
		text.remove();
		peopleText.remove();
		query.dispose();
	}

	override function onMouseDown(click:Coordinate)
	{
		game.screens.pop();
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		text.alignCenterX(game.state.scene);

		peopleText.text = "Settlers";

		for (person in people)
		{
			peopleText.text += '\n${person.name}';
		}

		peopleText.alignLeft(game.state.scene, 32);
		peopleText.y = 32;
	}
}
