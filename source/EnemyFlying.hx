package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.group.FlxTypedGroup;

class EnemyFlying extends Enemy
{
    private var HOVER_FORCE:Float;
    private var X_WALK_DISTANCE:Float;

    public function new()
    {
        super();
        
        hp = 1;
        facing = FlxObject.LEFT;

        unitType = Reg.UNIT_RANGED;
        // Reg.getArcherAnim(this);
        // animation.play("idle");

        unitType = Reg.UNIT_FLYING;

        attackDelay = 2;
        acceleration.y = UnitStats.FLY_GRAVITY;

        HOVER_FORCE = acceleration.y / 2;

        new FlxTimer(1,hover);

        Reg.getGargoyleAnim(this);
        animation.play("fly");
    }

    override public function update():Void
    {
        super.update();

        if(getXDistanceFromPlayer() < 10 && y < player.y){
            if(canAttack)
                attack();
        }
    }

    override public function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player):Void{
        super.init(X,Y,EnemyBullets,Player);
    }

    override public function die():Void{
        super.die();
    }

    override public function attack():Void{
        enemyBullets.recycle(BombBullet).shoot(new FlxPoint(getGraphicMidpoint().x, y), 180);
        super.attack();
    }

    public function hover(Timer:FlxTimer):Void{
        velocity.y = -HOVER_FORCE;
        new FlxTimer(1,hover);
    }
}