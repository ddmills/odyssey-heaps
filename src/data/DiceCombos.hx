package data;

import data.combos.DoubleSlash2Combo;
import data.combos.DoubleSlashCombo;
import data.combos.ShieldBashCombo;
import data.combos.SlashCombo;

class DiceCombos
{
	public static var SLASH = new SlashCombo();
	public static var SLASH_2 = new DoubleSlash2Combo();
	public static var DOUBLE_SLASH = new DoubleSlashCombo();
	public static var SHIELD_BASH = new ShieldBashCombo();

	public static var PLAYER = [SLASH, SLASH_2, DOUBLE_SLASH, SHIELD_BASH];
}
