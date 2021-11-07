package core;

import common.struct.Coordinate;
import domain.World;

class Screen
{
	public var game(get, null):Game;
	public var world(get, null):World;
	public var camera(get, null):Camera;

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return game.world;
	}

	inline function get_camera():Camera
	{
		return game.camera;
	}

	/**
	 * Called after the game successfully enters this screen.
	 * Use for resource setup.
	 */
	@:allow(core.ScreenManager)
	function onEnter() {}

	/**
	 * Called after the game leaves this screen.
	 * Use for resource cleanup.
	 */
	@:allow(core.ScreenManager)
	function onDestroy() {}

	/**
	 * Called when the game temporarily leaves this screen.
	 */
	@:allow(core.ScreenManager)
	function onSuspend() {}

	/**
	 * Called when the game resumes this screen. (opposite of suspend)
	 */
	@:allow(core.ScreenManager)
	function onResume() {}

	/**
	 * Called on every frame.
	 */
	@:allow(core.Game)
	function update(frame:Frame) {}

	/**
	 * Handle mouse click down
	 */
	@:allow(core.Camera)
	function onMouseDown(pos:Coordinate) {}

	/**
	 * Handle mouse click up
	 */
	@:allow(core.Camera)
	function onMouseUp(pos:Coordinate) {}
}
