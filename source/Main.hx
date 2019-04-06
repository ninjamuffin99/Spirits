package;

import djFlixel.MainTemplate;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.events.Event;

import openfl.display.Sprite;
import openfl.Assets;

class Main extends MainTemplate
{
	var gameWidth:Int = 960; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 540; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	// You can pretty much ignore everything from here on - your code should go in your states.
	
	override function init():Void 
	{
		super.init();
		
		RENDER_HEIGHT = gameHeight;
		RENDER_WIDTH = gameWidth;
		FPS = framerate;
		INITIAL_STATE = initialState;
	}
}