package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Plant extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var plant:String = FlxG.random.getObject(["flower", "grass"]);
		var num:Int = FlxG.random.int(1, 4);
		if (plant == "grass")
			num = FlxG.random.int(1, 6);
		
		loadGraphic("assets/images/gameArt/" + plant + num + ".png");
		
		allowCollisions = FlxObject.NONE;
		
		offset.y = height - 9;
		height = 5;
		
	}
	
}