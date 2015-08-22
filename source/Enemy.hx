package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite
{
    // Enemy stuff
    var hp:Int = 1;

    // Physics stuff, default values
    var maxSpeedX:Int = 120;
    var maxSpeedY:Int = 400;
    public var movespeed:Float;

    public function new(X:Float, Y:Float)
    {
        super(X,Y);
    }

    override public function update():Void
    {
        super.update();
    }

    /*
     * Returns true if enemy died after taking damage
     */
    public function takeDamage(Damage:Int):Bool{
    	hp -= Damage;
		FlxSpriteUtil.flicker(this, 0.2, 0.02, true);

    	if(hp <= 0){
    		die();
    		return true;
    	}

    	return false;
    }

    public function die():Void{
    	super.kill();
    }
}