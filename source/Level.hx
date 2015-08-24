package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;
import flixel.group.FlxTypedGroup;
import Class;

class Level {
	public var level:FlxTilemap;

	private var enemyBullets:FlxTypedGroup<Bullet>;
	private var player:Player;

	public function new(LevelName:String, Enemies:FlxTypedGroup<Enemy>, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player){
		level = new FlxTilemap();
		level.loadMap(Assets.getText(LevelName), "assets/images/ld33_tilesheet.png", Reg.T_WIDTH, Reg.T_HEIGHT, null,null,0);

		enemyBullets = EnemyBullets;
		player = Player;

		// tile #2 = collide from up only
		level.setTileProperties(0,FlxObject.ANY);
		level.setTileProperties(10,FlxObject.NONE);
		level.setTileProperties(11,FlxObject.NONE);
		level.setTileProperties(22,FlxObject.NONE);
		level.setTileProperties(23,FlxObject.NONE);

		level.setTileProperties(31,FlxObject.UP);
		level.setTileProperties(32,FlxObject.UP);
		level.setTileProperties(33,FlxObject.UP);
		level.setTileProperties(34,FlxObject.UP);

		level.setTileProperties(37,FlxObject.NONE);
		level.setTileProperties(38,FlxObject.NONE);
		level.setTileProperties(39,FlxObject.NONE);


		Enemies.recycle(Enemy).destroy();
		if(Enemies != null){
			Enemies.recycle(EnemyTank).init(256, 128+240, EnemyBullets, Player);
			Enemies.recycle(EnemyArcher).init(220, 300, EnemyBullets, Player);
			Enemies.recycle(EnemyFlying).init(240, 540, EnemyBullets, Player);

			addEnemyOnTileCoords(22,23, EnemyArcher, Enemies);
		}
		// Enemies.add(new EnemyArcher(230,128));

		// if(level.getTileCoords(55, false) != null){
		// 	for(point in level.getTileCoords(55, false)){
		// 		Enemies.add(new Enemy(point.x, point.y));
		// 	}
		// }
	}

	public function addEnemyOnTileCoords(XTile:Int, YTile:Int, Type:Class<Enemy>, Enemies:FlxTypedGroup<Enemy>){
		Enemies.recycle(Type).init(XTile * 16, YTile * 16, enemyBullets, player);
	}
}