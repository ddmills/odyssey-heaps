package common.util;

import common.struct.IntPoint;

class Bresenham
{
	public static function getLine(x0:Int, y0:Int, x1:Int, y1:Int):Array<IntPoint>
	{
		var dx = (x1 - x0).abs();
		var dy = (y1 - y0).abs();
		var sx = x0 < x1 ? 1 : -1;
		var sy = y0 < y1 ? 1 : -1;
		var result = new Array<IntPoint>();

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

	public static function getCircle(x0:Int, y0:Int, r:Int, fill:Bool = false):Array<IntPoint>
	{
		var pm = new Map<String, IntPoint>();
		var points = new Array<IntPoint>();
		var balance:Int = -r;
		var dx:Int = 0;
		var dy:Int = r;

		function addPoint(p:IntPoint)
		{
			var k = '${p.x},${p.y}';
			if (pm.get(k) == null)
			{
				points.push(p);
				pm.set(k, p);
			}
		}

		while (dx <= dy)
		{
			if (fill)
			{
				var p0 = x0 - dx;
				var p1 = x0 - dy;
				var w0 = dx + dx + 1;
				var w1 = dy + dy + 1;

				hline(p0, y0 + dy, w0, function(p)
				{
					addPoint(p);
				});
				hline(p0, y0 - dy, w0, function(p)
				{
					addPoint(p);
				});
				hline(p1, y0 + dx, w1, function(p)
				{
					addPoint(p);
				});
				hline(p1, y0 - dx, w1, function(p)
				{
					addPoint(p);
				});
			}
			else
			{
				addPoint({x: x0 + dx, y: y0 + dy});
				addPoint({x: x0 - dx, y: y0 + dy});
				addPoint({x: x0 - dx, y: y0 - dy});
				addPoint({x: x0 + dx, y: y0 - dy});
				addPoint({x: x0 + dy, y: y0 + dx});
				addPoint({x: x0 - dy, y: y0 + dx});
				addPoint({x: x0 - dy, y: y0 - dx});
				addPoint({x: x0 + dy, y: y0 - dx});
			}

			dx++;
			balance += dx + dx;

			if (balance >= 0)
			{
				dy--;
				balance -= dy + dy;
			}
		}

		return points;
	}

	private static function hline(x:Int, y:Int, w:Int, fn:(IntPoint) -> Void)
	{
		for (i in 0...w)
		{
			fn({
				x: x + i,
				y: y
			});
		}
	}
}
