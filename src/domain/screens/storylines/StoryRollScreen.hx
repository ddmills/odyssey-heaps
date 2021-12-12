package domain.screens.storylines;

import core.Frame;
import core.Screen;
import data.TextResource;
import data.TileResources;
import data.storylines.nodes.RollNode;
import domain.combat.dice.Die;
import domain.screens.components.SimpleDialog;
import domain.storylines.Storyline;
import domain.ui.Button;
import ecs.components.Combatant;
import ecs.components.Level;

class StoryRollScreen extends Screen
{
	var storyline:Storyline;
	var dialog:SimpleDialog;
	var rollNode:RollNode;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		rollNode = cast(storyline.currentNode, RollNode);
	}

	override function onEnter()
	{
		dialog = new SimpleDialog({
			title: storyline.story.name,
			width: 600,
			height: 400,
			text: storyline.textReplace(rollNode.params.prompt),
			button: {
				text: 'Roll',
				type: DEFAULT,
				onClick: (e) ->
				{
					rollDie();
				}
			}
		});

		game.render(HUD, dialog);
	}

	function rollDie()
	{
		var entity = storyline.getPerson(rollNode.params.person);
		var lvl = entity.get(Level).lvl;
		var dice = entity.get(Combatant).dice.getSet(lvl);

		var i = 0;
		var results = dice.map((die:Die) ->
		{
			var res = die.roll(storyline.rand.random(100));

			var bm = new h2d.Bitmap();
			bm.scale(3);
			bm.x = 32 + i++ * 80;
			bm.y = 128;
			bm.tile = TileResources.getDie(res.value);
			dialog.addChild(bm);

			return res.value;
		});

		var success = results.exists(((v) -> rollNode.params.faces.contains(v)));

		if (success)
		{
			storyline.currentNodeKey = rollNode.params.onSuccessNode;
			dialog.button.text = 'Success!';
			dialog.button.type = SUCCESS;
		}
		else
		{
			storyline.currentNodeKey = rollNode.params.onFailureNode;
			dialog.button.text = 'Failure.';
			dialog.button.type = DANGER;
		}

		dialog.button.onClick = (e) -> game.screens.pop();
	}

	override function onDestroy()
	{
		dialog.removeChildren();
		dialog.remove();
	}

	override function update(frame:Frame)
	{
		dialog.recenter();
	}
}
