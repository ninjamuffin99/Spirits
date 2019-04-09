package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Tree extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?variation:Int = 0) 
	{
		super(X, Y);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.treeSheet__png, AssetPaths.treeSheet__txt);
		frames = tex;
		
		maxVariant = frames.numFrames;
		trace(maxVariant);
		
		var daFrames:Array<Int> = [];
		for (f in 0...maxVariant)
		{
			daFrames.push(f);
			trace("added frames");
		}
		animation.add("lmao", daFrames, 0);
		animation.play("lmao");
		
		animation.curAnim.curFrame = variation;
		
		
		offsetHelper();
		
		trace("PLACED TREE: " + variation);
		trace("PLACED TREE: " + animation.curAnim.curFrame);
		
		immovable = true;
	}
	
	override function updateOffsets():Void 
	{
		updateHitbox();
		offsetHelper();
		
		super.updateOffsets();
	}
	
	override function offsetHelper():Void 
	{
		switch (animation.curAnim.curFrame)
		{
			case 0:
				offset.y = height - 35;
				height = 34;
				
				offset.x = 35;
				width -= 80;
			case 1:
				offset.y = height - 35;
				height = 34;
				
				offset.x = 30;
				width -= 75;
			case 2:
				offset.y = height - 45;
				height = 34;
				
				offset.x = 30;
				width -= 60;
		}
		
		super.offsetHelper();
	}
}