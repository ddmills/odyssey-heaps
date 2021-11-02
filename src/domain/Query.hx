package domain;

import common.util.BitUtil;
import core.Game;
import domain.Component;

typedef QueryFilter =
{
	var all:Array<Class<Component>>;
	var any:Array<Class<Component>>;
	var none:Array<Class<Component>>;
}

class Query
{
	var fany:Int;
	var fall:Int;
	var fnone:Int;

	var filter:QueryFilter;
	var cache:Map<String, Entity>;

	public function new(filter:QueryFilter)
	{
		this.filter = filter;
		cache = new Map();

		fany = Lambda.fold(filter.any, function(c, s)
		{
			return BitUtil.addBit(s, Game.instance.registry.getBit(c));
		}, 0);

		fall = Lambda.fold(filter.all, function(c, s)
		{
			return BitUtil.addBit(s, Game.instance.registry.getBit(c));
		}, 0);

		fnone = Lambda.fold(filter.none, function(c, s)
		{
			return BitUtil.addBit(s, Game.instance.registry.getBit(c));
		}, 0);
	}

	public function matches(entity:Entity)
	{
		var bits = entity.cbits;

		var any = fany == 0 || BitUtil.intersection(bits, fany) > 0;
		var all = BitUtil.intersection(bits, fall) == fall;
		var none = BitUtil.intersection(bits, fnone) == 0;

		return any && all && none;
	}

	public function candidate(entity:Entity)
	{
		var isTracking = cache.exists(entity.id);

		if (!matches(entity))
		{
			if (!isTracking)
			{
				cache.set(entity.id, entity);
			}

			return true;
		}

		if (isTracking)
		{
			this.cache.remove(entity.id);
		}

		return false;
	}
}
