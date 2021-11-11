package ecs.components;

import common.struct.IntPoint;

class Path extends Component
{
	var instructions:Array<IntPoint>;
	var curIdx:Int;

	public var length(get, never):Int;
	public var remaining(get, never):Int;
	public var current(get, never):IntPoint;

	public function new(instructions:Array<IntPoint>)
	{
		this.instructions = instructions;
		curIdx = 0;
	}

	inline function get_length():Int
	{
		return instructions.length;
	}

	inline function get_current():IntPoint
	{
		return instructions[curIdx];
	}

	inline function get_remaining():Int
	{
		return (length - 1) - curIdx;
	}

	/**
	 * Advance the current node in the path
	**/
	public function next():IntPoint
	{
		curIdx++;
		return current;
	}

	public function hasNext():Bool
	{
		return remaining > 0;
	}
}
