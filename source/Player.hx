package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;

class Player extends FlxSprite
{
    private static var ATTACK_COOLDOWN:Float = 0.1; // in milliseconds

    // Physics stuff
    private var maxSpeedX:Int = 150;
    private var maxSpeedY:Int = 400;

    private var jumpForceMultiplier:Float = 0.7;
    private var gravityMultiplier:Float = 2.4;
    private var xDragMultiplier:Float = 2;
    private var xAcceleration:Float; // used to set acceleration when pressing move keys
    private var jumpForce:Float;

    // Attack stuff
    private var attackDelayCounter:Float;


    public function new(X:Int, Y:Int, Bullets:FlxTypedGroup<Bullet>)
    {
        super(X,Y);

        // Animation sprites stuff
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, FlxColor.WHITE);

        // Physics and movement stuff
        maxVelocity.set(maxSpeedX, maxSpeedY);
        acceleration.y = maxSpeedY * gravityMultiplier;
        jumpForce = maxSpeedY * jumpForceMultiplier;

        xAcceleration = maxSpeedX * 10;
        drag.x = xAcceleration * xDragMultiplier;
    }

    override public function update():Void
    {
        playerControls();

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function playerControls():Void
    {
        movement();
    }

    public function movement():Void 
    {        
        if(FlxG.keys.pressed.A){
            acceleration.x = -xAcceleration;
        } else if(FlxG.keys.pressed.D){
            acceleration.x = xAcceleration;
        } else {
            acceleration.x = 0;
        }

        if(FlxG.keys.justPressed.W){
            velocity.y = -jumpForce;
        }
    }
}