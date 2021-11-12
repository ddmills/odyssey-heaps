package rand.names;

import data.Gender;
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
	public static function getName(seed:Int, gender:Gender)
	{
		switch gender
		{
			case MALE:
				return getMaleName(seed);
			case FEMALE:
				return getFemaleName(seed);
		}
	}

	public static function getMaleName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		var given = r.pick(SpanishData.maleGiven);
		var method = r.pick([GIVEN_LOCATIVE, GIVEN_PATRONYMIC, GIVEN_OTHER, GIVEN_PATRONYMIC_LOCATIVE]);

		switch method
		{
			case GIVEN_LOCATIVE:
				return given + ' ' + r.pick(SpanishData.locative);
			case GIVEN_PATRONYMIC:
				return given + ' ' + r.pick(SpanishData.patronymics);
			case GIVEN_OTHER:
				return given + ' ' + r.pick(SpanishData.other);
			case GIVEN_PATRONYMIC_LOCATIVE:
				return given + ' ' + r.pick(SpanishData.patronymics) + ' ' + r.pick(SpanishData.locative);
		}
	}

	public static function getFemaleName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		var given = r.pick(SpanishData.femaleGiven);
		var method = r.pick([GIVEN_LOCATIVE, GIVEN_PATRONYMIC, GIVEN_OTHER, GIVEN_PATRONYMIC_LOCATIVE]);

		switch method
		{
			case GIVEN_LOCATIVE:
				return given + ' ' + r.pick(SpanishData.locative);
			case GIVEN_PATRONYMIC:
				return given + ' ' + r.pick(SpanishData.patronymics);
			case GIVEN_OTHER:
				return given + ' ' + r.pick(SpanishData.other);
			case GIVEN_PATRONYMIC_LOCATIVE:
				return given + ' ' + r.pick(SpanishData.patronymics) + ' ' + r.pick(SpanishData.locative);
		}
	}

	public static function getSettlementName(seed:Int)
	{
		var r = Rand.create();
		r.init(seed);

		return r.pick(SpanishData.settlements);
	}
}
