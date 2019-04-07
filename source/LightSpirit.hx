package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

/**
 * ...
 * @author 
 */
class LightSpirit extends Ghost 
{

	public function new(?X:Float=0, ?Y:Float=0, ?path:FlxPath) 
	{
		super(X, Y, path);
		
		makeGraphic(50, 50, FlxColor.RED);
		betterHealth = 10;
	}
	
}