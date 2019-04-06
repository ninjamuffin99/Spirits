package;

import djFlixel.map.MapTemplate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var _map:TiledLevel;
	public var _grpTrees:FlxTypedGroup<Tree>;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.7;
		
		_grpTrees = new FlxTypedGroup<Tree>();
		add(_grpTrees);
		
		_map = new TiledLevel(AssetPaths.levelGood__tmx, this);
		add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		add(_map.collisionTiles);
		
		
		var forestBG:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.forestSketch__png);
		//add(forestBG);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_player = new Player(20, 20, playerBullets);
		add(_player);
		
		FlxG.camera.follow(_player);
		//FlxG.camera.setScrollBounds(0, forestBG.width, 0,  forestBG.height);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
