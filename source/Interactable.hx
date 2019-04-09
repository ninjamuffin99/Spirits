package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Shit that either interacts with bullets (gets shot) or can collide with one another
 * @author 
 */
class Interactable extends FlxSprite 
{
	
	public var peacefulness:Float = 0;
	public var minPeace:Float = -30;
	public var maxPeace:Float = 30;
	public var betterHealth:Float = 0;
	
	public var OBJtype:Int = 0;
	
	public static inline var TREE:Int = 0;
	public static inline var PLANT:Int = 1;
	public static inline var STUMP:Int = 2;
	public static inline var ROCK:Int = 3;
	
	public static inline var TOTEM:Int = 69;
	public static inline var LIGHT_GHOST:Int = 11;
	public static inline var DARK_GHOST:Int = 12;
	public static inline var SPIRIT_GHOST:Int = 13;
	
	public static inline var LIGHT_GHOST_CORPSE:Int = 51;
	public static inline var DARK_GHOST_CORPSE:Int = 52;
	
	//EDITOR SHIT
	public var maxVariant:Int = 0;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (alpha > 1)
			alpha = 1;
		if (alpha <= 0)
			alpha = 0;
		
		alpha = FlxMath.roundDecimal(alpha, 2);
		
	}
	
	public function updateOffsets():Void
	{
		
	}
	
	private function offsetHelper():Void
	{
		
	}
	
}