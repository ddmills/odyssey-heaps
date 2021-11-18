package core;

class Frame
{
	/**
	 * The seconds since last frame
	 */
	public var dt(get, null):Float;

	/**
	 * The current number of frames per second
	 */
	public var fps(get, null):Float;

	/**
	 * Modifier that shows real FPS relative to desired FPS. This allows
	 * for the game to be frame-rate independate. Use this whenever moving
	 * objects on the screen.
	 *
	 * When tmod = 1, it means the game is running at the desired speed
	 * When tmod < 1, it means the game is running faster than desired
	 * When tmod > 1, it means the game is running slower than desired
	 */
	public var tmod(get, null):Float;

	/**
	 * The seconds since the game has been running
	 */
	public var elapsed(default, null):Float = 0;

	/**
	 * The number of frames since the game start
	 */
	public var tick(default, null):Int = 0;

	inline function get_fps()
	{
		return hxd.Timer.fps();
	}

	inline function get_tmod()
	{
		return hxd.Timer.tmod;
	}

	inline function get_dt()
	{
		return hxd.Timer.dt;
	}

	@:allow(core.Game)
	function new() {}

	@:allow(core.Game)
	function update()
	{
		tick++;
		elapsed += dt;
	}
}
