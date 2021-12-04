package common.res;

import hxd.res.Resource;

class JsonResource extends Resource
{
	public inline function toJson<T:Dynamic>():T
	{
		return haxe.Json.parse(entry.getText());
	}

	public inline function getText():String
	{
		return entry.getText();
	}
}
