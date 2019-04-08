package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Tree extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?type:String = "small") 
	{
		super(X, Y);
		
		switch(type)
		{
			case "small":
				loadGraphic(AssetPaths.treeSmall__png);
			case "med":
				loadGraphic(AssetPaths.treeMed__png);
			case "large":
				loadGraphic(AssetPaths.treeLarge__png);
		}
		
		
		offset.y = height - 35;
		height = 34;
		
		offset.x = 30;
		width -= 60;
	}
	
}