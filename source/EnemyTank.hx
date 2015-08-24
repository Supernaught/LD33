package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;

class EnemyTank extends EnemyWalking
{
    var detectRange:Float = 100;

    public function new()
    {
        super();
        
        hp = 2;
        facing = FlxObject.LEFT;

        Reg.getTankAnim(this);
        animation.play("idle");
        unitType = Reg.UNIT_TANK;
        
        width -= 4;
        offset.set(2,0);
    }

    override public function update():Void
    {
        if(getXDistanceFromPlayer() < detectRange){
            // acceleration.x = 
        }

        super.update();
    }

    override public function die():Void{
        super.die();
    }
}