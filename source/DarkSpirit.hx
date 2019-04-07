package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class DarkSpirit extends Ghost 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		color = FlxColor.GRAY;
		
		OBJtype = Interactable.DARK_GHOST;
	}
	
}