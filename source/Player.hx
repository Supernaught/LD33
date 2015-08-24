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
    private var maxSpeedX:Int = 100;
    private var maxSpeedY:Int = 220;

    private var movespeed:Float = 10000; // used to set velocity when pressing move keys
    private var jumpForce:Float = 170;

    // Jump stuff
    private var canJump:Bool;

    // Attack stuff
    private var canAttack:Bool;
    private var attackDelay:Float = 0.4;
    private var attackDelayCounter:Float;

    private var aiming:Bool; // used for ranged attacks
    private var xAim:Int = 0;
    private var yAim:Int = 0;

    private var bullets:FlxTypedGroup<Bullet>;
    private var effects:FlxTypedGroup<WooshEffects>;
    
    // Components
    private var canAttackComponent:CanAttack;

    public function new(X:Int, Y:Int, Bullets:FlxTypedGroup<Bullet>, Effects:FlxTypedGroup<WooshEffects>)
    {
        super(X,Y);

        // components = new Array<Component>();
        // components.push(new CanAttack(this));

        // Animation sprites stuff
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, 0xffc71045);

        var yOffset = 6;
        var xOffset = 4;

        width -= xOffset;
        height -= yOffset;

        offset.set(0,-1);

        // Attack stuff
        canAttack = false;
        bullets = Bullets;

        // Physics and movement stuff
        acceleration.y = UnitStats.DEFAULT_GRAVITY;
        maxVelocity.set(maxSpeedX, maxSpeedY);
        drag.x = movespeed;

        // Move stuff
        canJump = true;

        canAttackComponent = new CanAttack(this);

        // Animations
        switchToUnit(Reg.UNIT_HUMAN);
        animation.play("idle");

        effects = Effects;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        if(isTouching(FlxObject.FLOOR)){
            if(unitType == Reg.UNIT_FLYING){
                acceleration.x = 0;
            } else if(!canJump){
                canJump = true;
            }

            checkIfTouchingSpikes();
        } else if(isTouching(FlxObject.CEILING)){
            checkIfTouchingSpikes();
        }
        
        forDebug();
        movementControls();
        jumpControls();
        attackControls();

        attackUpdate();
        animationUpdate();

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function forDebug():Void
    {
        // if(FlxG.keys.pressed.ONE){
        //     Reg.level++;
        //     FlxG.resetState();
        // } 

        if(FlxG.keys.pressed.Q){
            Reg.level = 10;
            FlxG.resetState();
        }
        if(FlxG.keys.pressed.W){
            Reg.level = 11;
            FlxG.resetState();
        }

        if(FlxG.keys.pressed.ONE){
            switchToUnit(Reg.UNIT_HUMAN);
        } 
        if(FlxG.keys.pressed.TWO){
            switchToUnit(Reg.UNIT_TANK);
        } 
        if(FlxG.keys.pressed.THREE){
            switchToUnit(Reg.UNIT_RANGED);
        } 
        if(FlxG.keys.pressed.FOUR){
            switchToUnit(Reg.UNIT_FLYING);
        } 
    }

    public function switchToUnit(UnitType:Int){
        unitType = UnitType;

        FlxG.keys.reset();

        // canAttack = true;
        // canJump = true;
        aiming = false;

        // Defaults
        acceleration.y = UnitStats.DEFAULT_GRAVITY;
        maxVelocity.set(maxSpeedX, maxSpeedY);

        // trace(unitType);

        switch(UnitType){
            case Reg.UNIT_HUMAN:
            Reg.getPlayerAnim(this);
            maxVelocity.set(maxSpeedX, maxSpeedY);

            case Reg.UNIT_TANK:
            maxVelocity.set(maxSpeedX * 0.8, maxSpeedY);
            Reg.getTankAnim(this);

            case Reg.UNIT_MELEE:
            Reg.getTankAnim(this);

            case Reg.UNIT_RANGED:
            maxVelocity.set(maxSpeedX * 1.2, maxVelocity.y);
            Reg.getArcherAnim(this);

            case Reg.UNIT_FLYING:
            Reg.getGargoyleAnim(this);
            acceleration.y = UnitStats.FLY_GRAVITY * 3;
            // Reg.getFlyingAnim(this);
        }
    }

    public function movementControls():Void 
    {      
        if((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)){
            if(canWalk()){
                acceleration.x = -drag.x;
            }
        } else if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT){
            if(canWalk()){
                acceleration.x = drag.x;
            }            
        } else {
            acceleration.x = 0;
        }
    }

    public function jumpControls():Void{
        if(isTouching(FlxObject.FLOOR) && canJumpDown() && FlxG.keys.pressed.DOWN){
            y += 5;
            canJump = false;
        } else if(unitType != Reg.UNIT_FLYING){
            if(FlxG.keys.pressed.W || FlxG.keys.pressed.Z){
                if(canJump){
                    jump();
                }
                else {
                    acceleration.y = maxSpeedY * Reg.GRAVITY/2;
                }
            } else{
                acceleration.y = maxSpeedY * Reg.GRAVITY;
            }
        } else {
            if(FlxG.keys.justPressed.Z){
                hover();
            }
        }
    }

    public function hover():Void
    {
        velocity.y = -UnitStats.FLY_HOVER_FORCE * 4;
    }

    public function jump():Void
    {
        if(canJump){
            createDust(x,y);
            velocity.y = -jumpForce;
            canJump = false;
        }
    }

    public function animationUpdate():Void{

        if(velocity.x != 0 || (unitType == Reg.UNIT_FLYING && velocity.y != 0)){
            if(FlxG.keys.pressed.LEFT){
                facing = FlxObject.LEFT;
            } else if(FlxG.keys.pressed.RIGHT){
                facing = FlxObject.RIGHT;
            }
        }


        if(unitType != Reg.UNIT_FLYING && canAttack){
            if(unitType == Reg.UNIT_RANGED && aiming){
                if(yAim > 0){
                    animation.play("aim_Y");
                } else{
                    animation.play("aim_X");
                }
            } else if(velocity.y < 0){
                animation.play("jump");
            } else if(velocity.y > 0){
                animation.play("fall");
            } else{
                if(acceleration.x != 0)
                    animation.play("run");
                else
                    animation.play("idle");
            }
        } else if(unitType == Reg.UNIT_FLYING){
            if(velocity.y == 0){
                animation.play("grounded");
            } else{
                animation.play("fly");
                // animation.play((velocity.y > 0) ? "fly" : "fall" );
            }
        }
    }

    public function attackControls():Void
    {
        if(canAttack)
        {
            if((unitType == Reg.UNIT_HUMAN || unitType == Reg.UNIT_TANK || unitType == Reg.UNIT_FLYING) && (FlxG.mouse.justPressed || FlxG.keys.justPressed.X)){
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
                        yAim = 0;
                        xAim = FlxObject.LEFT;
                        facing = FlxObject.LEFT;
                    } else if(FlxG.keys.pressed.RIGHT){
                        yAim = 0;
                        facing = FlxObject.RIGHT;
                        xAim = FlxObject.RIGHT;
                    }
                    
                    if(FlxG.keys.pressed.UP){
                        yAim = FlxObject.UP;
                    }
                    // else if(FlxG.keys.pressed.DOWN){
                    //     yAim = FlxObject.DOWN;
                    // }

                } else if(aiming && FlxG.keys.justReleased.X){
                    var angle = 90;

                    if(yAim != 0){
                        angle = 0;
                    } else if (xAim != 0){
                        angle = 90;
                    }

                    // if(xAim == FlxObject.RIGHT){
                    //     angle = 90;
                    // }
                    // else {
                    //     angle = -90;
                    // }

                    angle = (facing == FlxObject.RIGHT)? angle : angle * -1;

                    bullets.recycle(RangedBullet).shoot(new FlxPoint(getGraphicMidpoint().x,getGraphicMidpoint().y), angle);

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
    }

    public function attack():Void
    {
        if(animation.getByName("attack") != null)
            animation.play("attack");

        canAttack = false;

        // Melee
        if(unitType == Reg.UNIT_MELEE || unitType == Reg.UNIT_HUMAN || unitType == Reg.UNIT_TANK){
            acceleration.x = 0;
            var offset = (facing == FlxObject.LEFT) ? -16 : 16;
            bullets.recycle(MeleeBullet).shoot(new FlxPoint(getGraphicMidpoint().x + offset, y - 16), 0);

            createSmashEffect(getGraphicMidpoint().x,y-16);
        }
        // Flying
        else if(unitType == Reg.UNIT_FLYING){
            bullets.recycle(BombBullet).shoot(new FlxPoint(getGraphicMidpoint().x, y), 180);
        }
    }

    public function takeDamage():Void{
        FlxG.camera.shake(0.01, 0.1);
        FlxG.camera.flash(null, 0.5, turnOffSlowMo);

        kill();

        FlxG.timeScale = 0.5;

        PlayState.playerDie();
    }

    public function createDust(X:Float, Y:Float):Void{
        effects.recycle(WooshEffects).createEffect(X,Y,Reg.JUMP_DUST);
    }

    public function createSmashEffect(X:Float, Y:Float):Void{
        trace(facing);
        effects.recycle(WooshEffects).createEffect(X,Y,Reg.ATTACK_WOOSH, facing);
    }

    public function canWalk():Bool{
        return !aiming && (unitType == Reg.UNIT_FLYING ? ((velocity.y != 0) ? true : false) : canAttack);
    }

    public function getTileBelow(X:Float):Int{
        return PlayState.level.level.getTile(Math.round(X/Reg.T_WIDTH),Math.round(y/Reg.T_HEIGHT + 1));
    }

    public function canJumpDown():Bool{
        return (getTileBelow(x-Reg.T_WIDTH) == 33 || getTileBelow(x) == 33 || getTileBelow(x+Reg.T_WIDTH) == 33);
    }

    public function turnOffSlowMo(){
        FlxG.timeScale = 1;
    }

    public function checkIfTouchingSpikes(){
        var tileAbove:Int = PlayState.level.level.getTile(Math.round(x/Reg.T_WIDTH),Math.round(y/Reg.T_HEIGHT - 1));
        var tileBelow:Int = PlayState.level.level.getTile(Math.round(x/Reg.T_WIDTH),Math.round(y/Reg.T_HEIGHT + 1));
        if(tileAbove == 52 || tileAbove == 53 || tileAbove == 54 || tileBelow == 41 || tileBelow == 42 || tileBelow == 40){
            takeDamage();
        }       
    }
}