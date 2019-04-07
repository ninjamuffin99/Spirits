package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

/**
 * ...
 * @author 
 */
class Ghost extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?Path:FlxPath) 
	{
		super(X, Y);
		
		makeGraphic(50, 50);
		
		if (Path != null)
		{
			path = Path;
			path.start(null, 100, FlxPath.LOOP_FORWARD);
		}
	}
	
}