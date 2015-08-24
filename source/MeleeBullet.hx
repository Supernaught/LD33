package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxVelocity;

class MeleeBullet extends Bullet
{
    var speed:Float;

    public function new()
    {
        super();

        new FlxTimer(0.05, destroyBullet, 1);

        makeGraphic(24,30, 0x00000000);

		setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        super.update();
    }

    private function destroyBullet(Timer:FlxTimer):Void{
        kill();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public override function shoot(Pos:FlxPoint, Angle:Float):Bullet{
        super.reset(Pos.x - width/2, Pos.y);

        return this;
    }
}