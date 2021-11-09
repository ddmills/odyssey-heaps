package rand;

import common.struct.Grid;
import hxd.Math;

typedef Point =
{
	var x:Int;
	var y:Int;
}

class PoissonDiscSampler
{
	var width:Int;
	var height:Int;
	var radius:Int;

	var attempts:Int;
	var radius2:Int;
	var PI2:Float = 2 * Math.PI;
	var cellSize:Float;
	var grid:Grid<Point>;
	var results:Array<Point>;
	var active:Array<Point>;

	public function new(width:Int, height:Int, radius:Int)
	{
		this.width = width;
		this.height = height;
		this.radius = radius;

		// number of attempts before rejection
		attempts = 30;

		radius2 = radius * radius;

		cellSize = radius * Math.sqrt(.5);
		grid = new Grid<Point>(Math.ceil(width / cellSize), Math.ceil(height / cellSize));
		active = new Array<Point>();
		results = new Array<Point>();
	}

	function addSample(x:Int, y:Int):Point
	{
		var point = {
			x: x,
			y: y
		};
		results.push(point);
		active.push(point);
		var gx = (x / cellSize).floor();
		var gy = (y / cellSize).floor();
		grid.set(gx, gy, point);
		return point;
	}

	function candidate(x:Int, y:Int)
	{
		// check out of bounds
		if (x < 0 || x >= width || y < 0 || y >= height)
		{
			return false;
		}

		var gx = (x / cellSize).floor();
		var gy = (y / cellSize).floor();

		// check identity
		if (grid.get(gx, gy) != null)
		{
			return false;
		}

		// check close to neighbors
		for (neighbor in grid.getNeighbors(gx, gy))
		{
			if (neighbor != null)
			{
				var dx = neighbor.x - x;
				var dy = neighbor.y - y;
				if ((dx * dx + dy * dy) < radius2)
				{
					return false;
				}
			}
		}

		return true;
	}

	public function sample():Point
	{
		if (results.length == 0)
		{
			return addSample((Math.random() * width).floor(), (Math.random() * height).floor());
		}

		while (active.length > 0)
		{
			var i = Math.floor(Math.random() * active.length);
			var sample = active[i];

			for (attempt in 0...attempts)
			{
				var angle = PI2 * Math.random();
				var distance = radius + Math.floor(Math.random() * radius);
				var x = (sample.x + distance * Math.cos(angle)).floor();
				var y = (sample.y + distance * Math.sin(angle)).floor();

				if (candidate(x, y))
				{
					return addSample(x, y);
				}
			}

			active.splice(i, 1);
		}

		return null;
	}
}
