package core;

import h2d.Console;

class ConsoleConfig
{
	public static function Config(console:Console)
	{
		console.log('Type "help" for list of commands.');

		console.addCommand('exit', 'Close the console', [], () ->
		{
			Game.instance.screens.pop();
		});

		console.addAlias('quit', 'exit');

		console.addCommand('food', 'Set food value', [
			{
				name: 'value',
				opt: true,
				t: AInt,
			}
		], (value:Null<Int>) -> foodCommand(console, value));
	}

	static function foodCommand(console:Console, value:Null<Int>)
	{
		var food = value == null ? Game.instance.world.resources.food.max : value;
		console.log('Setting food to ${food}');
		Game.instance.world.resources.food.value = food;
	}
}
