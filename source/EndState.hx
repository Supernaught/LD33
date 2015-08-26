package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class EndState extends FlxState
{
	var goingToNextLevel:Bool = false;

	var bg:FlxSprite;
	var bg2:FlxSprite;

	var dark_bg:FlxSprite;
	var dark_bg2:FlxSprite;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,1,true);
		FlxG.mouse.visible = false;

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

		var moon = new FlxSprite(FlxG.width/2, 20, Reg.MOON_SPRITE);

		add(moon);
		add(dark_bg);
		add(dark_bg2);
		add(bg);
		add(bg2);


		var myText = new FlxText(0, FlxG.height/2 - 40, FlxG.width); // x, y, width
		add(prettifyText(myText, Reg.LEVEL_4_TITLE, 16, Reg.ALAGARD));

		var alfonzText = new FlxText(-FlxG.width/4, FlxG.height/2 + 10, FlxG.width); // x, y, width
		add(prettifyText(alfonzText, "Alphonsus (@alphnsus)", 8, Reg.FONT));
		var alfonzText2 = new FlxText(-FlxG.width/4, FlxG.height/2 + 20, FlxG.width); // x, y, width
		add(prettifyText(alfonzText2, "Code", 8, Reg.FONT));

		var davyText = new FlxText(FlxG.width/4, FlxG.height/2 + 10, FlxG.width); // x, y, width
		add(prettifyText(davyText, "Dave (@momorgoth)", 8, Reg.FONT));
		var davyText2 = new FlxText(FlxG.width/4, FlxG.height/2 + 20, FlxG.width); // x, y, width
		add(prettifyText(davyText2, "Art", 8, Reg.FONT));

		var supernaughtText = new FlxText(0, FlxG.height/2 + 70, FlxG.width); // x, y, width
		add(prettifyText(supernaughtText, "A game by Supernaught (@_supernaught)", 8, Reg.FONT));
		var supernaughtText2 = new FlxText(0, FlxG.height/2 + 80, FlxG.width); // x, y, width
		add(prettifyText(supernaughtText2, "Made for Ludum Dare 33", 8, Reg.FONT));
	}

	private function prettifyText(Text:FlxText, TextString:String, Size:Int, Font:String):FlxText{
		Text.text = TextString;
		Text.scrollFactor.set(0,0);
		Text.setFormat(Font, Size, FlxColor.WHITE, "center");
		Text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxG.camera.bgColor, 1);
		Text.alpha = 0;

		FlxSpriteUtil.fadeIn(Text, 1, false);
		return Text;
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
		Reg.level = 0;
		FlxG.switchState(new MenuState());
	}
}