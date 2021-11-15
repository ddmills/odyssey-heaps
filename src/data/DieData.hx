package data;

class Dice
{
	public static var SOLDIER_LVL_1 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_EMPTY, ATK_EMPTY, ATK_EMPTY, ATK_EMPTY]);
	public static var SOLDIER_LVL_2 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_DBL_SWORD, ATK_EMPTY]);
	public static var SOLDIER_LVL_3 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_DBL_SWORD, ATK_DBL_SWORD]);

	public static var OFFICER_LVL_1 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_EMPTY, ATK_EMPTY, ATK_EMPTY]);
	public static var OFFICER_LVL_2 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_BOMB, ATK_EMPTY]);
	public static var OFFICER_LVL_3 = new Die(DiceCategory.ATTACK, [ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_BOMB, ATK_BOMB, ATK_BOMB]);

	public static var COOK_LVL_1 = new Die(DiceCategory.DEFENSE, [DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_EMPTY, DEF_EMPTY, DEF_EMPTY]);
	public static var COOK_LVL_2 = new Die(DiceCategory.DEFENSE, [DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_HEAL, DEF_EMPTY]);
	public static var COOK_LVL_3 = new Die(DiceCategory.DEFENSE, [DEF_SHIELD, DEF_SHIELD, DEF_SHIELD, DEF_HEAL, DEF_HEAL, DEF_HEAL]);

	public static var SQUID = new Die(DiceCategory.SQUID, [
		SQUID_TENTACLE,
		SQUID_TENTACLE,
		SQUID_TENTACLE,
		SQUID_WAVE,
		SQUID_WAVE,
		SQUID_EMPTY
	]);
}
