package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;

class EnemyWalking extends Enemy
{
    public function new(X:Float, Y:Float)
    {
        super(X,Y);
        
        hp = 3;
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, FlxColor.MAGENTA);

        facing = (X < PlayState.level.level.width/2) ? FlxObject.RIGHT : FlxObject.LEFT;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
        
        movespeed = 1000;
        drag.x = movespeed;

        acceleration.x = (facing == FlxObject.RIGHT ) ? movespeed : -movespeed;
        acceleration.y = maxSpeedY * Reg.GRAVITY;
        
        maxSpeedX = 50;

        maxVelocity.set(maxSpeedX, maxSpeedY);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function die():Void{
        super.die();

        
    }
}