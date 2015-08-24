package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxTypedGroup;

class Enemy extends Unit
{
    // Enemy stuff
    var hp:Int = 1;

    // Attack stuff
    var enemyBullets:FlxTypedGroup<Bullet>;
    var canAttack:Bool;
    var attackDelay:Float;

    var unitType:Int;

    // Physics stuff, default values
    var maxSpeedX:Int = 120;
    var maxSpeedY:Int = 220;
    public var movespeed:Float;

    var player:Player;

    public function new()
    {
        super(0,0);
        acceleration.y = UnitStats.DEFAULT_GRAVITY;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        maxVelocity.set(maxSpeedX, maxSpeedY);

        canAttack = true;
    }

    override public function update():Void
    {
        super.update();

        facing = (player.x > x) ? FlxObject.RIGHT : FlxObject.LEFT;
    }

    public function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player):Void{
        x = X;
        y = Y;

        enemyBullets = EnemyBullets;
        player = Player;
    }

    /*
     * Returns true if enemy died after taking damage
     */
    public function takeDamage(Damage:Int):Bool{
    	hp -= Damage;
		FlxSpriteUtil.flicker(this, 0.2, 0.02, true);
        FlxG.camera.shake(0.01,0.1);

        if(hp <= 0){
            die();
            return true;
        }

        return false;
    }

    public function die():Void{
        FlxG.camera.shake(0.015,0.2);
        PlayState.player.switchToUnit(unitType);
    	super.kill();
    }

    public function attack():Void{
        canAttack = false;
        new FlxTimer(attackDelay, enableAttack);
    }

    public function enableAttack(Timer:FlxTimer):Void{
        if(player.alive)
            canAttack = true;
    }

    public function getXDistanceFromPlayer():Float{
        return Math.abs(x - player.x);
    }

    public function getYDistanceFromPlayer():Float{
        return Math.abs(y - player.y);
    }

    public function isPlayerWithinRange(XRange:Float, YRange:Float):Bool{
        return (getXDistanceFromPlayer() < XRange && getYDistanceFromPlayer() < YRange);
    }
}