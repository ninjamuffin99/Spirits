package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKeyboard;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Player extends Interactable 
{
	public var Speed:Float = 400;
	private var Drag:Float = 1200;
	private var MaxVel:Float = 240;
	private var moving:Bool = false;
	public var bulletArray:FlxTypedGroup<Bullet>;
	private var bulletPreview:FlxSprite;
	private var stringPreview:FlxSprite;
	
	public var aiming:Bool = false;
	
	public var meditating:Bool = false;
	
	public var corruption:Float = 0;
	public var corruptMax:Float = 20;
	
	
	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>, bulletPrev:FlxSprite, stringPrev:FlxSprite) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.player__png);
		//makeGraphic(64, 90, FlxColor.BLUE);
		
		offset.y = height - 20;
		height = 20;
		offset.x = 15;
		width -= 25;
		
		drag.x = Drag;
		drag.y = Drag;
		maxVelocity.x = maxVelocity.y = MaxVel;
		
		bulletPreview = bulletPrev;
		stringPreview = stringPrev;
		
		bulletArray = playerBulletArray;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		controls();
		
		if (FlxG.keys.pressed.SPACE)
		{
			meditating = true;
		}
		else
			meditating = false;
		
		if (meditating)
			peacefulness += 1 * FlxG.elapsed;
		
		if (peacefulness < maxPeace)
		{
			peacefulness += 1 * FlxG.elapsed;
		}
		else
			peacefulness = maxPeace;
		
		if (peacefulness < minPeace)
		{
			peacefulness = minPeace;
		}
		
		if (peacefulness < -25)
		{
			corruption += 1.2 * FlxG.elapsed;
		}
		
		if (corruption > 0)
		{
			corruption -= 0.2 * FlxG.elapsed;
		}
		
		if (corruption > 19)
		{
			// DIED
		}
	}
	
	private function controls():Void
	{
		if (!meditating)
			mouseControls();
		
		// PRESSING
		var _left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
		var _right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
		var _up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
		var _down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
		
		// JUST PRESSED
		var leftP:Bool = FlxG.keys.anyJustPressed(["A", "LEFT"]);
		var rightP:Bool = FlxG.keys.anyJustPressed(["D", "RIGHT"]);
		var upP:Bool = FlxG.keys.anyJustPressed(["W", "UP"]);
		var downP:Bool = FlxG.keys.anyJustPressed(["S", "DOWN"]);
		
		// JUST RELEASED
		var leftR:Bool = FlxG.keys.anyJustReleased(["A", "LEFT"]);
		var rightR:Bool = FlxG.keys.anyJustReleased(["D", "RIGHT"]);
		var upR:Bool = FlxG.keys.anyJustReleased(["W", "UP"]);
		var downR:Bool = FlxG.keys.anyJustReleased(["S", "DOWN"]);
		
		
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		if (_up && _down)
		{
			_up = _down = false;
		}
		
		if ((_left || _right || _up || _down) && !aiming && !meditating)
		{
			moving = true;
			if (FlxG.keys.pressed.SHIFT)
			{
				maxVelocity.set(MaxVel * 1.4, MaxVel * 1.4);
			}
			else
			{
				maxVelocity.set(MaxVel, MaxVel);
			}
			
			if (_up)
			{
				acceleration.y = -Speed;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				acceleration.y = Speed;
				facing = FlxObject.DOWN;
			}
			else
				acceleration.y = 0;
			
			if (_left)
			{
				facing = FlxObject.LEFT;
				acceleration.x = -Speed;
			}
			else if (_right)
			{
				facing = FlxObject.RIGHT;
				acceleration.x = Speed;
			}
			else
				acceleration.x = 0;
			
			//acceleration.set(_playerSpeed, 0);
			//acceleration.rotate(FlxPoint.weak(0, 0), mA);
		}
		else
		{
			acceleration.x = acceleration.y = 0;
			
		}
		
	}
	
	private var oldMousePos:FlxPoint;
	private var aimAngle:Float = 0;
	private var aimPower:Float = 0;
	
	private function mouseControls():Void
	{
		if (FlxG.mouse.justPressed)
		{
			oldMousePos = FlxG.mouse.getPosition();
		}
		
		
		
		if (FlxG.mouse.pressed && FlxMath.vectorLength(FlxG.mouse.y - oldMousePos.y, FlxG.mouse.x - oldMousePos.x) > 40)
		{
			
			aiming = true;
			
			aimAngle = Math.atan2(FlxG.mouse.y - oldMousePos.y, FlxG.mouse.x - oldMousePos.x);
			
			aimPower = FlxMath.vectorLength(FlxG.mouse.y - oldMousePos.y, FlxG.mouse.x - oldMousePos.x);
			if (aimPower > 200)
			{
				aimPower = 200;
			}
			
			bulletPreview.visible = true;
			bulletPreview.angle = FlxAngle.asDegrees(aimAngle);
			bulletPreview.setPosition(getMidpoint().x, getMidpoint().y);
			
			stringPreview.setGraphicSize(Std.int(aimPower), 1);
			stringPreview.angle = FlxAngle.asDegrees(aimAngle);
			stringPreview.setPosition(getMidpoint().x, getMidpoint().y);
			stringPreview.visible = true;
			
		}
		else
		{
			aiming = false;
			
			stringPreview.visible = false;
			bulletPreview.visible = false;
		}
		
		if (FlxG.mouse.justReleased)
		{
			
			var dmg:Float;
			if (peacefulness > 15)
				dmg = 2.5;
			else if (peacefulness > 0)
				dmg = 5;
			else if (peacefulness > -15)
				dmg = 10;
			else
				dmg = 20;
			
			
			aimPower = FlxMath.remapToRange(aimPower, 40, 200, 0.4, 1.2);
			
			var arrowSpeed:Float = FlxMath.remapToRange(peacefulness, minPeace, maxPeace, 2.6, 0.5);
			
			var newBullet = new Bullet(getMidpoint().x, getMidpoint().y, 1000 * arrowSpeed * aimPower, dmg, aimAngle);
			newBullet.velocity.x += velocity.x * 0.2;
			newBullet.velocity.y += velocity.y * 0.2;
			bulletArray.add(newBullet);
			
			peacefulness -= 4;
		}
	}
	
}