package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Corpse extends Interactable 
{
	
	private var freshness:Float = 10;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(80, 80, FlxColor.ORANGE);
		drag.set(500, 500);
		allowCollisions = FlxObject.NONE;
	}
	
	override public function update(elapsed:Float):Void 
	{
		freshness -= FlxG.elapsed;
		if (freshness <= 0)
		{
			kill();
		}
		
		alpha = FlxMath.remapToRange(freshness, 0, 10, 0, 1);
		
		//alpha = FlxMath.remapToRange(alpha, 0, 10, 0, 1);
		
		
		super.update(elapsed);
	}
	
}