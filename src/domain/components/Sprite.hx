package domain.components;

class Sprite extends Component
{
	public var ob(default, null):h2d.Object;
	public var offsetX(default, default):Float;
	public var offsetY(default, default):Float;

	public function new(ob:h2d.Object, offsetX = 0, offsetY = 0)
	{
		this.ob = ob;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	public function updatePos(px:Float, py:Float)
	{
		ob.x = px - offsetX;
		ob.y = py - offsetY;
	}
}
