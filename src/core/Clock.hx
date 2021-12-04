package core;

class Clock
{
	public var tick(default, null):Int;
	public var tickDelta(default, null):Int;
	public var turnDelta(default, null):Int;
	public var turn(get, never):Int;
	public var subTurn(get, never):Int;

	public function new()
	{
		tick = 0;
		tickDelta = 0;
		turnDelta = 0;
	}

	public function incrementTick(delta)
	{
		var prevTurn = turn;

		tickDelta += delta;
		tick += delta;

		turnDelta = turn - prevTurn;
	}

	inline function get_turn():Int
	{
		return (tick / 1000).floor();
	}

	inline function get_subTurn():Int
	{
		return (tick % 1000).floor();
	}

	public function clearDeltas()
	{
		tickDelta = 0;
		turnDelta = 0;
	}

	public function toString()
	{
		return '${turn}.${subTurn}';
	}
}
