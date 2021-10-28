package common.util;

class Bresenham
{
	public static function getLine(x0:Int, y0:Int, x1:Int, y1:Int):Array<{x:Int, y:Int}>
	{
		var dx = (x1 - x0).abs();
		var dy = (y1 - y0).abs();
		var sx = x0 < x1 ? 1 : -1;
		var sy = y0 < y1 ? 1 : -1;
		var result = new Array<{x:Int, y:Int}>();

		var err = dx - dy;
		while (true)
		{
			result.push({
				x: x0,
				y: y0,
			});

			if (x0 == x1 && y0 == y1)
			{
				break;
			}

			var e2 = 2 * err;

			if (e2 > -dy)
			{
				err -= dy;
				x0 += sx;
			}

			if (e2 < dx)
			{
				err += dx;
				y0 += sy;
			}
		}

		return result;
	}
}
