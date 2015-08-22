package;

import flixel.util.FlxSave;
import flixel.FlxSprite;

class Reg
{
	// Assets
	public static inline var PLAYER_SPRITESHEET = "assets/images/player_anim.png";
	public static inline var ENEMY1_SPRITESHEET = "assets/images/enemy_anim.png";

	// Tile Size
	public static var T_WIDTH:Int = 16;
	public static var T_HEIGHT:Int = 16;

	// Misc
	public static var levels:Array<Dynamic> = [];
	public static var level:Int = 0;
	public static var scores:Array<Dynamic> = [];
	public static var score:Int = 0;
	public static var saves:Array<FlxSave> = [];

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(PLAYER_SPRITESHEET, true, 8);
		Player.animation.add("test", [1], 30);
	}
}