package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;

class EnemyArcher extends Enemy
{
    public function new(X:Float, Y:Float)
    {
        super(X,Y);
        
        hp = 1;
        facing = FlxObject.LEFT;

        Reg.getTankAnim(this);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function die():Void{
        super.die();
    }
}