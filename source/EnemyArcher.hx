package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class EnemyArcher extends Enemy
{
    var range:Int = 150;

    public function new()
    {
        super();
        
        hp = 1;
        facing = FlxObject.LEFT;

        unitType = Reg.UNIT_RANGED;
        Reg.getArcherAnim(this);
        animation.play("idle");

        attackDelay = 1;
    }

    override public function update():Void
    {
        super.update();

        if(isPlayerWithinRange(range,range/3)){
            if(canAttack){
                attack();
            }

            facing = (player.x > x) ? FlxObject.RIGHT : FlxObject.LEFT;
        }
    }

    override public function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player):Void{
        super.init(X,Y,EnemyBullets,Player);
    }

    override public function die():Void{
        super.die();
    }

    override public function attack():Void{
        var angle = (facing == FlxObject.LEFT) ? -90 : 90;           
        enemyBullets.recycle(RangedBullet).shoot(new FlxPoint(x,y), angle);

        super.attack();
    }
}