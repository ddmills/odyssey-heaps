package core;

import domain.Entity;

class EntityManager
{
	var entities:Map<String, Entity>;

	public function new()
	{
		entities = new Map<String, Entity>();
	}

	public function register(entity:Entity)
	{
		entities.set(entity.id, entity);
	}

	public function get(id:String)
	{
		return entities.get(id);
	}

	public function remove(id:String)
	{
		return entities.remove(id);
	}
}
