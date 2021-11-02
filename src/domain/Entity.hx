package domain;

import common.struct.Coordinate;
import common.util.BitUtil;
import common.util.UniqueId;
import core.Game;
import domain.terrain.Chunk;

class Entity
{
	public var cbits(default, null):Int;

	var _x:Float;
	var _y:Float;

	public var world(get, null):World;
	public var game(get, null):Game;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var pos(get, set):Coordinate;
	public var chunk(get, null):Chunk;
	public var registry(get, null):Registry;
	public var id(default, null):String;
	public var ob(default, null):h2d.Object;
	public var offsetX(default, null):Float;
	public var offsetY(default, null):Float;

	private var components:Map<String, Component>;

	public function new(ob:h2d.Object)
	{
		this.ob = ob;
		offsetX = Game.instance.TILE_W_HALF;
		offsetY = 0;
		_x = 0;
		_y = 0;
		id = UniqueId.Create();
		cbits = 0;
		components = new Map();
		registry.registerEntity(this);
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	function set_x(newX:Float)
	{
		set_pos(new Coordinate(newX, _y, WORLD));
		return _x;
	}

	function set_y(newY:Float)
	{
		set_pos(new Coordinate(_x, newY, WORLD));
		return _y;
	}

	function get_chunk():Chunk
	{
		var idx = pos.toChunkIdx();

		return world.chunks.getChunkById(idx);
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var prevChunkIdx = pos.toChunkIdx();

		var p = value.toPx();
		var w = value.toWorld();

		ob.x = p.x - offsetX;
		ob.y = p.y - offsetY;

		_x = w.x;
		_y = w.y;

		var nextChunkIdx = pos.toChunkIdx();

		if (prevChunkIdx != nextChunkIdx)
		{
			var prevChunk = world.chunks.getChunkById(prevChunkIdx);
			if (prevChunk != null)
			{
				prevChunk.removeEntity(this);
			}
		}
		var nextChunk = world.chunks.getChunkById(nextChunkIdx);
		if (nextChunk != null)
		{
			nextChunk.setEntityPosition(this);
		}
		return w;
	}

	inline function get_pos():Coordinate
	{
		return new Coordinate(_x, _y, WORLD);
	}

	function get_x():Float
	{
		return _x;
	}

	function get_y():Float
	{
		return _y;
	}

	public function add(component:Component)
	{
		cbits = BitUtil.addBit(cbits, component.bit);
		components.set(component.type, component);
		registry.candidacy(this);
	}

	public function has<T:Component>(type:Class<Component>):Bool
	{
		return BitUtil.hasBit(cbits, registry.getBit(type));
	}

	public function remove(component:Component)
	{
		cbits = BitUtil.subtractBit(cbits, component.bit);
		components.remove(component.type);
		registry.candidacy(this);
	}

	public function get<T:Component>(type:Class<T>):T
	{
		var className = Type.getClassName(type);
		var component = components.get(className);

		if (component == null)
		{
			return null;
		}

		return cast component;
	}

	inline function get_registry():Registry
	{
		return Game.instance.registry;
	}
}
