package tools;

import common.util.Buffer;
import data.TextResource;

class MonitorGraph
{
	var buffer:Buffer<Float>;
	var container:h2d.Flow;
	var width = 128;
	var height = 64;
	var chart:h2d.Graphics;
	var text:h2d.Text;
	var label:String;
	var unit:String;

	public function new(buffer:Buffer<Float>, label:String = '', unit:String = '')
	{
		this.buffer = buffer;
		this.label = label;
		this.unit = unit;
		text = TextResource.MakeText();
		text.x = 4;
		text.y = 2;
		chart = new h2d.Graphics();
	}

	public function attach(go:h2d.Object, x:Int, y:Int, w:Int, h:Int)
	{
		width = w;
		height = h;
		chart.x = x;
		chart.y = y;
		chart.addChild(text);
		go.addChild(chart);
	}

	public function render()
	{
		var black = 0x000000;
		var red = 0xff0000;
		var green = 0x4d6c3e;

		chart.clear();
		chart.beginFill(black, 0.6);
		chart.drawRect(0, 0, width, height);
		chart.endFill();

		var idx = 0;
		for (frame in buffer)
		{
			var barWidth = width / buffer.size;
			var barHeight = height * Math.min(1, frame);
			var left = idx * barWidth;
			var top = height - barHeight;
			var color = frame < .5 ? red : green;

			chart.beginFill(color, 0.6);
			chart.drawRect(left, top, barWidth, barHeight);
			chart.endFill();

			idx++;
		}

		var value = buffer.peek();
		var percent = (value * 100).round();
		text.text = '${label} ${percent}${unit}';
	}
}
