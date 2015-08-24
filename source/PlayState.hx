package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
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
	public static var whiteGibs:FlxEmitter;

	public static var effects:FlxTypedGroup<WooshEffects>;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,0.3,true);
		FlxG.mouse.visible = false;

		super.create();

		setupPlayer();
		setupEnemies();
		setupLevel();
		setupCamera();
		setupWorld();
		setupGibs();
		setupBg();

		FlxG.camera.bgColor = 0xff1d0d2c;

        add(level.level);
        add(enemyGibs);
        add(redGibs);
        add(whiteGibs);
		add(player);
        add(bullets);
        add(enemyBullets);
        add(enemies);
        add(effects);

        // FlxG.timeScale = 1;
		// FlxG.switchState(new PlayState());

        // FlxG.debugger.drawDebug = true;
        new FlxTimer(0.1, updateCameraFollow);
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

		level.level.overlapsWithCallback(player,playerLevelCollision);

		FlxG.collide(bullets, level.level, onCollision);
		FlxG.collide(enemyBullets, level.level, onCollision);
		FlxG.collide(enemyGibs, level.level, onCollision);
		FlxG.collide(whiteGibs, level.level, onCollision);
		FlxG.collide(enemies, level.level, onCollision);
		FlxG.collide(enemies, enemies);
		FlxG.collide(player, level.level, playerLevelCollision);

		FlxG.overlap(bullets, enemies, bulletHit);
		FlxG.overlap(player, enemies, playerHit);
		FlxG.overlap(player, enemyBullets, playerHit);
	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
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

			if(Std.is(Object1, RangedBullet) || Std.is(Object1, BombBullet)){
				whiteGibs.at(Object1);
				whiteGibs.start(true,1,0,5,3);
			}
		}
	}

	private function playerLevelCollision(Tile:FlxObject, Player:FlxObject):Bool{

		return true;
	}

	private function bulletHit(Bullet:Bullet, Enemy:Enemy):Void
	{
		Bullet.kill();

		if(Enemy.takeDamage(Reg.playerDamage)){
			enemyGibs.at(Bullet);
			enemyGibs.start(true,1,0,20,3);
		}
		if(Std.is(Bullet, RangedBullet) || Std.is(Bullet, BombBullet)){
			whiteGibs.at(Bullet);
			whiteGibs.start(true,1,0,5,3);
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
		Sounds.player_die();
		new FlxTimer(1.5, resetLevel);
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
			levelName = Reg.LEVEL_INTRO;

			case 1:
			levelName = Reg.DRAFT_1;

			case 2:
			levelName = Reg.LEVEL2;

			case 3:
			levelName = Reg.LEVEL3;

			case 10:
			levelName = Reg.DRAFT_1;

			case 11:
			levelName = Reg.DRAFT_2;
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
		FlxG.camera.setBounds(0,0,level.level.width, level.level.height);
		FlxG.camera.follow(player);
	}

	private function setupBg():Void
	{
		var moon = new FlxSprite(FlxG.width/2, FlxG.height/2, "assets/images/moon_sprite.png");
		moon.scrollFactor.set(0.1,0.1);
		add(moon);

		bg = new FlxSprite(0, 0, "assets/images/cave_walls.png");
		bg.scrollFactor.set(0.2,0.2);
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

		whiteGibs = new FlxEmitter();
		whiteGibs.setXSpeed( -50, 50);
		whiteGibs.setYSpeed( -50, 0);
		whiteGibs.setRotation( -360, 0);
		whiteGibs.gravity = 350;
		whiteGibs.bounce = 0.1;
		whiteGibs.makeParticles(Reg.GIBS_SPRITESHEET, 50, 20, true, 0.5);
	}

	public static function gotoNextLevel(){
        Reg.level++;
        FlxG.camera.fade(FlxColor.BLACK, 0.2);
        new FlxTimer(1, resetLevel);
	}

	public static function resetLevel(Timer:FlxTimer){
        FlxG.resetState();       
	}

	public function updateCameraFollow(Timer:FlxTimer){
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, 10);
	}
}