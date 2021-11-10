package rand.names;

import data.SpanishData;
import hxd.Rand;

enum GenMethod
{
	GIVEN_LOCATIVE;
	GIVEN_PATRONYMIC;
	GIVEN_OTHER;
	GIVEN_PATRONYMIC_LOCATIVE;
}

class SpanishNameGenerator
{
	static function pick<T>(r:Rand, array:Array<T>):T
	{
		return array[r.random(array.length)];
	}

	public static function getMaleName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		var given = pick(r, SpanishData.maleGiven);
		var method = pick(r, [GIVEN_LOCATIVE, GIVEN_PATRONYMIC, GIVEN_OTHER, GIVEN_PATRONYMIC_LOCATIVE]);

		switch method
		{
			case GIVEN_LOCATIVE:
				return given + ' ' + pick(r, SpanishData.locative);
			case GIVEN_PATRONYMIC:
				return given + ' ' + pick(r, SpanishData.patronymics);
			case GIVEN_OTHER:
				return given + ' ' + pick(r, SpanishData.other);
			case GIVEN_PATRONYMIC_LOCATIVE:
				return given + ' ' + pick(r, SpanishData.patronymics) + ' ' + pick(r, SpanishData.locative);
		}
	}

	public static function getFemaleName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		var given = pick(r, SpanishData.femaleGiven);
		var method = pick(r, [GIVEN_LOCATIVE, GIVEN_PATRONYMIC, GIVEN_OTHER, GIVEN_PATRONYMIC_LOCATIVE]);

		switch method
		{
			case GIVEN_LOCATIVE:
				return given + ' ' + pick(r, SpanishData.locative);
			case GIVEN_PATRONYMIC:
				return given + ' ' + pick(r, SpanishData.patronymics);
			case GIVEN_OTHER:
				return given + ' ' + pick(r, SpanishData.other);
			case GIVEN_PATRONYMIC_LOCATIVE:
				return given + ' ' + pick(r, SpanishData.patronymics) + ' ' + pick(r, SpanishData.locative);
		}
	}

	public static function getSettlementName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		return pick(r, SpanishData.settlements);
	}
}
