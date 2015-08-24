package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;

class EnemyArcher extends Enemy
{
    var range:Int = 150;
    var aiming:Bool = false;
    var aimDuration:Float = 0.7;

    public function new()
    {
        super();
        
        hp = 1;
        facing = FlxObject.LEFT;

        unitType = Reg.UNIT_RANGED;
        Reg.getArcherAnim(this);
        animation.play("idle");

        attackDelay = 1.2;
        canAttack = true;
        width -= 4;
        offset.set(2,0);
    }

    override public function update():Void
    {
        super.update();

        if(isPlayerWithinRange(range,range/3)){
            if(!aiming && canAttack){
                aim();
            }
        }

        if(aiming){
            animation.play("aim_X");
        } else{
            animation.play("idle");
        }
    }

    override public function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player):Void{
        super.init(X,Y,EnemyBullets,Player);
    }

    override public function die():Void{
        super.die();
    }

    public function aim():Void{
        aiming = true;
        new FlxTimer(aimDuration, timedAttackCallback);
    }    

    public function timedAttackCallback(Timer:FlxTimer){
    	if(alive)
        	attack();
    }

    override public function attack():Void{
        aiming = false;

        var angle = (facing == FlxObject.LEFT) ? -90 : 90;           
        enemyBullets.recycle(RangedBullet).shoot(new FlxPoint(x,y+4), angle);

        super.attack();

        Sounds.woosh();
    }
}