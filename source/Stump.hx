package;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Stump extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		immovable = true;
		
		loadGraphic(AssetPaths.stumpSmall__png);
		offset.y = height - 20;
		height = 20;
	}
	
}