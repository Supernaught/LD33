package;

import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{
    public function new(X:Int, Y:Int)
    {
        super(X,Y);

        // acceleration.y = 100;

        // animation.play("test");
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}