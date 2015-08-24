package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

class WooshEffects extends FlxSprite
{
    public function new()
    {
        super();
    }

    override public function update():Void
    {
        super.update();

		setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        if(animation.finished){
            kill();
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function createEffect(X:Float, Y:Float, Type:String, Facing:Int = FlxObject.RIGHT){
        x = X;
        y = Y;

        if(Facing == FlxObject.LEFT){
        	flipX = true;
        	x -= 32;
        }
        
        switch(Type){
            case Reg.JUMP_DUST:
            Reg.getDustEffect(this);
            animation.play("jumpDust");

            case Reg.ATTACK_WOOSH:
            Reg.getSmashEffect(this);
            animation.play("smashEffect");
        }

    }
}