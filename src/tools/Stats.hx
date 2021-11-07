package tools;

import common.util.Buffer;

class Stats
{
	public var ob(default, null):h2d.Object;

	var graphs:Map<String, MonitorGraph>;
	var buffers:Map<String, Buffer<Float>>;

	public function new()
	{
		buffers = new Map();
		graphs = new Map();
		ob = new h2d.Object();
	}

	public function update()
	{
		for (name => stat in buffers)
		{
			stat.push(Performance.percent(name));
			graphs.get(name).render();
		}
	}

	public function show(stat:String)
	{
		if (graphs.exists(stat))
		{
			return;
		}

		var buffer = new Buffer<Float>();
		var graph = new MonitorGraph(buffer, stat, '%');

		buffers.set(stat, buffer);
		graphs.set(stat, graph);

		var count = Lambda.count(graphs);
		graph.attach(ob, 8, (50 + 8) * (count - 1) + 8, 256, 50);
	}
}
