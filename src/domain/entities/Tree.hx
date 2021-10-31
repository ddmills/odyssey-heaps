package domain.entities;

class Tree extends Entity
{
	public function new(ob:h2d.Object)
	{
		super(ob);
		offsetY = game.TILE_H;
		name = 'Tree';
	}
}
