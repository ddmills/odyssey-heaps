package common.util;

import haxe.Serializer;
import haxe.Unserializer;

class Serial
{
	/**
	 * Serialize a value to a string
	 */
	public static function Serialize(value:Dynamic):String
	{
		var ser = new Serializer();
		ser.useCache = true;

		ser.serialize(value);

		return ser.toString();
	}

	/**
	 * Deserialize a string to a value of type T
	 */
	public static function Deserialize<T>(serialized:String):T
	{
		var uns = new Unserializer(serialized);
		var value:T = uns.unserialize();

		return value;
	}
}
