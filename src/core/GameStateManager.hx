package core;

import h2d.Scene;

class GameStateManager
{
	public var current(default, null):GameState;
	public var scene(get, null):h2d.Scene;

	private var next:GameState;

	public function new() {}

	public function setState(next:GameState)
	{
		if (next.isDestroyed || next.isCreated)
		{
			throw 'Cannot set game state to old state';
		}

		this.next = next;

		if (current != null)
		{
			current._destroy();
		}

		next._create();

		current = this.next;
	}

	inline function get_scene():h2d.Scene
	{
		return current.scene;
	}
}
