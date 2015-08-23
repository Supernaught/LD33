package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Enemy extends Unit
{
    // Enemy stuff
    var hp:Int = 1;

    var unitType:Int;

    // Physics stuff, default values
    var maxSpeedX:Int = 120;
    var maxSpeedY:Int = 220;
    public var movespeed:Float;

    public function new(X:Float, Y:Float)
    {
        super(X,Y);
        acceleration.y = maxSpeedY * Reg.GRAVITY;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        maxVelocity.set(maxSpeedX, maxSpeedY);
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
        FlxG.camera.shake(0.01,0.2);
        PlayState.player.switchToUnit(unitType);
    	super.kill();
    }
}