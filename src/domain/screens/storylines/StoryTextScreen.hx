package domain.screens.storylines;

import core.Screen;
import data.TextResource;
import data.storylines.nodes.TextNode;
import domain.storylines.Storyline;
import domain.ui.Box;
import domain.ui.Button;

class StoryTextScreen extends Screen
{
	var storyline:Storyline;
	var dialog:h2d.Object;
	var textNode:TextNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		dialog = new h2d.Object();
		textNode = cast(storyline.currentNode, TextNode);
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
		txt.text = storyline.textReplace(textNode.params.prompt);
		txt.dropShadow = null;
		txt.x = 32;
		txt.y = 32;
		txt.maxWidth = 16 * 32;
		txt.color = 0x000000.toHxdColor();

		dialog.addChild(box);
		dialog.addChild(txt);

		var actionBtn = new Button();
		actionBtn.backgroundColor = 0x57723a;
		actionBtn.text = storyline.textReplace(textNode.params.actionText);
		actionBtn.width = actionBtn.textOb.textWidth.floor() + 64;
		actionBtn.x = 128;
		actionBtn.y = 128;
		actionBtn.onClick = (e) ->
		{
			storyline.currentNodeKey = textNode.params.nextNode;
			game.screens.pop();
		};
		dialog.addChild(actionBtn);

		dialog.x = 32;
		dialog.y = 32;

		game.render(HUD, dialog);
	}

	public override function onDestroy()
	{
		dialog.remove();
	}
}
