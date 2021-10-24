package core;

import domain.World;

class Game
{
	public var TSIZE:Int = 8;

	public static var instance:Game;

	var states:GameStateManager;

	public var state(get, never):GameState;
	public var backgroundColor(get, set):Int;
	public var frame(default, null):Frame;
	public var app(default, null):hxd.App;
	public var world(default, null):World;

	private function new(app:hxd.App, initialState:GameState)
	{
		instance = this;
		this.app = app;
		frame = new Frame();
		world = new World();
		states = new GameStateManager();
		setState(initialState);
	}

	public static function Create(app:hxd.App, initialState:GameState)
	{
		if (instance != null)
		{
			return instance;
		}

		return new Game(app, initialState);
	}

	inline function get_state():GameState
	{
		return states.current;
	}

	public function setState(next:GameState)
	{
		instance.states.setState(next);
	}

	public inline function update()
	{
		frame.update();
		state._update(frame);
	}

	function get_backgroundColor():Int
	{
		return app.engine.backgroundColor;
	}

	function set_backgroundColor(value:Int):Int
	{
		return app.engine.backgroundColor = value;
	}
}
