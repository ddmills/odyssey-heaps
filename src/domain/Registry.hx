package domain;

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

	public function getEntity(entityId:String)
	{
		return entityMap.get(entityId);
	}

	public function getBit<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);

		return bits.get(className);
	}

	public function candidacy(entity:Entity)
	{
		for (query in queries)
		{
			query.candidate(entity);
		}
	}

	@:allow(domain.Query)
	function registerQuery(query:Query)
	{
		queries.push(query);
	}

	@:allow(domain.Entity)
	function registerEntity(entity:Entity)
	{
		size++;
		entityMap.set(entity.id, entity);
	}

	public function iterator()
	{
		return entityMap.iterator();
	}
}
