package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;

class PlayState extends FlxState
{

	public static var cameraTarget:FlxSprite;
	public static var level:Level;

	var bg:FlxSprite;
	var bg2:FlxSprite;
	var player:Player;
	var bullets:FlxTypedGroup<Bullet>;
	var enemies:FlxTypedGroup<Enemy>;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupLevel();
		setupWorld();
		setupCamera();
		setupEnemies();
		// setupBg();

		FlxG.camera.bgColor = 0xff23173b;

        add(level.level);
		add(player);
        add(bullets);
        add(enemies);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		forDebug();
		cameraTarget.setPosition(player.x + (FlxG.mouse.x - player.x)/6, player.y + (FlxG.mouse.y - player.y)/6);
		
		super.update();

		FlxG.collide(bullets, level.level, onCollision);
		FlxG.collide(enemies, level.level, onCollision);
		FlxG.collide(player, level.level);

		FlxG.overlap(bullets, enemies, bulletHit);
	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
			trace("Restart level.");
			FlxG.switchState(new PlayState());
		}
		if(FlxG.keys.justPressed.SPACE){
			trace("Spawn enemy.");
			enemies.add(new EnemyWalking(10,100));
		}
	}

	/*
	 *	Callback function called by overlap() in update
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

	private function setupPlayer():Void
	{
        bullets = new FlxTypedGroup<Bullet>();
        bullets.maxSize = 50;

		player = new Player(0,0,bullets);
	}

	private function setupEnemies():Void
	{
		enemies = new FlxTypedGroup<Enemy>();
		enemies.maxSize = 100;
	}

	private function setupLevel():Void
	{
		level = new Level();
	}

	private function setupWorld():Void
	{
		FlxG.worldBounds.width = (level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (level.level.heightInTiles + 1) * Reg.T_HEIGHT;
	}

	private function setupCamera():Void
	{
		cameraTarget = new FlxSprite(0,0);
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON, 7);
	}

	private function setupBg():Void
	{
		bg = new FlxSprite(0, 0, "assets/images/cave_walls.png");
		bg.scrollFactor.set(0.1,0.1);
		add(bg);
		bg2 = new FlxSprite(0, 0, "assets/images/bg2.png");
		bg2.scrollFactor.set(0.15,0.15);
		add(bg2);
	}
}