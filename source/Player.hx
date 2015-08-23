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

    private var unitType:Int = Reg.UNIT_HUMAN;

    // Physics stuff
    private var maxSpeedX:Int = 120;
    private var maxSpeedY:Int = 220;

    private var movespeed:Float = 10000; // used to set velocity when pressing move keys
    private var jumpForce:Float = 170;

    // Jump stuff
    private var canJump:Bool;

    // Attack stuff
    private var canAttack:Bool;
    private var attackDelay:Float = 0.7;
    private var attackDelayCounter:Float;

    private var aiming:Bool; // used for ranged attacks
    private var xAim:Int;
    private var yAim:Int;

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
        switchToUnit(Reg.UNIT_HUMAN);
        animation.play("idle");

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        if(!canJump && isTouching(FlxObject.FLOOR)){
            canJump = true;
        }
        
        forDebug();
        movementControls();
        attackControls();

        attackUpdate();
        animationUpdate();

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

    public function forDebug():Void
    {
        if(FlxG.keys.pressed.ONE){
            switchToUnit(Reg.UNIT_HUMAN);
        } 
        if(FlxG.keys.pressed.TWO){
            switchToUnit(Reg.UNIT_MELEE);
        } 
        if(FlxG.keys.pressed.THREE){
            switchToUnit(Reg.UNIT_RANGED);
        } 
    }

    public function switchToUnit(UnitType:Int){
        unitType = UnitType;

        switch(UnitType){
            case Reg.UNIT_HUMAN:
            Reg.getPlayerAnim(this);

            case Reg.UNIT_MELEE:
            Reg.getTankAnim(this);

            case Reg.UNIT_RANGED:
            trace("ranged");
        }
    }

    public function movementControls():Void 
    {      
        if((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)){
            if(!aiming){
                acceleration.x = -drag.x;
            }

            facing = FlxObject.LEFT;
        } else if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT){
            if(!aiming){
                acceleration.x = drag.x;
            }            

            facing = FlxObject.RIGHT;
        } else {
            acceleration.x = 0;
        }

        if(FlxG.keys.pressed.W || FlxG.keys.pressed.Z){
            if(canJump){
                jump();
            }
            else {
                acceleration.y = maxSpeedY * Reg.GRAVITY/2;
            }
        } else {
            acceleration.y = maxSpeedY * Reg.GRAVITY;
        }
    }

    public function animationUpdate():Void{
        if(canAttack){
            if(velocity.y < 0){
                animation.play("jump");
            } else if(velocity.y > 0){
                animation.play("fall");
            } else{
                if(acceleration.x != 0)
                    animation.play("run");
                else
                    animation.play("idle");
            }
        }
    }

    public function attackControls():Void
    {
        if(canAttack)
        {
            if(unitType == Reg.UNIT_MELEE && (FlxG.mouse.justPressed || FlxG.keys.pressed.X)){
                attack();
            }
            else if(unitType == Reg.UNIT_RANGED){
                if(FlxG.keys.pressed.X){
                    if(!aiming){
                        aiming = true;
                        acceleration.x = 0;
                        // bullets.recycle(RangedBullet);
                    }

                    if(FlxG.keys.pressed.LEFT){
                        xAim = FlxObject.LEFT;
                    } else if(FlxG.keys.pressed.RIGHT){
                        xAim = FlxObject.RIGHT;
                    }
                    
                    // xAim = facing;

                    // yAim = FlxObject.NONE;

                    if(FlxG.keys.pressed.UP){
                        yAim = FlxObject.UP;
                    } else if(FlxG.keys.pressed.DOWN){
                        yAim = FlxObject.DOWN;
                    }

                } else if(aiming && FlxG.keys.justReleased.X){
                    // attack();

                    trace(xAim + " " + yAim);

                    var angle = 90;

                    if(yAim == FlxObject.UP){
                        angle = (xAim != FlxObject.NONE) ? 35 : 0;
                    } else if(yAim == FlxObject.DOWN){
                        angle = (xAim != FlxObject.NONE) ? 135 : 180;
                    }

                    // if(xAim == FlxObject.RIGHT){
                    //     angle = 90;
                    // }
                    // else {
                    //     angle = -90;
                    // }

                    angle = (facing == FlxObject.RIGHT)? angle : angle * -1;

                    bullets.recycle(RangedBullet).shoot(new FlxPoint(x,y), angle);

                    aiming = false;
                    yAim = FlxObject.NONE;
                    xAim = FlxObject.NONE;
                }
            }

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
        animation.play("attack");

        canAttack = false;

        // Fire a bullet
        if(unitType == Reg.UNIT_RANGED){
            var angle = (facing == FlxObject.LEFT) ? -90 : 90;           
            bullets.recycle(RangedBullet).shoot(new FlxPoint(x,y), angle);
        }

        // Attack melee
        if(unitType == Reg.UNIT_MELEE){
            isMeleeAttacking = true;
            meleeAttackFrameCounter = MELEE_ATTACK_FRAMES;
            var offset = (facing == FlxObject.LEFT) ? -16 : 16;
            bullets.recycle(MeleeBullet).shoot(new FlxPoint(getGraphicMidpoint().x + offset, getGraphicMidpoint().y - 2), 0);
        }
    }

    public function takeDamage():Void{
        FlxG.camera.shake(0.01, 0.05);
        FlxG.camera.flash(null, 0.5);
    }
}