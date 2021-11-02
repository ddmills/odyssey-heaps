package domain;

class Registry
{
	var cbit:Int;
	var bits:Map<String, Int>;

	public function new()
	{
		cbit = 0;
		bits = new Map();
	}

	public function register<T:Component>(type:Class<Component>):Bool
	{
		var className = Type.getClassName(type);
		if (bits.exists(className))
		{
			return false;
		}

		bits.set(className, ++cbit);

		return true;
	}

	public function getBit<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);

		return bits.get(className);
	}
}
