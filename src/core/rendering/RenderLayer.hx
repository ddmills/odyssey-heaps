package core.rendering;

enum RenderLayerSpace
{
	SCREEN;
	WORLD;
}

class RenderLayer
{
	public var space(default, null):RenderLayerSpace;
	public var visible(get, set):Bool;
	public var ob(default, null):h2d.Layers;

	public function new(space:RenderLayerSpace)
	{
		this.space = space;
		ob = new h2d.Layers();

		visible = true;
	}

	inline function set_visible(value:Bool):Bool
	{
		return ob.visible = value;
	}

	inline function get_visible():Bool
	{
		return ob.visible;
	}
}
