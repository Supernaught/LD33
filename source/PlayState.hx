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
import flixel.effects.particles.FlxEmitter;

class PlayState extends FlxState
{

	public static var cameraTarget:FlxSprite;
	public static var level:Level;

	var bg:FlxSprite;
	var bg2:FlxSprite;
	public static var player:Player;
	var bullets:FlxTypedGroup<Bullet>;
	var enemyBullets:FlxTypedGroup<Bullet>;
	var enemies:FlxTypedGroup<Enemy>;
	var enemyGibs:FlxEmitter;

	public static var effects:FlxTypedGroup<Dust>;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupEnemies();
		setupLevel();
		setupWorld();
		setupCamera();
		setupGibs();
		// setupBg();

		FlxG.camera.bgColor = 0xff23173b;

        add(level.level);
		add(player);
        add(bullets);
        add(enemyBullets);
        add(enemies);
        add(effects);
        add(enemyGibs);
	}
	
	override public function destroy():Void
	{
		super.destroy();

		level = null;
		player = null;
		bullets = null;
		enemies = null;
		bg = null;

		super.destroy();
	}

	override public function update():Void
	{
		forDebug();
		cameraTarget.setPosition(player.x + (FlxG.mouse.x - player.x)/6, player.y + (FlxG.mouse.y - player.y)/6);
		
		super.update();

		FlxG.collide(bullets, level.level, onCollision);
		FlxG.collide(enemyGibs, level.level, onCollision);
		FlxG.overlap(bullets, enemies, bulletHit);
		FlxG.overlap(player, enemies, playerHit);
		FlxG.overlap(player, enemyBullets, playerHit);
		FlxG.collide(enemies, level.level, onCollision);
		FlxG.collide(player, level.level);

	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
			trace("Restart level.");
			FlxG.switchState(new PlayState());
		}
		if(FlxG.keys.justPressed.SPACE){
			trace("Spawn enemy.");
			enemies.recycle(Enemy).init(10,100,enemyBullets,player);
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
			enemyGibs.at(Bullet);
			enemyGibs.start(true,1,0,20,3);
			// enemy gibs
			// camera shake
		}
	}

	private function playerHit(Player:Player, Enemy:Enemy):Void{
		Player.takeDamage();
	}

	private function setupPlayer():Void
	{
        // Effects
        effects = new FlxTypedGroup<Dust>();
        effects.maxSize = 10;

        bullets = new FlxTypedGroup<Bullet>();
        bullets.maxSize = 50;

		player = new Player(3 * 16, 3 * 16,bullets, effects);
	}

	private function setupEnemies():Void
	{
		enemies = new FlxTypedGroup<Enemy>();
		enemies.maxSize = 100;

		enemyBullets = new FlxTypedGroup<Bullet>();
		enemyBullets.maxSize = 100;
	}

	private function setupLevel():Void
	{
		level = new Level(Reg.PLAIN2, enemies, enemyBullets, player);
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
		FlxG.camera.setBounds(0,-200,level.level.width, level.level.height*2);
	}

	private function setupBg():Void
	{
		bg = new FlxSprite(0, 0, "assets/images/cave_walls.png");
		bg.scrollFactor.set(0.6,0.6);
		add(bg);
	}


	public function setupGibs():Void {
		enemyGibs = new FlxEmitter();
		enemyGibs.setXSpeed( -100, 100);
		enemyGibs.setYSpeed( -150, 0);
		enemyGibs.setRotation( -360, 0);
		enemyGibs.gravity = 350;
		enemyGibs.bounce = 0.3;
		enemyGibs.makeParticles(Reg.DUST_SPRITESHEET, 10, 20, true, 0.5);
	}
}