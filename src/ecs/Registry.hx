package ecs;

class Registry
{
	var cbit:Int;
	var bits:Map<String, Int>;
	var queries:Array<Query>;
	var entityMap:Map<String, Entity>;

	public var size(default, null):Int;

	public function new()
	{
		cbit = 0;
		size = 0;
		bits = new Map();
		entityMap = new Map();
		queries = new Array();
	}

	public function register<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);
		if (bits.exists(className))
		{
			return bits.get(className);
		}

		bits.set(className, ++cbit);

		return cbit;
	}

	public function getEntity(entityId:String)
	{
		return entityMap.get(entityId);
	}

	public function getBit<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);

		var bit = bits.get(className);

		if (bit == null)
		{
			return register(type);
		}

		return bit;
	}

	public function candidacy(entity:Entity)
	{
		for (query in queries)
		{
			query.candidate(entity);
		}
	}

	@:allow(ecs.Query)
	function registerQuery(query:Query)
	{
		queries.push(query);
	}

	@:allow(ecs.Query)
	function unregisterQuery(query:Query)
	{
		queries.remove(query);
	}

	@:allow(ecs.Entity)
	function registerEntity(entity:Entity)
	{
		size++;
		entityMap.set(entity.id, entity);
	}

	@:allow(ecs.Entity)
	function unregisterEntity(entity:Entity)
	{
		size--;
		entityMap.remove(entity.id);
	}

	public function iterator()
	{
		return entityMap.iterator();
	}
}
