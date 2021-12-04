package macros;

class ResourceMacros
{
	public static function Init()
	{
		#if macro
		hxd.res.Config.extensions.set('json', 'common.res.JsonResource');
		#end
	}
}
