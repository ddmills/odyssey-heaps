package common.struct;

@:enum
abstract Cardinal(Int)
{
	var NORTH = 0;
	var NORTH_EAST = 1;
	var EAST = 2;
	var SOUTH_EAST = 3;
	var SOUTH = 4;
	var SOUTH_WEST = 5;
	var WEST = 6;
	var NORTH_WEST = 7;

	public static function fromDegrees(degrees:Float):Cardinal
	{
		var val = (degrees / 45).floor();

		switch val
		{
			case 0:
				return NORTH;
			case 1:
				return NORTH_EAST;
			case 2:
				return EAST;
			case 3:
				return SOUTH_EAST;
			case 4:
				return SOUTH;
			case 5:
				return SOUTH_WEST;
			case 6:
				return WEST;
			case 7:
				return NORTH_WEST;
			case _:
				return WEST;
		}
	}
}
