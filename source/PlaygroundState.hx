package;

import flixel.FlxState;
import flixel.FlxObject;
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
    
    var enemies:FlxTypedGroup<Enemy>;

    public var bg:FlxSprite;

    override public function create():Void
    {
        super.create();

        bullets = new FlxTypedGroup<Bullet>();
        bullets.maxSize = 50;

        player = new Player(3 * Reg.T_WIDTH, 3 * Reg.T_HEIGHT,bullets);

        level = new Level();

        enemies = new FlxTypedGroup<Enemy>();
        enemies.maxSize = 100;

        bg = new FlxSprite(0, 0, "assets/images/cave_walls.png");
        bg.scrollFactor.set(0.6,0.6);
        add(bg);
        add(level.level);
        add(enemies);
        add(player);
        add(bullets);

        cameraTarget = new FlxSprite(0,0);
        FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON, 7);

        FlxG.camera.bgColor = 0xff23173b;
    }

    private function forDebug(){
        if(FlxG.keys.justPressed.R){
            trace("Restart level.");
            FlxG.switchState(this);
        }
        if(FlxG.keys.justPressed.SPACE){
            trace("Spawn enemy.");
            enemies.add(new EnemyWalking(0,4 * Reg.T_WIDTH));
        }
    }

    override public function update():Void
    {
        super.update();
        forDebug();

        FlxG.overlap(bullets, enemies, bulletHit);
        FlxG.collide(enemies, level.level, onCollision);
        FlxG.collide(player, level.level);

        cameraTarget.setPosition(player.x + (FlxG.mouse.x - player.x)/6, player.y + (FlxG.mouse.y - player.y)/6);
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    /*
     *  Callback function called by overlap() in update
     */
    private function onCollision(Object1:FlxObject, Object2:FlxObject):Void{
        // Bullet collide with level
        if(Std.is(Object1, Bullet)){
            Object1.kill();
        }
    }

    private function bulletHit(Bullet:Bullet, Enemy:Enemy):Void
    {
        Bullet.kill();

        if(Enemy.takeDamage(1)){
            FlxG.camera.shake(0.01,0.15);
            // enemy gibs
            // camera shake
        }
    }

}