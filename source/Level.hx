package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level {
	public var level:FlxTilemap;

	public function new(){
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/data/ld33_tileset.csv"), "assets/images/ld33_tilesheet.png", Reg.T_WIDTH, Reg.T_HEIGHT, null,null,0);

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
	}
}