package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;

class PlaygroundState extends FlxState
{   
    public var cameraTarget:FlxSprite;

    public var player:Player;
    public var bullets:FlxTypedGroup<Bullet>;
    public var level:Level;

    override public function create():Void
    {
        super.create();

        bullets = new FlxTypedGroup<Bullet>();
        bullets.maxSize = 50;

        player = new Player(0,0,bullets);

        level = new Level();

        add(level.level);
        add(player);

        cameraTarget = new FlxSprite(0,0);
        FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON, 7);

        FlxG.camera.bgColor = 0xff23173b;
    }

    override public function update():Void
    {
        super.update();
        FlxG.collide(player, level.level);

        cameraTarget.setPosition(player.x + (FlxG.mouse.x - player.x)/6, player.y + (FlxG.mouse.y - player.y)/6);
    }

    override public function destroy():Void
    {
        super.destroy();
    }

}