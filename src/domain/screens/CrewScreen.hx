package domain.screens;

import core.Screen;
import data.Keybindings.Keybinding;
import data.Nationality;
import data.TextResource;
import data.TileResources;
import ecs.Entity;
import ecs.Query;
import ecs.components.CrewMember;
import ecs.components.Level;
import ecs.components.Nationality;
import ecs.components.Person;
import ecs.components.Profession;
import h2d.Bitmap;
import h2d.Object;

class CrewScreen extends Screen
{
	var query:Query;
	var ob:h2d.Object;

	public function new()
	{
		ob = new h2d.Object();
		query = new Query({
			all: [CrewMember, Person]
		});
	}

	public override function onDestroy()
	{
		query.dispose();
		ob.remove();
	}

	function renderMember(e:Entity)
	{
		var container = new h2d.Object();
		var txt = TextResource.MakeText();

		var person = e.get(Person);
		var nationality = e.get(Nationality).nation;
		var level = e.get(Level).lvl;
		var profession = e.get(Profession);
		var diceSet = profession.data.dice.getSet(level);

		txt.text = person.name;
		txt.text += '\n${nationality} Level ${level} ${profession.data.name}';
		var txtHeight = txt.textHeight;

		var setN = 0;
		for (set in diceSet)
		{
			var setOb = new Object();
			var dieN = 0;
			for (die in set)
			{
				var scale = 2;
				var tile = TileResources.getDie(die);
				var bm = new Bitmap(tile, setOb);
				bm.scale(scale);
				bm.y = setN * (tile.height * scale) + txtHeight;
				bm.x = dieN * (tile.width * scale);
				container.addChild(bm);
				dieN++;
			}
			setN++;
			container.addChild(txt);
		}
		container.addChild(txt);

		return container;
	}

	public override function onEnter()
	{
		var i = 0.;
		for (entity in query)
		{
			var member = renderMember(entity);

			member.y = i;

			ob.addChild(member);

			i += (member.getBounds().height + 8);
		}

		ob.x = 32;
		ob.y = 32;

		game.render(HUD, ob);
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
