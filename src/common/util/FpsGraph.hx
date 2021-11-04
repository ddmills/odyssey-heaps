package common.util;

import core.Frame;

class FpsGraph
{
	var frames:Array<Float>;
	var frameCount:Int;
	var container:h2d.Flow;
	var width = 128;
	var height = 64;
	var chart:h2d.Graphics;

	public function new()
	{
		frames = new Array();
		chart = new h2d.Graphics();
		frameCount = 30;
	}

	public function attach(go:h2d.Object)
	{
		chart.x = 8;
		chart.y = 8;
		go.addChild(chart);
	}

	public function update(frame:Frame)
	{
		frames.push(frame.fps / 60);
		if (frames.length > frameCount)
		{
			frames.shift();
		}

		var black = 0x000000;
		var red = 0xff0000;
		var green = 0x4d6c3e;

		chart.clear();
		chart.beginFill(black, 0.6);
		chart.drawRect(0, 0, width, height);
		chart.endFill();

		var idx = 0;
		for (frame in frames)
		{
			var barWidth = width / frameCount;
			var barHeight = height * Math.min(1, frame);
			var left = idx * barWidth;
			var top = height - barHeight;
			var color = frame < .5 ? red : green;

			chart.beginFill(color, 0.6);
			chart.drawRect(left, top, barWidth, barHeight);
			chart.endFill();

			idx++;
		}
	}
}
