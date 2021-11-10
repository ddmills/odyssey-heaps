package common.util;

typedef Point =
{
	var x:Int;
	var y:Int;
}

class FloodFill
{
	/**
	 * Flood fill starting from `seed` location. Every point is checked
	 * against `fill`. The `fill` function needs to both check if the point
	 * should be filled (bool), and fill it in
	**/
	public static function flood(seed:Point, fill:(Point) -> Bool)
	{
		var queue = new Array<Point>();
		queue.push(seed);

		while (queue.length > 0)
		{
			var p = queue.shift();

			if (fill(p))
			{
				queue.push({x: p.x - 1, y: p.y});
				queue.push({x: p.x + 1, y: p.y});
				queue.push({x: p.x, y: p.y + 1});
				queue.push({x: p.x, y: p.y - 1});
			}
		}
	}
}
