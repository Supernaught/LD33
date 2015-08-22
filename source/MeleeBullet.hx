package;

import flixel.FlxSprite;
import flixel.FlxG;
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

        makeGraphic(Reg.T_WIDTH + 4, Reg.T_HEIGHT, FlxColor.WHITE);
    }

    override public function update():Void
    {
        super.update();
        new FlxTimer(0.05, destroyBullet, 1);
    }

    private function destroyBullet(Timer:FlxTimer):Void{
        kill();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public override function shoot(Pos:FlxPoint, Angle:Float):Void{
        super.reset(Pos.x - width / 2, Pos.y - height / 2);
    }
}