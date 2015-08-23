package;

import flixel.FlxSprite;
import flixel.FlxG;

class Dust extends FlxSprite
{
    public function new(X:Float, Y:Float, Type:String)
    {
        super(X,Y);
        switch(Type){
            case Reg.JUMP_DUST:
            Reg.getDustEffect(this);
            animation.play("jumpDust");
        }
    }

    override public function update():Void
    {
        super.update();

        if(animation.finished){
            destroy();
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}