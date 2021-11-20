package domain.combat.dice;

import data.DieFace;
import domain.screens.CombatScreen.Crew;

class DiceCombo
{
	public var title(default, null):String;
	public var description(default, null):String;
	public var faces(default, null):Array<DieFace>;

	public function new(title:String, description:String, faces:Array<DieFace>)
	{
		this.title = title;
		this.description = description;
		this.faces = faces;
	}

	public function appliesTo(dice:Array<DieFace>):Bool
	{
		if (dice.length != faces.length)
		{
			return false;
		}

		var clone = faces.copy();

		for (die in dice)
		{
			if (!clone.contains(die))
			{
				return false;
			}
			clone.remove(die);
		}

		return true;
	}

	public function getTarget(crew:Array<Crew>)
	{
		return crew.find((c) -> c.isTarget);
	}

	public function apply(enemies:Array<Crew>, allies:Array<Crew>) {}
}
