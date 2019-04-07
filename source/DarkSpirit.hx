package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

/**
 * ...
 * @author 
 */
class DarkSpirit extends Ghost 
{

	public function new(?X:Float=0, ?Y:Float=0, ?path:FlxPath) 
	{
		super(X, Y, path);
		
		color = FlxColor.GRAY;
		
		OBJtype = Interactable.DARK_GHOST;
		betterHealth = 10;
	}
	
}