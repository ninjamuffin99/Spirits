package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKeyboard;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{
	public var Speed:Float = 1850;
	private var Drag:Float = 900;
	private var MaxVel:Float = 350;
	private var moving:Bool = false;
	public var bulletArray:FlxTypedGroup<Bullet>;

	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		makeGraphic(110, 180);
		
		drag.x = Drag;
		drag.y = Drag;
		maxVelocity.x = maxVelocity.y = MaxVel;
		
		bulletArray = playerBulletArray;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		controls();
	}
	
	private function controls():Void
	{
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
		
		if (_left || _right || _up || _down)
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
	
	private function mouseControls():Void
	{
		if (FlxG.mouse.justPressed)
		{
			oldMousePos = FlxG.mouse.getPosition();
		}
		
		if (FlxG.mouse.pressed)
		{
			aimAngle = Math.atan2(FlxG.mouse.y - oldMousePos.y, FlxG.mouse.x - oldMousePos.x);
		}
		
		if (FlxG.mouse.justReleased)
		{
			var newBullet = new Bullet(getMidpoint().x, getMidpoint().y, 1000, 60, aimAngle);
			newBullet.velocity.x += velocity.x * 0.2;
			newBullet.velocity.y += velocity.y * 0.2;
			bulletArray.add(newBullet);
		}
	}
	
}