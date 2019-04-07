package;

import djFlixel.map.MapTemplate;
import flixel.FlxCamera;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	public var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var _map:TiledLevel;
	public var _grpEntities:FlxTypedGroup<Interactable>;
	public var _grpGhosts:FlxTypedGroup<Ghost>;
	private var HUD:FlxText;
	private var bulletPreview:FlxSprite;
	private var stringPreview:FlxSprite;
	
	public var worldMeditation:Bool = false;
	private var meditateOverlay:FlxSprite;
	public var grpSpiritArea:FlxTypedGroup<FlxObject>;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.8;
		
		var forestBG:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.forestSketch__png);
		//add(forestBG);
		
		_grpGhosts = new FlxTypedGroup<Ghost>();
		add(_grpGhosts);
		
		grpSpiritArea = new FlxTypedGroup<FlxObject>();
		add(grpSpiritArea);
		
		_grpEntities = new FlxTypedGroup<Interactable>();
		add(_grpEntities);
		
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		bulletPreview = new FlxSprite(0, 0).makeGraphic(16, 8, FlxColor.RED);
		stringPreview = new FlxSprite(0, 0).makeGraphic(1, 1);
		_player = new Player(20, 20, playerBullets, bulletPreview, stringPreview);
		
		_map = new TiledLevel(AssetPaths.levelGood__tmx, this);
		add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		//add(_map.collisionTiles);
		
		_grpEntities.add(_player);
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN_TIGHT, 0.05);
		FlxG.camera.followLead.set(1.5, 1.5);
		FlxG.camera.focusOn(_player.getPosition());
		//FlxG.camera.setScrollBounds(0, forestBG.width, 0,  forestBG.height);
		
		HUD = new FlxText(10, 10, 0, "", 20);
		HUD.color = FlxColor.RED;
		HUD.scrollFactor.set();
		add(HUD);
		
		meditateOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		meditateOverlay.scrollFactor.set();
		meditateOverlay.alpha = 0.5;
		add(meditateOverlay);
		
		add(bulletPreview);
		add(stringPreview);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (worldMeditation != _player.meditating)
		{
			FlxG.camera.flash(FlxColor.WHITE, 0.4);
		}
		
		worldMeditation = _player.meditating;
		meditateOverlay.visible = worldMeditation;
		
		
		if (worldMeditation)
		{
			
		}
		else
		{
			
		}
		
		FlxG.watch.addQuick("cam col: ", FlxG.camera.color);
		
		
		_grpEntities.sort(FlxSort.byY);
		FlxG.collide(_grpEntities, _grpEntities);
		
		_player.peacefulness = FlxMath.roundDecimal(_player.peacefulness, 2);
		HUD.text = "PEACEFULNESS: " + _player.peacefulness;
		
		if (_player.peacefulness < 0 && FlxG.random.bool(0.3))
		{
			var randomX:Float = FlxG.random.float(100, 500);
			var randomY:Float = FlxG.random.float(100, 500);
			
			if (FlxG.random.bool())
				randomX *= -1;
			if (FlxG.random.bool())
				randomY *= -1;
			
			var badGhost:DarkSpirit = new DarkSpirit(_player.x + randomX, _player.y + randomY);
			badGhost.alpha = 0;
			_grpGhosts.add(badGhost);
			
		}
		
		_grpEntities.forEach(function(i:Interactable)
		{
			
		});
		
		_grpGhosts.forEach(function(g:Ghost)
		{
			//LIGHT GHOST SHIT
			if (g.OBJtype == Interactable.LIGHT_GHOST)
			{
				if (worldMeditation)
				{
					g.alpha = 0.8;
				}
				else
				{
					g.alpha = 0;
				}
			}
			
			
			// DARK GHOST SHIT
			if (g.OBJtype == Interactable.DARK_GHOST)
			{
				FlxVelocity.moveTowardsPoint(g, _player.getMidpoint(), 50);
				
				if (FlxG.overlap(g, _player))
				{
					g.kill();
					_player.peacefulness -= 3;
					FlxG.camera.flash(0xFFDD9988);
				}
				
				playerBullets.forEach(function(b:Bullet)
				{
					if (FlxG.overlap(g, b))
					{
						g.betterHealth -= b.damage;
						
						if (g.betterHealth == 0)
						{
							var corpse:Corpse = new Corpse(g.x, g.y);
							corpse.OBJtype = Interactable.DARK_GHOST_CORPSE;
							var velMult:Float = 0.4;
							corpse.velocity.set(b.velocity.x * velMult, b.velocity.y * velMult);
							_grpEntities.add(corpse);
							
							g.kill();
						}
						else if (g.betterHealth < 0)
						{
							g.kill();
							_player.peacefulness += 1;
						}
						
						_player.peacefulness += 4;
						
						b.kill();
					}
					
				});
				
				
				if (worldMeditation)
				{
					g.alpha = 0.8;
				}
				else
				{
					g.alpha = 0;
				}
				
				
			}
		});
		
		super.update(elapsed);
	}
}
