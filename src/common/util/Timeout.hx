package common.util;

import core.Game;

class Timeout
{
	public var duration(default, null):Float;
	public var start(default, null):Float;
	public var isComplete(default, null):Bool;

	var now(get, never):Float;

	inline function get_now():Float
	{
		return Game.instance.frame.elapsed;
	}

	public function new(seconds:Float)
	{
		this.duration = seconds;
		start = now;
		isComplete = false;
	}

	public function reset()
	{
		start = now;
		isComplete = false;
	}

	public function stop()
	{
		isComplete = true;
	}

	public function update()
	{
		if (!isComplete && (now - start) > duration)
		{
			isComplete = true;
			onComplete();
		}
	}

	public dynamic function onComplete() {}
}
