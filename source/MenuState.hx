package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var goingToNextLevel:Bool = false;

	var bg:FlxSprite;
	var bg2:FlxSprite;

	var dark_bg:FlxSprite;
	var dark_bg2:FlxSprite;

	var title:FlxSprite;
	var subtitle:FlxSprite;

	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = 0xff18122b;

		var speed:Float = 30;

		bg = new FlxSprite(0,0,Reg.TITLE_BG);
		bg.velocity.x = -speed;

		bg2 = new FlxSprite(0,0,Reg.TITLE_BG);
		bg2.x = bg.x + bg.width;
		bg2.velocity.x = -speed;

		dark_bg = new FlxSprite(0,0,Reg.TITLE_BG2);
		dark_bg.velocity.x = -speed/2;

		dark_bg2 = new FlxSprite(0,0,Reg.TITLE_BG2);
		dark_bg2.x = dark_bg.x + dark_bg.width;
		dark_bg2.velocity.x = -speed/2;


		title = new FlxSprite(0,0,Reg.TITLE_TEXT);
		subtitle = new FlxSprite(0,0,Reg.TITLE_SUBTITLE);

		title.setPosition(FlxG.width/2 - title.width/2, FlxG.height/2 - 60);
		subtitle.setPosition(FlxG.width/2 - subtitle.width/2, FlxG.height/2 + 90);

		var moon = new FlxSprite(FlxG.width/2, 20, Reg.MOON_SPRITE);

		add(moon);
		add(dark_bg);
		add(dark_bg2);
		add(bg);
		add(bg2);

		add(title);
		add(subtitle);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if(!goingToNextLevel && FlxG.keys.pressed.ANY){
			goingToNextLevel = true;
			FlxG.camera.flash(FlxColor.WHITE,1,fadeToLevel);
		}

		// Infinite scrolling
		if(bg.x + bg.width < 0) bg.x = bg2.x + bg2.width;
		if(bg2.x + bg2.width < 0) bg2.x = bg.x + bg.width;

		if(dark_bg.x + dark_bg.width < 0) dark_bg.x = dark_bg2.x + dark_bg2.width;
		if(dark_bg2.x + dark_bg2.width < 0) dark_bg2.x = dark_bg.x + dark_bg.width;
	}	

	public function fadeToLevel():Void{
		FlxG.camera.fade(FlxColor.BLACK,2,false,gotoLevel);
	}

	public function gotoLevel():Void{
		FlxG.switchState(new PlayState());
	}
}