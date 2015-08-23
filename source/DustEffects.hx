package;

import flixel.FlxSprite;
import flixel.FlxG;

class DustEffects extends FlxSprite
{
    public function new(X:Float, Y:Float, Type:String)
    {
        switch(Type){
            case Reg.JUMP_DUST:
            Reg.getDustEffect(this);
            // animation.play("jumpDust");
        }
        super(X,Y);
    }

    override public function update():Void
    {
        super.update();

        // if(animation.finished){
        //     destroy();
        // }
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}