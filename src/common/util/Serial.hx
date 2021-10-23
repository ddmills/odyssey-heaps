package util;

import haxe.Serializer;
import haxe.Unserializer;

class Serial
{
	/**
	 * Serialize a value to a string
	 */
	public static function serialize(value:Dynamic):String
	{
		var ser = new Serializer();

		ser.serialize(value);

		return ser.toString();
	}

	/**
	 * Deserialize a string to a value of type T
	 */
	@:generic
	public static function deserialize<T>(serialized:String):T
	{
		var uns = new Unserializer(serialized);
		var value:T = uns.unserialize();

		return value;
	}
}
