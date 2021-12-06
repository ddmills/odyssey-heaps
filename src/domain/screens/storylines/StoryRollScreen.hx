package domain.screens.storylines;

import core.Screen;
import data.TextResource;
import data.TileResources;
import data.storylines.nodes.RollNode;
import domain.combat.dice.Die;
import domain.storylines.Storyline;
import domain.ui.Box;
import domain.ui.Button;
import ecs.components.Combatant;
import ecs.components.Level;

class StoryRollScreen extends Screen
{
	var storyline:Storyline;
	var dialog:h2d.Object;
	var rollNode:RollNode;
	var rollBtn:Button;

	public function new(storyline:Storyline)
	{
		this.storyline = storyline;
		dialog = new h2d.Object();
		rollNode = cast(storyline.currentNode, RollNode);
	}

	override function onEnter()
	{
		var box = new Box({
			width: 20,
			height: 10,
			scale: 2,
			size: 16,
		});

		var txt = TextResource.MakeText();
		txt.text = storyline.textReplace(rollNode.params.prompt);
		txt.maxWidth = 16 * 32;
		txt.dropShadow = null;
		txt.x = 32;
		txt.y = 32;
		txt.color = 0x000000.toHxdColor();

		dialog.addChild(box);
		dialog.addChild(txt);

		rollBtn = new Button();
		rollBtn.backgroundColor = 0x57723a;
		rollBtn.text = 'Roll';
		rollBtn.x = 128;
		rollBtn.y = 128;
		rollBtn.onClick = (e) -> rollDie();
		dialog.addChild(rollBtn);

		dialog.x = 32;
		dialog.y = 32;

		game.render(HUD, dialog);
	}

	function rollDie()
	{
		rollBtn.visible = false;
		var entity = storyline.getPerson(rollNode.params.person);
		var lvl = entity.get(Level).lvl;
		var dice = entity.get(Combatant).dice.getSet(lvl);

		var i = 0;
		var results = dice.map((die:Die) ->
		{
			var res = die.roll(Std.random(0x7FFFFFFF));

			var bm = new h2d.Bitmap();
			bm.scale(3);
			bm.x = 256 + i++ * 100;
			bm.y = 150;
			bm.tile = TileResources.getDie(res.value);
			dialog.addChild(bm);

			return res.value;
		});

		var success = results.contains(rollNode.params.face);

		var nextBtnText = '';
		var nextBtnColor = 0;

		if (success)
		{
			storyline.currentNodeKey = rollNode.params.onSuccessNode;
			nextBtnText = 'Success!';
			nextBtnColor = 0x57723a;
		}
		else
		{
			storyline.currentNodeKey = rollNode.params.onFailureNode;
			nextBtnText = 'Failure.';
			nextBtnColor = 0x804c36;
		}

		var nextBtn = new Button();
		nextBtn.backgroundColor = nextBtnColor;
		nextBtn.text = nextBtnText;
		nextBtn.x = 128;
		nextBtn.y = 128;
		nextBtn.onClick = (e) -> game.screens.pop();
		dialog.addChild(nextBtn);
	}

	override function onDestroy()
	{
		dialog.removeChildren();
		dialog.remove();
	}
}
