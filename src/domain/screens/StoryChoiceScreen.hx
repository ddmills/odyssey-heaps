package domain.screens;

import core.Screen;
import data.TextResource;
import data.storylines.nodes.ChoiceNode;
import domain.storylines.Storyline;
import domain.ui.Box;

class StoryChoiceScreen extends Screen
{
	var storyline:Storyline;
	var dialog:h2d.Object;
	var choice:ChoiceNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		dialog = new h2d.Object();
		choice = cast(storyline.currentNode, ChoiceNode);
	}

	public override function onEnter()
	{
		var box = new Box({
			width: 20,
			height: 10,
			scale: 2,
			size: 16,
		});

		var txt = TextResource.MakeText();
		txt.text = choice.params.prompt;
		txt.textAlign = Center;
		txt.dropShadow = null;
		txt.x = 10 * 32;
		txt.y = 32;
		txt.color = 0x000000.toHxdColor();

		dialog.addChild(box);
		dialog.addChild(txt);

		dialog.x = 32;
		dialog.y = 32;

		game.render(HUD, dialog);
	}

	public override function onDestroy()
	{
		dialog.remove();
	}
}
