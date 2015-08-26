package;

import flixel.util.FlxSave;
import flixel.FlxSprite;

class Reg
{
	// // Assets
	// public static inline var PLAYER_SPRITESHEET = "assets/images/player_anim.png";
	// public static inline var ENEMY1_SPRITESHEET = "assets/images/enemy_anim.png";
	public static inline var SPRITESHEET = "assets/images/ld33_tilesheet.png";
	public static inline var PLAYER_SPRITESHEET = "assets/images/player_spritesheet.png";
	public static inline var TANK_SPRITESHEET = "assets/images/tank_spritesheet.png";
	public static inline var ARCHER_SPRITESHEET = "assets/images/archer_spritesheet.png";
	public static inline var GARGOYLE_SPRITESHEET = "assets/images/gargoyle_spritesheet.png";
	
	public static inline var SMASH_SPRITESHEET = "assets/images/tanksmash_spritesheet.png";
	public static inline var UNIT_GIBS_SPRITESHEET = "assets/images/unit_gibs_spritesheet.png";
	public static inline var RED_GIBS_SPRITESHEET = "assets/images/red_gibs_spritesheet.png";
	public static inline var DUST_SPRITESHEET = "assets/images/dust_spritesheet.png";
	public static inline var ARROW_SPRITE = "assets/images/arrow_sprite.png";
	public static inline var MOON_SPRITE = "assets/images/moon_sprite.png";
	public static inline var GIBS_SPRITESHEET = "assets/images/gibs.png";

	// Title screen
	public static inline var TITLE_BG = "assets/images/mainmenu_bg.png";
	public static inline var TITLE_BG2 = "assets/images/mainmenu_bg2.png";
	public static inline var TITLE_TEXT = "assets/images/title_text.png";
	public static inline var TITLE_SUBTITLE = "assets/images/madeforld33.png";
	
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
	public static var playerDamage:Int;

	// Unit Type
	public static inline var UNIT_HUMAN:Int = 0;
	public static inline var UNIT_MELEE:Int = 1;
	public static inline var UNIT_RANGED:Int = 2;
	public static inline var UNIT_TANK:Int = 3;
	public static inline var UNIT_FLYING:Int = 4;

	// Dust Effect Types
	public static inline var JUMP_DUST:String = "JUMP_DUST";
	public static inline var ATTACK_WOOSH:String = "ATTACK_WOOSH";

	// Levels
	public static inline var TEST:String = "assets/data/ld33_tileset.csv";
	public static inline var PLAIN2:String = "assets/data/plain2.csv";
	public static inline var LEVEL1:String = "assets/data/level1.csv";
	public static inline var LEVEL2:String = "assets/data/level2.csv";
	public static inline var LEVEL3:String = "assets/data/level3.csv";
	public static inline var LEVEL_INTRO:String = "assets/data/level_intro.csv";

	public static inline var LEVEL_1_TITLE:String = "I. The Cavern";
	public static inline var LEVEL_2_TITLE:String = "II. The Chasm";
	public static inline var LEVEL_3_TITLE:String = "III. The Hollow";
	public static inline var LEVEL_4_TITLE:String = "IV. The End";

	public static inline var DRAFT_1:String = "assets/data/alfonz1_draft.csv";
	public static inline var DRAFT_2:String = "assets/data/alfonz2_draft.csv";

	// Fonts
	public static inline var FONT:String = "assets/04b03.ttf";
	public static inline var ALAGARD:String = "assets/alagard.ttf";

	// Tilesheet Tile IDs
	public static inline var TILE_ID_PLAYER:Int = 108;
	public static inline var TILE_ID_TANK:Int = 109;
	public static inline var TILE_ID_ARCHER:Int = 110;
	public static inline var TILE_ID_GARGOYLE:Int = 111;

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

		// Player.loadGraphic(PLAYER_SPRITESHEET, true, 16,16);
		// Player.animation.add("idle", [0,1,2,3], 10);
		// Player.animation.add("run", [4,5,6,7,8,7,6,5], 18);
		// Player.animation.add("fall", [9,10,11], 13);
		// Player.animation.add("jump", [12,13,14], 13);
	}

	public static function getTankAnim(Player:FlxSprite){
		Player.loadGraphic(TANK_SPRITESHEET, true, 16,16);
		Player.animation.add("idle", [0,1,2], 6);
		Player.animation.add("run", [3,4,5,6,7], 8);
		Player.animation.add("fall", [15,16], 10);
		Player.animation.add("jump", [13,14], 10);
		Player.animation.add("attack", [8,8,8,9,10,11,12], 30, false);
	}

	public static function getArcherAnim(Player:FlxSprite){
		Player.loadGraphic(ARCHER_SPRITESHEET, true, 16,16);
		Player.animation.add("idle", [0,1,2,3], 10);
		Player.animation.add("run", [4,5,6,7,8], 10);
		Player.animation.add("fall", [9,10,11], 15);
		Player.animation.add("jump", [12,13,14], 10);
		Player.animation.add("aim_X", [15], 30, false);
		Player.animation.add("aim_Y", [16], 30, false);
	}

	public static function getGargoyleAnim(Player:FlxSprite){
		Player.loadGraphic(GARGOYLE_SPRITESHEET, true, 16,16);
		Player.animation.add("fall", [0], 10);
		Player.animation.add("fly", [2,3,2,0,1,], 10);
		Player.animation.add("grounded", [4,5,6], 3);
	}

	public static function getSignPostAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		Player.animation.add("postSwing", [37,38,39,38], 2);
	}	

	public static function getDustEffect(Sprite:FlxSprite){
		Sprite.loadGraphic(DUST_SPRITESHEET, true, 16,16);
		Sprite.animation.add("jumpDust", [0,1,2,3], 25, false);
	}

	public static function getSmashEffect(Sprite:FlxSprite){
		Sprite.loadGraphic(SMASH_SPRITESHEET, true, 32, 32);
		Sprite.animation.add("smashEffect", [9,9,0,1,2,3,4,5,6,7,8], 30, false);
	}

	public static function getLevelTitle():String{
		switch(level){
			case 0: return LEVEL_1_TITLE;
			case 1: return LEVEL_2_TITLE;
			case 2: return LEVEL_3_TITLE;
			case 3: return LEVEL_4_TITLE;
		}

		return "";
	}
}