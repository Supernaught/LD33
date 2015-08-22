package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level {
	public var level:FlxTilemap;

	public function new(){
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/data/plain.csv"), "assets/images/tiles.png", Reg.T_WIDTH, Reg.T_HEIGHT);

		// tile #2 = collide from up only
		level.setTileProperties(2,FlxObject.UP);
	}
}