package data;

enum abstract Keybinding(Int)
{
	var BACK = 27; // esc
	var MAP_SCREEN = 77; // m
	var CREW_SCREEN = 67; // c

	@:to
	public function toInt():Int
	{
		return this;
	}

	public function is(other:Int):Bool
	{
		return this == other;
	}
}
