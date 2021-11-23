package domain.systems;

import common.struct.Coordinate;
import common.util.Bresenham;
import core.Frame;
import ecs.Query;
import ecs.components.Explored;
import ecs.components.Moved;
import ecs.components.Sprite;
import ecs.components.Visible;
import ecs.components.Vision;
import shaders.ShroudShader;

class VisionSystem extends System
{
	var visions:Query;
	var recompute:Bool;

	public function new()
	{
		// vision needs to be recomputed if any of the following happens:
		// - entity with Vision spawns
		// - entity with Vision moves
		// - entity with Vision removed

		var moved = new Query({
			all: [Moved, Vision]
		});

		visions = new Query({
			all: [Vision]
		});

		moved.onEntityAdded((entity) ->
		{
			recompute = true;
		});

		visions.onEntityAdded((entity) ->
		{
			recompute = true;
		});

		visions.onEntityRemoved((entity) ->
		{
			recompute = true;
		});

		var visibles = new Query({
			all: [Sprite],
			any: [Visible, Explored],
		});

		var shrouded = new Query({
			all: [Sprite, Explored],
			none: [Visible],
		});

		visibles.onEntityAdded((entity) ->
		{
			entity.get(Sprite).visible = true;
		});

		visibles.onEntityRemoved((entity) ->
		{
			entity.get(Sprite).visible = false;
		});

		var shroud = new ShroudShader(.16, .7);

		shrouded.onEntityAdded((entity) ->
		{
			var sprite = entity.get(Sprite);
			sprite.ob.addShader(shroud);
		});

		shrouded.onEntityRemoved((entity) ->
		{
			var sprite = entity.get(Sprite);
			sprite.ob.removeShader(shroud);
		});
	}

	function computeVision()
	{
		var visible = new Map<String, Coordinate>();

		for (entity in visions)
		{
			var vision = entity.get(Vision);
			var x = entity.x.floor();
			var y = entity.y.floor();

			if (vision.bonus > 0)
			{
				var exploreCircle = Bresenham.getCircle(x, y, vision.range + vision.bonus, true);
				for (point in exploreCircle)
				{
					world.explore(new Coordinate(point.x, point.y, WORLD));
				}
			}

			var visCircle = Bresenham.getCircle(x, y, vision.range, true);
			var vis = Coordinate.FromPoints(visCircle, WORLD);
			for (coord in vis)
			{
				visible.set(coord.toString(), coord);
			}
		}

		var tiles = visible.map((vis) -> vis);

		world.setVisible(tiles);
	}

	public override function update(frame:Frame)
	{
		if (recompute)
		{
			computeVision();
			recompute = false;
		}
	}
}
