package tools;

import common.util.Buffer;

class Stats
{
	var ob:h2d.Object;
	var graphs:Map<String, MonitorGraph>;
	var buffers:Map<String, Buffer<Float>>;

	public function new()
	{
		buffers = new Map();
		graphs = new Map();
	}

	public function attach(ob:h2d.Object)
	{
		this.ob = ob;
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
		var buffer = new Buffer<Float>();
		var graph = new MonitorGraph(buffer, stat, '%');

		buffers.set(stat, buffer);
		graphs.set(stat, graph);

		var count = Lambda.count(graphs);
		graph.attach(ob, 8, (50 + 8) * (count - 1) + 8, 256, 50);
	}
}
