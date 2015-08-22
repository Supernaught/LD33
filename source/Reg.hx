package;

import flixel.util.FlxSave;
import flixel.FlxSprite;

class Reg
{
	// // Assets
	// public static inline var PLAYER_SPRITESHEET = "assets/images/player_anim.png";
	// public static inline var ENEMY1_SPRITESHEET = "assets/images/enemy_anim.png";
	public static inline var SPRITESHEET = "assets/images/ld33_tilesheet.png";
	// Physics
	public static inline var GRAVITY = 2.4;

	// Tile Size
	public static var T_WIDTH:Int = 16;
	public static var T_HEIGHT:Int = 16;

	// Misc
	public static var levels:Array<Dynamic> = [];
	public static var level:Int = 0;
	public static var scores:Array<Dynamic> = [];
	public static var score:Int = 0;
	public static var saves:Array<FlxSave> = [];

	// Unit Type
	public static inline var HUMAN:Int = 0;
	public static inline var ENEMY_1:Int = 1;
	public static inline var ENEMY_2:Int = 2;
	public static inline var ENEMY_3:Int = 3;

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		Player.animation.add("playerIdle", [40,41,42,43,43], 10);
		Player.animation.add("playerRun", [45,46,47,48,47,46,45,44], 18);
		Player.animation.add("playerFall", [49,50,51], 13);
		Player.animation.add("playerJump", [52,53,54], 13);
	}

	public static function getSignPostAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		Player.animation.add("postSwing", [37,38,39,38], 2);
	}
}