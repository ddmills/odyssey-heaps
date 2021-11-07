package core.rendering;

import core.rendering.RenderLayer.RenderLayerSpace;
import h2d.Layers;

enum RenderLayerType
{
	GROUND;
	FOG;
	FOG_OVERLAY;
	OBJECTS;
	HUD;
}

class RenderLayerManager
{
	public var root(default, null):Layers;
	public var scroller(default, null):Layers;
	public var screen(default, null):Layers;

	var scrollerCount:Int = 0;
	var screenCount:Int = 0;

	var layers:Map<RenderLayerType, RenderLayer>;

	public function new()
	{
		layers = new Map();
		root = new Layers();
		scroller = new Layers();
		screen = new Layers();

		createLayer(GROUND, WORLD);
		createLayer(FOG, WORLD);
		createLayer(FOG_OVERLAY, WORLD);
		createLayer(OBJECTS, WORLD);
		createLayer(HUD, SCREEN);

		root.addChildAt(scroller, 0);
		root.addChildAt(screen, 1);
	}

	function createLayer(type:RenderLayerType, space:RenderLayerSpace):RenderLayer
	{
		var layer = new RenderLayer(space);

		switch layer.space
		{
			case WORLD:
				scroller.add(layer.ob, scrollerCount++);
			case SCREEN:
				screen.add(layer.ob, screenCount++);
		}

		layers.set(type, layer);

		return layer;
	}

	public function render(layer:RenderLayerType, ob:h2d.Object)
	{
		layers.get(layer).ob.addChild(ob);
	}

	public function sort(layer:RenderLayerType)
	{
		layers.get(layer).ob.ysort(0);
	}
}
