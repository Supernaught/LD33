/*  
 * ============================
 *	 FlxEmitter Cheat sheet
 * ============================
 */

// variable
var gibs:FlxEmitter;

// initialize
gibs = new FlxEmitter();
gibs.setXSpeed( -100, 100);
gibs.setYSpeed( -150, 0);
gibs.setRotation( -360, 0);
gibs.gravity = 350;
gibs.bounce = 0.3;
gibs.makeParticles("assets/images/enemy_gibs.png", 100, 10, true, 0.5);


// to start particle
gibs.at(FlxObject); // automatic get FlxObject's position
gibs.start(true,1,0,20,3);	// http://api.haxeflixel.com/flixel/effects/particles/FlxTypedEmitter.html