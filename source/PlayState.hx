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
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTile;
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
	public static var enemyGibs:FlxEmitter;
	public static var redGibs:FlxEmitter;

	public static var effects:FlxTypedGroup<WooshEffects>;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		super.create();

		setupPlayer();
		setupEnemies();
		setupLevel();
		setupWorld();
		setupCamera();
		setupGibs();
		setupBg();

		FlxG.camera.bgColor = 0xff1d0d2c;

        add(level.level);
        add(enemyGibs);
        add(redGibs);
		add(player);
        add(bullets);
        add(enemyBullets);
        add(enemies);
        add(effects);

        // FlxG.debugger.drawDebug = true;
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
		// cameraTarget.setPosition(player.x + (FlxG.mouse.x - player.x)/6, player.y + (FlxG.mouse.y - player.y)/6);
		
		super.update();

		level.level.overlapsWithCallback(player,playerLevelCollision, null, null);

		FlxG.collide(bullets, level.level, onCollision);
		FlxG.collide(enemyBullets, level.level, onCollision);
		FlxG.collide(enemyGibs, level.level, onCollision);
		FlxG.collide(enemies, level.level, onCollision);
		FlxG.collide(player, level.level, playerLevelCollision);

		FlxG.overlap(bullets, enemies, bulletHit);
		FlxG.overlap(player, enemies, playerHit);
		FlxG.overlap(player, enemyBullets, playerHit);
	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
			trace("Restart level.");
			FlxG.timeScale = 1;
			FlxG.switchState(new PlayState());
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

	private function playerLevelCollision(Tile:FlxObject, Player:FlxObject):Bool{
		// trace(Tile.index);

		return true;
		// trace(Level);
	}

	private function bulletHit(Bullet:Bullet, Enemy:Enemy):Void
	{
		Bullet.kill();

		if(Enemy.takeDamage(Bullet.damage)){
			enemyGibs.at(Bullet);
			enemyGibs.start(true,1,0,20,3);
			// enemy gibs
			// camera shake
		}
	}

	private function playerHit(Player:Player, HitObject:FlxObject):Void{
		if (Std.is(HitObject, Bullet)){
			HitObject.kill();
		}

		player.takeDamage();
	}

	public static function playerDie(){
		enemyGibs.at(player);
		enemyGibs.start(true,2,0.2,40,10);
	}

	private function setupPlayer():Void
	{
        // Effects
        effects = new FlxTypedGroup<WooshEffects>();
        effects.maxSize = 10;

        bullets = new FlxTypedGroup<Bullet>();
        bullets.maxSize = 50;

		player = new Player(0,0,bullets, effects);
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
		var levelName:String = "";

		switch(Reg.level){
			case 0:
			levelName = Reg.PLAIN2;
			// levelName = Reg.TUTORIAL;

			case 1:
			levelName = Reg.LEVEL1;

			case 2:
			levelName = Reg.LEVEL2;

			case 3:
			levelName = Reg.LEVEL3;
		}

		level = new Level(levelName, enemies, enemyBullets, player);
	}

	private function setupWorld():Void
	{
		FlxG.worldBounds.width = (level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (level.level.heightInTiles + 1) * Reg.T_HEIGHT;
	}

	private function setupCamera():Void
	{
		// cameraTarget = new FlxSprite(0,0);
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, 7);
		FlxG.camera.setBounds(0,0,level.level.width, level.level.height);
	}

	private function setupBg():Void
	{
		bg = new FlxSprite(0, 0, "assets/images/cave_walls.png");
		bg.scrollFactor.set(0.1,0.1);
		add(bg);
	}


	public function setupGibs():Void {
		enemyGibs = new FlxEmitter();
		enemyGibs.setXSpeed( -100, 100);
		enemyGibs.setYSpeed( -150, 0);
		enemyGibs.setRotation( -360, 0);
		enemyGibs.gravity = 350;
		enemyGibs.bounce = 0.3;
		enemyGibs.makeParticles(Reg.UNIT_GIBS_SPRITESHEET, 50, 20, true, 0.5);

		redGibs = new FlxEmitter();
		redGibs.setXSpeed( -100, 100);
		redGibs.setYSpeed( -150, 0);
		redGibs.setRotation( -360, 0);
		redGibs.gravity = 350;
		redGibs.bounce = 0.3;
		redGibs.makeParticles(Reg.RED_GIBS_SPRITESHEET, 50, 20, true, 0.5);
	}
}