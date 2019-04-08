package;

import flixel.FlxObject;
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
		
		loadGraphic(AssetPaths.demon__png);
		offset.y = 20;
		height -= 40;
		offset.x = 20;
		width -= 40;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		OBJtype = Interactable.DARK_GHOST;
		betterHealth = 10;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (velocity.x > 0)
			facing = FlxObject.RIGHT;
		else
			facing = FlxObject.LEFT;
		
		super.update(elapsed);
	}
	
}