package tools;

using common.util.Buffer;

typedef FrameSnapshot =
{
	var total:Float;
	var meters:Map<String, Float>;
};

class Performance
{
	public static var snapshots:Buffer<FrameSnapshot> = new Buffer<FrameSnapshot>();
	static var meters:Map<String, Meter> = new Map();

	static function getOrCreateMeter(name:String)
	{
		var existing = meters.get(name);

		if (existing == null)
		{
			var meter = new Meter(name);

			meters.set(name, meter);

			return meter;
		}

		return existing;
	}

	public static function start(name:String)
	{
		var meter = getOrCreateMeter(name);
		meter.start();
	}

	public static function stop(name:String)
	{
		var meter = getOrCreateMeter(name);
		meter.stop();
	}

	public static function get(name:String)
	{
		return getOrCreateMeter(name);
	}

	public static function percent(name:String)
	{
		var snapshot = snapshots.peak();
		return snapshot.meters.get(name);
	}

	public static function update(dt:Float)
	{
		var percentages = new Map<String, Float>();

		for (name => meter in meters)
		{
			percentages.set(name, meter.latest / dt);
		}

		snapshots.push({
			total: dt,
			meters: percentages
		});
	}
}
