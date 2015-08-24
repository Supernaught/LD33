package;

import flixel.util.FlxSave;
import flixel.FlxSprite;
import flixel.FlxG;

class Sounds
{
	public static function hit(){ FlxG.sound.play("hit"); }
	public static function hit2(){ FlxG.sound.play("hit2"); }
	public static function enemy_die(){ FlxG.sound.play("enemy_die"); }
	public static function player_die(){ FlxG.sound.play("player_die"); }
	public static function woosh(){ FlxG.sound.play("woosh"); }
	public static function jump(){ FlxG.sound.play("jump",0.3); }
	public static function ground(){ FlxG.sound.play("ground", 0.3); }
	public static function shoot(){ FlxG.sound.play("shoot"); }
}