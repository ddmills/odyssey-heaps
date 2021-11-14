package data;

class DiceSets
{
	public static var ATTACK = new DiceSet(DiceCategory.ATTACK, [
		[[ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_EMPTY, ATK_EMPTY, ATK_EMPTY]],
		[[ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_BOMB, ATK_EMPTY]],
		[
			[ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_BOMB],
			[ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_EMPTY, ATK_EMPTY, ATK_EMPTY]
		]
	], 100);

	public static var DEFENSE = new DiceSet(DiceCategory.DEFENSE, [
		[[DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_EMPTY, DEF_EMPTY, DEF_EMPTY]],
		[[DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_HEAL, DEF_EMPTY]],
		[
			[DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_HEAL],
			[DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_EMPTY, DEF_EMPTY]
		]
	], 101);

	public static var ODD = new DiceSet(DiceCategory.ODD, [
		[[ODD_SKULL, ODD_SKULL, ODD_BLOOD, ODD_EMPTY, ODD_EMPTY, ODD_EMPTY]],
		[[ODD_SKULL, ODD_SKULL, ODD_SKULL, ODD_BLOOD, ODD_BLOOD, ODD_EMPTY]],
		[
			[ODD_SKULL, ODD_SKULL, ODD_SKULL, ODD_SKULL, ODD_BLOOD, ODD_BLOOD],
			[ODD_SKULL, ODD_SKULL, ODD_SKULL, ODD_BLOOD, ODD_EMPTY, ODD_EMPTY]
		]
	], 102);
}