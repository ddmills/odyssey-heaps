package util;

import haxe.Serializer;
import haxe.Unserializer;

class Serial
{
	public static function serialize(value:Dynamic):String
	{
		var ser = new Serializer();

		ser.serialize(value);

		return ser.toString();
	}

	@:generic
	public static function deserialize<T>(serialized:String):T
	{
		var uns = new Unserializer(serialized);
		var value:T = uns.unserialize();

		return value;
	}
}
