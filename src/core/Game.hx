package core;

import core.rendering.RenderLayerManager.RenderLayerType;
import data.DieFace;
import domain.World;
import ecs.Registry;
import haxe.EnumTools;
import hxd.Window;
import tools.Performance;

class Game
{
	public var TILE_W:Int = 40;
	public var TILE_H:Int = 20;

	public var TILE_W_HALF(get, never):Int;
	public var TILE_H_HALF(get, never):Int;

	public static var instance:Game;

	var states:GameStateManager;

	public var state(get, never):GameState;
	public var backgroundColor(get, set):Int;
	public var frame(default, null):Frame;
	public var app(default, null):hxd.App;
	public var world(default, null):World;
	public var camera(default, null):Camera;
	public var registry(default, null):Registry;
	public var window(get, never):hxd.Window;
	public var screens(default, null):ScreenManager;

	private function new(app:hxd.App, initialState:GameState)
	{
		instance = this;
		this.app = app;
		registry = new Registry();
		frame = new Frame();
		world = new World();
		states = new GameStateManager();
		screens = new ScreenManager();
		camera = new Camera();
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
		Performance.update(frame.dt * 1000);
		frame.update();
		state._update(frame);
		screens.current.update(frame);
	}

	public inline function render(layer:RenderLayerType, ob:h2d.Object)
	{
		return world.layers.render(layer, ob);
	}

	function get_backgroundColor():Int
	{
		return app.engine.backgroundColor;
	}

	function set_backgroundColor(value:Int):Int
	{
		return app.engine.backgroundColor = value;
	}

	inline function get_TILE_W_HALF():Int
	{
		return Math.floor(TILE_W / 2);
	}

	inline function get_TILE_H_HALF():Int
	{
		return Math.floor(TILE_H / 2);
	}

	inline function get_window():Window
	{
		return hxd.Window.getInstance();
	}
}
