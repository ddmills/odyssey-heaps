package data;

import data.combos.ShieldBashCombo;
import data.combos.SimpleDamageCombo;
import data.combos.SimpleGroupDamageCombo;
import domain.combat.dice.DiceCombo;

class DiceCombos
{
	public static var SLASH = new SimpleDamageCombo('Slash', [ATK_SWORD], 1);
	public static var SLASH_2 = new SimpleDamageCombo('Slash', [ATK_SWORD, ATK_SWORD], 2);
	public static var SLASH_2_2 = new SimpleDamageCombo('Slash', [ATK_DBL_SWORD], 2);

	public static var SLASH_3 = new SimpleGroupDamageCombo('Flurry', [ATK_SWORD, ATK_SWORD, ATK_SWORD], 1);
	public static var SLASH_2_3 = new SimpleGroupDamageCombo('Flurry', [ATK_DBL_SWORD, ATK_SWORD], 1);

	public static var SLASH_4 = new SimpleGroupDamageCombo('Mad flurry', [ATK_SWORD, ATK_SWORD, ATK_SWORD, ATK_SWORD], 2);
	public static var SLASH_2_2_4 = new SimpleGroupDamageCombo('Mad flurry', [ATK_DBL_SWORD, ATK_SWORD, ATK_SWORD], 2);
	public static var SLASH_2_4 = new SimpleGroupDamageCombo('Mad flurry', [ATK_DBL_SWORD, ATK_DBL_SWORD], 2);

	public static var SHIELD_BASH = new ShieldBashCombo();

	public static var SQUID_LASH = new SimpleDamageCombo('Tentacle lash', [SQUID_TENTACLE], 1);
	public static var SQUID_WAVES = new SimpleGroupDamageCombo('Wave', [SQUID_TENTACLE, SQUID_WAVE], 1);

	public static var PLAYER:Array<DiceCombo> = [
		SLASH,
		SLASH_2,
		SLASH_3,
		SLASH_4,
		SLASH_2_2,
		SLASH_2_3,
		SLASH_2_4,
		SLASH_2_2_4,
		SHIELD_BASH
	];
	public static var SQUID:Array<DiceCombo> = [SQUID_LASH, SQUID_WAVES];
}
