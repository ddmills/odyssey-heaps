package data;

import data.combos.DoubleSlash2Combo;
import data.combos.DoubleSlashCombo;
import data.combos.ShieldBashCombo;
import data.combos.SlashCombo;
import data.combos.SquidTentacleCombo;
import data.combos.SquidWaveCombo;
import domain.combat.dice.DiceCombo;

class DiceCombos
{
	public static var SLASH = new SlashCombo();
	public static var SLASH_2 = new DoubleSlash2Combo();
	public static var DOUBLE_SLASH = new DoubleSlashCombo();
	public static var SHIELD_BASH = new ShieldBashCombo();

	public static var SQUID_TENTACLE = new SquidTentacleCombo();
	public static var SQUID_WAVE = new SquidWaveCombo();

	public static var PLAYER:Array<DiceCombo> = [SLASH, SLASH_2, DOUBLE_SLASH, SHIELD_BASH];
	public static var SQUID:Array<DiceCombo> = [SQUID_TENTACLE, SQUID_WAVE];
}
