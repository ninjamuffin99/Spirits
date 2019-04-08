package;

import djFlixel.FLS;
import djFlixel.map.MapTemplate;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.xml.Fast;

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
	private var overlayDEAD:FlxSprite;
	private var camFollow:FlxObject;
	
	private var lightSpiritSpawned:Bool = false;
	
	private var mapEditing:Bool = false;
	private var curTool:Int = 0;
	private var editorTools:Array<String> = ["Add", "Move"];
	private var curOBJ:Int = 0;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.9;
		FlxG.camera.bgColor = 0xFFf7adab;
		FlxG.sound.playMusic(AssetPaths.song__ogg, 0.6);
		FlxG.camera.fade(FlxColor.BLACK, 5, true);
		
		
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
		
		//trace(FLS.assets.getFileAsText("assets/data/levelGood.tmx"));
		
		_map = new TiledLevel("assets/data/newlevelgood.tmx", this);
		//add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		add(_map.collisionTiles);
		
		_grpEntities.add(_player);
		
		var beast:Interactable = new Interactable(2440, 2670);
		beast.loadGraphic(AssetPaths.beast__png);
		beast.immovable = true;
		beast.offset.y = beast.height - 100;
		beast.height = 100;
		_grpEntities.add(beast);
		
		camFollow = new FlxObject(_player.x, _player.y, 1, 1);
		add(camFollow);
		
		FlxG.camera.follow(camFollow, FlxCameraFollowStyle.TOPDOWN_TIGHT, 0.05);
		FlxG.camera.followLead.set(1.5, 1.5);
		FlxG.camera.focusOn(camFollow.getPosition());
		//FlxG.camera.setScrollBounds(0, forestBG.width, 0,  forestBG.height);
		
		HUD = new FlxText(10, 10, 0, "", 20);
		HUD.color = FlxColor.RED;
		HUD.scrollFactor.set();
		//add(HUD);
		
		meditateOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		meditateOverlay.scrollFactor.set();
		meditateOverlay.alpha = 0.5;
		meditateOverlay.setGraphicSize(Std.int(meditateOverlay.width / FlxG.camera.zoom));
		add(meditateOverlay);
		
		overlayDEAD = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
		overlayDEAD.scrollFactor.set();
		overlayDEAD.setGraphicSize(Std.int(overlayDEAD.width / FlxG.camera.zoom));
		add(overlayDEAD);
		
		add(bulletPreview);
		add(stringPreview);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		_map.collideWithLevel(_grpEntities);
		
		if (FlxG.keys.justPressed.ENTER)
			mapEditing = !mapEditing;
		
		if (mapEditing)
		{
			_player.solid = false;
			mapEditCode();
		}
		else
		{
			if (addedTempObjs)
			{
				tempObjs.forEach(function(i:Interactable){i.visible = false; });
			}
			
			_player.solid = true;
		}
		
		if (_player.aiming || _player.meditating)
		{
			
			//SHOUTOUT TO MIKE, AND ALSO BOMTOONS
			var dx = _player.x - FlxG.mouse.x;
			var dy = _player.y - FlxG.mouse.y;
			//var length = Math.sqrt(dx * dx + dy * dy);
			var camOffset = 0.7;
			
			dx *= camOffset;
			dy *= camOffset;
			
			// + dx is for inverse looking, feels nicer when shooting
			// -  is for meditation and also is better this way i guess
			if (_player.aiming)
			{
				camFollow.x = _player.x + dx;
				camFollow.y = _player.y + (dy * 1.05);
			}
			else
			{
				camFollow.x = _player.x - (dx * 0.5);
				camFollow.y = _player.y - (dy * 0.65);
			}
			
		}
		else
			camFollow.setPosition(_player.getMidpoint().x, _player.getMidpoint().y);
		
		
		
		
		if (worldMeditation != _player.meditating)
		{
			FlxG.camera.flash(FlxColor.WHITE, 0.4);
			FlxG.sound.play(AssetPaths.meditate__ogg);
		}
		
		worldMeditation = _player.meditating;
		meditateOverlay.visible = worldMeditation;
		
		overlayDEAD.alpha = FlxMath.remapToRange(_player.corruption, 0, _player.corruptMax, 0, 1);
		
		
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
			i.visible = i.isOnScreen();
			
			if (i.OBJtype == Interactable.DARK_GHOST_CORPSE)
			{
				if (i.overlaps(grpSpiritArea))
				{
					if (!lightSpiritSpawned && FlxG.random.bool(0.2))
					{
						var goodGhost:BeastSpirit = new BeastSpirit();
					}
				}
			}
			
			if (i.OBJtype == Interactable.TOTEM)
			{
				if (!worldMeditation)
				{
					i.animation.play("sleep");
				}
				else
				{
					i.animation.play("on");
				}
			}
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
				FlxVelocity.moveTowardsPoint(g, _player.getMidpoint(), 30);
				
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
		
		#if EXTERNAL_LOAD
			FLS.debug_keys();
		#end
	}
	
	private function mapEditCode():Void
	{
		
		toolSelection();
		
		switch (curTool)
		{
			case 0:
				addingObjects();
		}
	}
	
	private function toolSelection():Void
	{
		curTool += FlxG.mouse.wheel;
		
		if (FlxG.keys.justPressed.UP)
			curTool += 1;
		if (FlxG.keys.justPressed.DOWN)
			curTool -= 1;
		
		if (curTool >= editorTools.length)
		{
			curTool = 0;
		}
		if (curTool < 0)
			curTool = editorTools.length - 1;
		
		
	}
	
	private var tempObjs:FlxTypedGroup<Interactable>;
	private var addedTempObjs = false;
	
	private function addingObjects():Void
	{
		if (!addedTempObjs)
		{
			tempObjs = new FlxTypedGroup<Interactable>();
			
			var tree:Tree = new Tree();
			tempObjs.add(tree);
			
			var plant:Plant = new Plant();
			tempObjs.add(plant);
			
			var stump:Stump = new Stump();
			tempObjs.add(stump);
			
			var rock:Rock = new Rock();
			tempObjs.add(rock);
			
			add(tempObjs);
			
			
			for (obj in tempObjs.members)
			{
				trace("Added debug object");
				obj.visible = false;
			}
			
			addedTempObjs = true;
		}
		
		if (FlxG.keys.justPressed.LEFT)
			curOBJ -= 1;
		if (FlxG.keys.justPressed.RIGHT)
			curOBJ += 1;
		
		if (curOBJ >= tempObjs.members.length)
			curOBJ = 0;
		if (curOBJ < 0)
			curOBJ = tempObjs.members.length - 1;
		
		tempObjs.forEach(function(i:Interactable)
		{
			i.visible = false;
		});
		
		tempObjs.members[curOBJ].visible = true;
		tempObjs.members[curOBJ].setPosition(FlxG.mouse.x, FlxG.mouse.y);
		
		tempObjs.members[curOBJ].flipX = FlxG.keys.pressed.F;
		
		if (FlxG.mouse.justPressed)
		{
			var objNew:Interactable;
			
			switch(curOBJ)
			{
				case 0:
					objNew = new Tree();
				case 1:
					objNew = new Plant();
				case 2:
					objNew = new Stump();
				case 3:
					objNew = new Rock();
				default:
					objNew = new Interactable();
			}
			
			objNew.flipX = FlxG.keys.pressed.F;
			objNew.setPosition(tempObjs.members[curOBJ].x, tempObjs.members[curOBJ].y);
			_grpEntities.add(objNew);
		}
	}
	
}
