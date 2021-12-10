package domain.screens.storylines;

import core.Frame;
import core.Screen;
import data.storylines.nodes.TextNode;
import domain.screens.components.SimpleDialog;
import domain.storylines.Storyline;
import domain.ui.Button;

class StoryTextScreen extends Screen
{
	var storyline:Storyline;
	var dialog:SimpleDialog;
	var textNode:TextNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		textNode = cast(storyline.currentNode, TextNode);
	}

	public override function onEnter()
	{
		dialog = new SimpleDialog({
			width: 600,
			height: 400,
			text: storyline.textReplace(textNode.params.prompt),
			button: {
				text: storyline.textReplace(textNode.params.actionText),
				type: DEFAULT,
				onClick: (e) ->
				{
					storyline.currentNodeKey = textNode.params.nextNode;
					game.screens.pop();
				}
			}
		});

		game.render(HUD, dialog);
	}

	public override function onDestroy()
	{
		dialog.remove();
	}

	public override function update(frame:Frame)
	{
		dialog.recenter();
	}
}
