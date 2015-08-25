package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxVelocity;

class BombBullet extends Bullet
{

    var speed:Float;

    public function new()
    {
        super();

        // makeGraphic(6, 14, FlxColor.WHITE);
        loadGraphic("assets/images/rock.png");

        angularVelocity = 50;

        acceleration.y = 600;
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

        angle = 180;
        // angularAcceleration = angularVelocity * 2;
        // velocity = FlxVelocity.velocityFromAngle(angle - 90, speed);

        return this;
    }
}