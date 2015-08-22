package;

import flixel.FlxState;
import flixel.FlxG;

class PlaygroundState extends FlxState
{   
    public var player:Player;

    override public function create():Void
    {
        super.create();
        player = new Player(0,0);
        add(player);
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