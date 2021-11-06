package ecs;

import common.util.BitUtil;
import core.Game;

typedef QueryFilter =
{
	var ?all:Array<Class<Component>>;
	var ?any:Array<Class<Component>>;
	var ?none:Array<Class<Component>>;
}

class Query
{
	public var registry(get, null):Registry;
	public var size(default, null):Int;

	var any:Int;
	var all:Int;
	var none:Int;

	var filter:QueryFilter;
	var cache:Map<String, Entity>;
	var onAddListeners:Array<(Entity) -> Void>;
	var onRemoveListeners:Array<(Entity) -> Void>;

	inline function get_registry():Registry
	{
		return Game.instance.registry;
	}

	public function new(filter:QueryFilter)
	{
		this.filter = filter;
		onAddListeners = new Array();
		onRemoveListeners = new Array();
		cache = new Map();
		size = 0;

		if (filter.any != null)
		{
			any = Lambda.fold(filter.any, function(c, s)
			{
				return BitUtil.addBit(s, registry.getBit(c));
			}, 0);
		}
		else
		{
			any = 0;
		}

		if (filter.all != null)
		{
			all = Lambda.fold(filter.all, function(c, s)
			{
				return BitUtil.addBit(s, registry.getBit(c));
			}, 0);
		}
		else
		{
			all = 0;
		}

		if (filter.none != null)
		{
			none = Lambda.fold(filter.none, function(c, s)
			{
				return BitUtil.addBit(s, registry.getBit(c));
			}, 0);
		}
		else
		{
			none = 0;
		}

		registry.registerQuery(this);
		refresh();
	}

	public function matches(entity:Entity)
	{
		var bits = entity.cbits;

		var matchesAny = any == 0 || BitUtil.intersection(bits, any) > 0;
		var matchesAll = BitUtil.intersection(bits, all) == all;
		var matchesNone = BitUtil.intersection(bits, none) == 0;

		return matchesAny && matchesAll && matchesNone;
	}

	public function candidate(entity:Entity)
	{
		var isTracking = cache.exists(entity.id);

		if (matches(entity))
		{
			if (!isTracking)
			{
				size++;
				cache.set(entity.id, entity);
				for (listener in onAddListeners)
				{
					listener(entity);
				}
			}

			return true;
		}

		if (isTracking)
		{
			size--;
			cache.remove(entity.id);
			for (listener in onRemoveListeners)
			{
				listener(entity);
			}
		}

		return false;
	}

	public function refresh()
	{
		size = 0;
		cache.clear();
		for (entity in registry)
		{
			candidate(entity);
		}
	}

	public function iterator()
	{
		return cache.iterator();
	}

	public function onEntityAdded(fn:(Entity) -> Void)
	{
		onAddListeners.push(fn);
	}

	public function onEntityRemoved(fn:(Entity) -> Void)
	{
		onRemoveListeners.push(fn);
	}
}
