package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;

class Player extends Unit
{
    private static var ATTACK_COOLDOWN:Float = 0.1; // in milliseconds

    private var unitType:Int = Reg.HUMAN;

    // Physics stuff
    private var maxSpeedX:Int = 120;
    private var maxSpeedY:Int = 250;

    private var movespeed:Float = 10000; // used to set velocity when pressing move keys
    private var jumpForce:Float = 200;

    // Jump stuff
    private var canJump:Bool;

    // Attack stuff
    private var canAttack:Bool;
    private var attackDelay:Float = 0.1;
    private var attackDelayCounter:Float;

    private var bullets:FlxTypedGroup<Bullet>;
    
    private var MELEE_ATTACK_FRAMES:Int = 2; // used for melee attack hit "bullet"    
    private var meleeAttackFrameCounter:Int;
    private var isMeleeAttacking:Bool;

    // Components
    private var canAttackComponent:CanAttack;

    public function new(X:Int, Y:Int, Bullets:FlxTypedGroup<Bullet>)
    {
        super(X,Y);

        // components = new Array<Component>();
        // components.push(new CanAttack(this));

        // Animation sprites stuff
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, 0xffc71045);

        var yOffset = 2;
        var xOffset = 2;

        width -= xOffset;
        height -= yOffset;

        // offset.set(0,yOffset);

        // Attack stuff
        canAttack = false;
        bullets = Bullets;
        meleeAttackFrameCounter = 0;
        isMeleeAttacking = false;

        // Physics and movement stuff
        acceleration.y = maxSpeedY * Reg.GRAVITY;
        maxVelocity.set(maxSpeedX, maxSpeedY);
        drag.x = movespeed;

        // Jump stuff
        canJump = true;

        canAttackComponent = new CanAttack(this);

        // Animations
        Reg.getPlayerAnim(this);
        animation.play("playerIdle");

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        if(!canJump && isTouching(FlxObject.FLOOR)){
            canJump = true;
        }
        
        movementControls();
        attackControls();

        attackUpdate();

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function jump():Void
    {
        if(canJump){
            velocity.y = -jumpForce;
            canJump = false;
        }
    }

    public function movementControls():Void 
    {        
        if(FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT){
            acceleration.x = -drag.x;
            facing = FlxObject.LEFT;
        } else if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT){
            acceleration.x = drag.x;
            facing = FlxObject.RIGHT;
        } else {
            acceleration.x = 0;
        }

        if(FlxG.keys.pressed.W || FlxG.keys.pressed.Z){
            if(canJump){
                jump();
                animation.play("playerJump");
            }
            else {
                acceleration.y = maxSpeedY * Reg.GRAVITY/2;
            }
        } else {
            acceleration.y = maxSpeedY * Reg.GRAVITY;
        }

        if(velocity.y < 0){
            animation.play("playerJump");
        } else if(velocity.y > 0){
            animation.play("playerFall");
        } else{
            if(acceleration.x != 0)
                animation.play("playerRun");
            else
                animation.play("playerIdle");
        }
    }

    public function attackControls():Void
    {
        if(canAttack && (FlxG.mouse.justPressed || FlxG.keys.pressed.X))
        {
            attack();
        }
    }

    public function attackUpdate():Void
    {
        if(!canAttack){
            if(attackDelayCounter >= 0){
                attackDelayCounter -= FlxG.elapsed;
            } else {
                attackDelayCounter = attackDelay;
                canAttack = true;
            }
        }
        // if(isMeleeAttacking){
        //     trace("attacking");
        //     meleeAttackFrameCounter--;

        //     if(meleeAttackFrameCounter <= 0){
        //         isMeleeAttacking = false;
        //     }
        // }
    }

    public function attack():Void
    {
        canAttack = false;

        // Fire a bullet
        // if(unitType == Reg.HUMAN){
        //     var angle = (facing == FlxObject.LEFT) ? -90 : 90;           
        //     bullets.recycle(RangedBullet).shoot(new FlxPoint(x,y), angle);
        // }

        canAttackComponent.attack();

        // Attack melee
        isMeleeAttacking = true;
        meleeAttackFrameCounter = MELEE_ATTACK_FRAMES;
        var offset = (facing == FlxObject.LEFT) ? -16 : 16;
        bullets.recycle(MeleeBullet).shoot(new FlxPoint(getGraphicMidpoint().x + offset, getGraphicMidpoint().y - 2), 0);
    }
}