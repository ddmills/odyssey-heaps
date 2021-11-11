package domain;

import domain.terrain.TerrainType;

class MapTile
{
	public var idx(default, null):Int;
	public var map(default, null):MapData;
	public var height:Float;
	public var terrain:TerrainType;
	public var islandId:Int;
	public var settlementId:Int;

	public var island(get, never):IslandData;
	public var hasIsland(get, never):Bool;
	public var settlement(get, never):SettlementData;
	public var hasSettlement(get, never):Bool;
	public var isWater(get, never):Bool;

	public var x(get, never):Int;
	public var y(get, never):Int;

	public function new(idx:Int, map:MapData)
	{
		this.idx = idx;
		this.map = map;
		islandId = -1;
		settlementId = -1;
	}

	inline function get_x():Int
	{
		return map.data.x(idx);
	}

	inline function get_y():Int
	{
		return map.data.y(idx);
	}

	function get_island():IslandData
	{
		if (islandId == -1)
		{
			return null;
		}

		return map.islands[islandId];
	}

	function get_settlement():SettlementData
	{
		if (settlementId == -1)
		{
			return null;
		}

		return map.settlements[settlementId];
	}

	function get_hasIsland():Bool
	{
		return islandId != -1;
	}

	function get_hasSettlement():Bool
	{
		return settlementId != -1;
	}

	function get_isWater():Bool
	{
		return terrain == WATER || terrain == SHALLOWS;
	}
}
