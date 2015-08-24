package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;

class EnemyWalking extends Enemy
{
    public function new()
    {
        hp = 3;
        movespeed = 1000;
        
        super();
        
        maxSpeedX = 50;
        drag.x = movespeed;
        acceleration.x = (facing == FlxObject.RIGHT ) ? movespeed : -movespeed;

        facing = FlxObject.RIGHT;
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, FlxColor.MAGENTA);
    }

    override public function update():Void
    {
        animationUpdate();
        super.update();
    }

    override public function die():Void{
        super.die();
    }

    public function animationUpdate():Void{
        if(velocity.x > 0){
            facing = FlxObject.RIGHT;
        } else {
            facing = FlxObject.LEFT;
        }

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