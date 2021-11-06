package ecs.components;

import common.struct.Coordinate;

enum Tween
{
	LINEAR;
	LERP;
}

class Move extends Component
{
	public var goal:Coordinate;
	public var tween:Tween;
	public var speed:Float;
	public var epsilon:Float;

	public function new(goal:Coordinate, speed:Float = 0.05, tween:Tween = LINEAR, epsilon:Float = .01)
	{
		this.goal = goal;
		this.tween = tween;
		this.speed = speed;
		this.epsilon = epsilon;
	}
}
