package ecs.components;

class Path extends Component
{
	var instructions:Array<{x:Int, y:Int}>;
	var curIdx:Int;

	public var length(get, never):Int;
	public var remaining(get, never):Int;
	public var current(get, never):{x:Int, y:Int};

	public function new(instructions:Array<{x:Int, y:Int}>)
	{
		this.instructions = instructions;
		curIdx = 0;
	}

	inline function get_length():Int
	{
		return instructions.length;
	}

	inline function get_current():{x:Int, y:Int}
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
	public function next():{x:Int, y:Int}
	{
		curIdx++;
		return current;
	}

	public function hasNext():Bool
	{
		return remaining > 0;
	}
}
