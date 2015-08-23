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

        makeGraphic(6, 14, FlxColor.WHITE);

        speed = 400;

        acceleration.y = 200;
        acceleration.x = -100;
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public override function shoot(Pos:FlxPoint, Angle:Float):Void{
        super.reset(Pos.x - width / 2, Pos.y - height / 2);

        angle = Angle;
        angularVelocity = (angle > 0) ? 5 : -5;
        angularAcceleration = angularVelocity * 2;
        velocity = FlxVelocity.velocityFromAngle(angle - 90, speed);
    }
}