package domain.screens;

import core.Screen;
import data.Keybindings.Keybinding;

class InventoryScreen extends Screen
{
	public function new() {}

	override function onEnter()
	{
		trace('inventory screen');
	}

	override function onKeyUp(key:Int)
	{
		if (Keybinding.BACK.is(key) || Keybinding.INVENTORY_SCREN.is(key))
		{
			game.screens.pop();
		}
	}
}
