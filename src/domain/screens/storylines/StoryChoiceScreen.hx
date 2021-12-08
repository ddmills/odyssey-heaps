package domain.screens.storylines;

import core.Screen;
import data.TextResource;
import data.storylines.nodes.ChoiceNode;
import domain.storylines.Storyline;
import domain.ui.Box;
import domain.ui.Button;

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
		txt.text = storyline.textReplace(choice.params.prompt);
		txt.dropShadow = null;
		txt.x = 32;
		txt.y = 32;
		txt.maxWidth = 16 * 32;
		txt.color = 0x000000.toHxdColor();

		dialog.addChild(box);
		dialog.addChild(txt);

		choice.params.options.each((opt, idx) ->
		{
			var btn = new Button();
			btn.backgroundColor = 0x57723a;
			btn.text = storyline.textReplace(opt.title);
			btn.x = 128;
			btn.y = 100 + 40 * idx;
			btn.width = btn.textOb.textWidth.floor() + 64;
			dialog.addChild(btn);
			btn.onClick = (e) ->
			{
				if (choice.params.resultVar != null)
				{
					var data = storyline.getData(opt.resultVal);
					storyline.setVariable(choice.params.resultVar, data);
				}

				game.screens.pop();
				storyline.currentNodeKey = opt.nextNode;
			};

			dialog.x = 32;
			dialog.y = 32;
		});

		game.render(HUD, dialog);
	}

	public override function onDestroy()
	{
		dialog.removeChildren();
		dialog.remove();
	}
}
