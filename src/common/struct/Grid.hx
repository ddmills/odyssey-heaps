package common.struct;

@:generic class Grid<T>
{
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var size(get, null):Int;

	private var data:Array<T>;

	function get_size()
	{
		return height * width;
	}

	public function new(width:Int = 128, height:Int = 128)
	{
		this.width = width;
		this.height = height;

		data = new Array();
	}

	public inline function idx(x:Int, y:Int)
	{
		return y * width + x;
	}

	public inline function x(idx:Int)
	{
		return Math.floor(idx % width);
	}

	public inline function y(idx:Int)
	{
		return Math.floor(idx / width);
	}

	public function coord(idx:Int):IntPoint
	{
		return {
			x: x(idx),
			y: y(idx),
		};
	}

	public inline function getAt(idx:Int):T
	{
		return data[idx];
	}

	public function get(x:Int, y:Int):T
	{
		if (isOutOfBounds(x, y))
		{
			return null;
		}

		var idx = idx(x, y);

		return data[idx];
	}

	public function set(x:Int, y:Int, value:T)
	{
		if (isOutOfBounds(x, y))
		{
			throw 'Trying to set out-of-bounds grid coordinates (${x}, ${y}) to value ${value}';
		}

		var idx = idx(x, y);

		data[idx] = value;
	}

	public function setIdx(idx:Int, value:T)
	{
		if (isIdxOutOfBounds(idx))
		{
			throw 'Trying to set out-of-bounds grid index (${idx}) to value ${value}';
		}

		data[idx] = value;
	}

	public function fill(value:T)
	{
		data = [for (_ in 0...size) value];
	}

	public function fillFn(fn:(Int) -> T)
	{
		data = [for (idx in 0...size) fn(idx)];
	}

	public function clear()
	{
		data = new Array();
	}

	public inline function isIdxOutOfBounds(idx:Int)
	{
		return idx > size || idx < 0;
	}

	public inline function isOutOfBounds(x:Int, y:Int)
	{
		return isXOutOfBounds(x) || isYOutOfBounds(y);
	}

	public inline function isXOutOfBounds(x:Int)
	{
		return x < 0 || x >= width;
	}

	public inline function isYOutOfBounds(y:Int)
	{
		return y < 0 || y >= height;
	}

	public function getNeighbors(x:Int, y:Int)
	{
		return [
			get(x - 1, y - 1), // TOP LEFT
			get(x, y - 1), // TOP
			get(x + 1, y - 1), // TOP RIGHT
			get(x - 1, y), // LEFT
			get(x + 1, y), // RIGHT
			get(x - 1, y + 1), // BOTTOM LEFT
			get(x, y + 1), // BOTTOM
			get(x + 1, y + 1), // BOTTOM RIGHT
		];
	}

	public function getImmediateNeighbors(x:Int, y:Int)
	{
		return [
			get(x, y - 1), // TOP
			get(x - 1, y), // LEFT
			get(x + 1, y), // RIGHT
			get(x, y + 1), // BOTTOM
		];
	}

	public function as2DArray()
	{
		var arr = new Array<Array<T>>();
		for (x in 0...width)
		{
			{
				var row = new Array<T>();

				for (y in 0...height)
				{
					var val = get(x, y);
					row.push(val);
				}

				arr.push(row);
			}
		}

		return arr;
	}

	public function iterator()
	{
		return new GridIterator(this);
	}
}

typedef GridItem<T> =
{
	idx:Int,
	x:Int,
	y:Int,
	value:T,
};

@:generic
class GridIterator<T>
{
	var grid:Grid<T>;
	var i:Int;

	public inline function new(grid:Grid<T>)
	{
		this.grid = grid;
		i = 0;
	}

	public inline function hasNext()
	{
		return i < grid.size;
	}

	public inline function next():GridItem<T>
	{
		var idx = i;
		var t = grid.getAt(i);
		var pos = grid.coord(i);
		i++;
		return {
			idx: idx,
			x: pos.x,
			y: pos.y,
			value: t,
		};
	}
}
