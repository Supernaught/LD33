package;

import flixel.util.FlxSave;
import flixel.FlxSprite;

class Reg
{
	// // Assets
	// public static inline var PLAYER_SPRITESHEET = "assets/images/player_anim.png";
	// public static inline var ENEMY1_SPRITESHEET = "assets/images/enemy_anim.png";
	public static inline var SPRITESHEET = "assets/images/ld33_tilesheet.png";
	public static inline var PLAYER_SPRITESHEET = "assets/images/player_sheet.png";
		public static inline var TANK_SPRITESHEET = "assets/images/tank_spritesheet.png";
	public static inline var DUST_SPRITESHEET = "assets/images/dust_sheet.png";
	
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
	public static inline var UNIT_HUMAN:Int = 0;
	public static inline var UNIT_MELEE:Int = 1;
	public static inline var UNIT_RANGED:Int = 2;
	public static inline var UNIT_TANK:Int = 3;

	// Dust Effect Types
	public static inline var JUMP_DUST:String = "JUMP_DUST";

	// Levels
	public static inline var TEST:String = "assets/data/ld33_tileset.csv";
	public static inline var PLAIN2:String = "assets/data/plain2.csv";

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(PLAYER_SPRITESHEET, true, 16,16);
		Player.animation.add("idle", [0,1,2,3], 10);
		Player.animation.add("run", [4,5,6,7,6,5,4], 18);
		Player.animation.add("fall", [9,10,11], 13);
		Player.animation.add("jump", [12,13,14], 13);
		// Player.loadGraphic(TANK_SPRITESHEET, true, 16,16);
		// Player.animation.add("playerIdle", [0,1,2], 6);
		// Player.animation.add("playerRun", [3,4,5,6,7], 8);
		// Player.animation.add("playerFall", [15,16], 10);
		// Player.animation.add("playerJump", [13,14], 10);
		// Player.animation.add("playerAttack", [8,8,8,9,10,11,12], 15);
	}

	public static function getTankAnim(Player:FlxSprite){
		Player.loadGraphic(TANK_SPRITESHEET, true, 16,16);
		Player.animation.add("idle", [0,1,2], 6);
		Player.animation.add("run", [3,4,5,6,7], 8);
		Player.animation.add("fall", [15,16], 10);
		Player.animation.add("jump", [13,14], 10);
		Player.animation.add("attack", [8,8,8,9,10,11,12], 30, false);
	}

	public static function getSignPostAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		Player.animation.add("postSwing", [37,38,39,38], 2);
	}	

	public static function getDustEffect(Sprite:FlxSprite){
		Sprite.loadGraphic(DUST_SPRITESHEET, true, 16,16);
		Sprite.animation.add("jumpDust", [0,1,2,3], 20, false);
	}

}