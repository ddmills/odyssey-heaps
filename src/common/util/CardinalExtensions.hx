package common.util;

import common.struct.Cardinal;

class CardinalExtensions
{
	public static function toFrame(cardinal:Cardinal):Int
	{
		switch cardinal
		{
			case NORTH:
				return 0;
			case NORTH_EAST:
				return 1;
			case EAST:
				return 2;
			case SOUTH_EAST:
				return 3;
			case SOUTH:
				return 4;
			case SOUTH_WEST:
				return 5;
			case WEST:
				return 6;
			case NORTH_WEST:
				return 7;
		}
	}
}
