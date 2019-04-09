package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Plant extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?variation:Int = 0) 
	{
		super(X, Y);
		
		if (variation == null)
			variation = 0;
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.plantSheet__png, AssetPaths.plantSheet__txt);
		frames = tex;
		
		maxVariant = frames.numFrames;
		trace(maxVariant);
		
		var daFrames:Array<Int> = [];
		for (f in 0...maxVariant)
		{
			daFrames.push(f);
		}
		animation.add("lmao", daFrames, 0);
		animation.play("lmao");
		
		animation.curAnim.curFrame = variation;
		
		allowCollisions = FlxObject.NONE;
		
		offset.y = height - 9;
		height = 5;
		
	}
	
}