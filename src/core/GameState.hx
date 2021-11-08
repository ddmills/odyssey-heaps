package core;

import common.struct.Coordinate;
import domain.World;

/**
 * Only one game state can be active at a time
 */
@:keepSub
class GameState
{
	public var isDestroyed(default, null):Bool;
	public var isCreated(default, null):Bool;
	public var scene(default, null):h2d.Scene;
	public var game(default, null):Game;
	public var world(get, null):World;
	public var camera(get, null):Camera;

	inline function get_world():World
	{
		return game.world;
	}

	inline function get_camera():Camera
	{
		return game.camera;
	}

	@:allow(core.GameStateManager)
	private function _destroy()
	{
		isDestroyed = true;
		destroy();
	}

	@:allow(core.GameStateManager)
	private function _create()
	{
		game = Game.instance;
		scene = new h2d.Scene();
		game.app.setScene(scene, true);
		game.camera.onSceneChanged(scene);
		create();
		isCreated = true;
	}

	@:allow(core.Game)
	inline private function _update(frame:Frame)
	{
		update(frame);
	}

	/**
	 * Called after the game successfully switches to this state.
	 * Use for resource setup.
	 */
	function create() {}

	/**
	 * Called after the game switches away from this state.
	 * Use for resource cleanup.
	 */
	function destroy() {}

	/**
	 * Called on every frame.
	 */
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

	/**
	 * Handle key up
	 */
	@:allow(core.Camera)
	function onKeyUp(keyCode:Int) {}
}
