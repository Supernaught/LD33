package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level {
	public var level:FlxTilemap;

	public function new(LevelName:String, enemies){
		level = new FlxTilemap();
		level.loadMap(Assets.getText(LevelName), "assets/images/ld33_tilesheet.png", Reg.T_WIDTH, Reg.T_HEIGHT, null,null,0);

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


		// enemies.add(new Enemy(0,0));
		if(enemies != null){
			enemies.add(new EnemyTank(256,128));
		}
		// enemies.add(new EnemyArcher(230,128));

		// if(level.getTileCoords(55, false) != null){
		// 	for(point in level.getTileCoords(55, false)){
		// 		enemies.add(new Enemy(point.x, point.y));
		// 	}
		// }
	}
}