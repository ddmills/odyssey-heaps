package rand.portrait;

import data.Gender;
import data.portraits.Portrait;
import data.portraits.PortraitData;
import hxd.Rand;

class PortraitGenerator
{
	public static function getPortrait(seed:Int, gender:Gender)
	{
		var parts = gender == MALE ? PortraitData.PARTS_M : PortraitData.PARTS_F;

		var r = new Rand(seed);
		var base = r.pick(parts.BASE);
		var hair = r.pick(parts.HAIR);
		var eyes = r.pick(parts.EYES);
		var clothes = r.pick(parts.CLOTHES);
		var nose = r.pick(parts.NOSE);

		return new Portrait(base, hair, eyes, nose, clothes);
	}
}
