package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxVelocity;

class Bullet extends FlxSprite
{
	public var damage:Int = 1;

    public function new()
    {
        super();
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function shoot(Pos:FlxPoint, Angle:Float):Bullet{
 		return this;       
    }

    public function setSpeed(X:Float = null, Y:Float = null):Void{
    	
    }
}