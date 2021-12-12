package domain.screens.storylines;

import core.Screen;
import data.storylines.nodes.ChoiceNode;
import domain.screens.components.MultiChoiceDialog;
import domain.storylines.Storyline;

class StoryChoiceScreen extends Screen
{
	var storyline:Storyline;
	var dialog:MultiChoiceDialog;
	var choiceNode:ChoiceNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		choiceNode = cast(storyline.currentNode, ChoiceNode);
	}

	public override function onEnter()
	{
		dialog = new MultiChoiceDialog({
			title: storyline.story.name,
			width: 600,
			height: 400,
			text: storyline.textReplace(choiceNode.params.prompt),
			buttons: choiceNode.params.options.map((option) -> ({
				{
					text: storyline.textReplace(option.buttonText),
					type: option.buttonType,
					onClick: (e) ->
					{
						if (choiceNode.params.resultVariable != null)
						{
							var data = storyline.getData(option.value);
							storyline.setVariable(choiceNode.params.resultVariable, data);
						}

						storyline.currentNodeKey = option.nextNode;
						game.screens.pop();
					}
				}
			}))
		});

		game.render(HUD, dialog);
	}

	public override function onDestroy()
	{
		dialog.removeChildren();
		dialog.remove();
	}
}
