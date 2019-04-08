package;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Totem extends Interactable 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		OBJtype = Interactable.TOTEM;
		immovable = true;
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.totemSheet__png, AssetPaths.totemSheet__txt);
		frames = tex;
		
		animation.add("sleep", [0]);
		animation.add("awake", [1, 2], 6, false);
		animation.add("on", [2]);
		animation.add("right", [3]);
		animation.add("left", [4]);
		
		offset.y = height - 20;
		height = 20;
	}
	
}