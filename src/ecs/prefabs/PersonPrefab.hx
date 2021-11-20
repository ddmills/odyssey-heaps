package ecs.prefabs;

import data.Gender;
import data.Professions;
import ecs.components.Health;
import ecs.components.Level;
import ecs.components.Nationality;
import ecs.components.Person;
import ecs.components.Profession;
import hxd.Rand;
import rand.names.SpanishNameGenerator;

class PersonPrefab
{
	public static function Create(seed:Int)
	{
		var r = new hxd.Rand(seed);
		var gender:Gender = r.pick([MALE, FEMALE]);
		var name = SpanishNameGenerator.getName(seed, gender);
		var level = r.pick([1, 2, 3]);
		var prof = r.pick([Professions.SOLDIER, Professions.COOK, Professions.OFFICER]);

		var e = new Entity();
		e.add(new Person(name, gender, seed));
		e.add(new Nationality(SPANISH));
		e.add(new Level(level));
		e.add(new Profession(prof));
		e.add(new Health(5 + level, 5 + level));

		return e;
	}
}
