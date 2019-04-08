package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Rock extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		
		loadGraphic("assets/images/gameArt/rock" + FlxG.random.int(1, 3) +".png");
		immovable = true;
		
		offset.y = height - 16;
		height = 16;
		
	}
	
}