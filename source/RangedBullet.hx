package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxVelocity;

class RangedBullet extends Bullet
{

    var speed:Float;

    public function new()
    {
        super();

        // makeGraphic(6, 14, FlxColor.WHITE);
        loadGraphic(Reg.ARROW_SPRITE);
        offset.set(0,6);
        height = 3;
        width = 10;

        speed = 400;

        acceleration.y = 200;
        drag.x = 10;
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    override public function shoot(Pos:FlxPoint, Angle:Float):Bullet{
        super.reset(Pos.x - width / 2, Pos.y - height / 2);

        angle = Angle;
        angularVelocity = (angle > 0) ? 5 : -5;
        angularAcceleration = angularVelocity * 2;
        velocity = FlxVelocity.velocityFromAngle(angle - 90, speed);

        return this;
    }

    override public function setSpeed(X:Float = null, Y:Float = null):Void{
    	velocity.x = (X != null) ? X : acceleration.x;
    	velocity.y = (Y != null) ? Y : acceleration.y;
    }
}