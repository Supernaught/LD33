/*  
 * ============================
 *	 FlxEmitter Cheat sheet
 * ============================
 */

// variable
public var gibs:FlxEmitter;

// initialize
setupGibs(); // inside create function

public function setupGibs(){
	gibs = new FlxEmitter();
	gibs.setXSpeed( -100, 100);
	gibs.setYSpeed( -150, 0);
	gibs.setRotation( -360, 0);
	gibs.gravity = 350;
	gibs.bounce = 0.3;
	gibs.makeParticles("assets/images/enemy_gibs.png", 100, 10, true, 0.5);
}

// to play emitter
gibs.at(new FlxObject(x,y)); // where x y = position
gibs.start(true,1,0,20,3);	// http://api.haxeflixel.com/flixel/effects/particles/FlxTypedEmitter.html