package;

import flixel.FlxSprite;
import flixel.FlxG;

class Dust extends FlxSprite
{
    public function new()
    {
        super();
    }

    override public function update():Void
    {
        super.update();

        if(animation.finished){
            kill();
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function createEffect(X:Float, Y:Float, Type:String){
        x = X;
        y = Y;
        
        switch(Type){
            case Reg.JUMP_DUST:
            Reg.getDustEffect(this);
            animation.play("jumpDust");
        }
    }
}