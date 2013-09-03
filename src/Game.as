package  
{
	import assets.Assets;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import com.freshplanet.ane.AirChartboost;
	import com.freshplanet.ane.AirChartboostEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import com.playhaven.events.ContentDismissalReason;
	import com.playhaven.events.PlayHavenEvent;
	import com.playhaven.PlayHaven;
	import com.revmob.airextension.events.RevMobAdsEvent;
	import com.revmob.airextension.RevMob;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import helper.Category;
	import helper.Constants;
	import helper.Trigger;
	import objects.Box;
	import objects.Btn;
	import objects.Cannon;
	import objects.CannonBall;
	import objects.Door;
	import objects.Key;
	import objects.Player;
	import objects.Star;
	import physics.PhysicWorld;
	import physics.PlayerContactListener;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Game extends Sprite 
	{
		private const FIXED_TIMESTEP:Number = 1 / 50;
		private const MAX_STEPS:int = 5;
		private var _currentTime:Number = 0;
		private var _fixedTimestepAccumulator:Number = 0;
		private var _fixedTimestepAccumulatorRatio:Number = 0;
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:Number = 30;
		private var _player:Player;
		private var _left:Boolean;
		private var _right:Boolean;
		private var _jump:Boolean;
		private var trigger1:Trigger;
		private var trigger2:Trigger;
		private var touches:Vector.<Touch> = new Vector.<Touch>();
		private var touch:Touch;
		private var creatingKind:int = 1;
		private var _back:Image;
		private var _tileManager:TileManager;
		private var _startingPosition:Point;
		private var _flyingTimer:int = 0;
		private var _direction:String = "Right";
		private var _canJump:Boolean;
		private var _startingBoxes:Array = [0, 0, 0];
		private var _boxAvailable:Array = [1, 1, 1];
		private var _boxButtons:Array = [];
		
		private var _environmentFront:Sprite;
		private var _environmentBack:Sprite;
		private var _cannons:Sprite;
		private var _cannonBalls:Sprite;
		private var _keys:Sprite;
		private var _stars:Sprite;
		private var _boxes:Sprite;
		private var _btns:Sprite;
		private var _doors:Sprite;
		private var _gui:Sprite;
		//private var _clouds:Sprite;
		//private var _clouds2:Sprite;
		private var _selection:Image;
		private var _canBeCreated:Boolean;
		private var _buttonOldPoint:Point;
		private var _victory:Victory;
		private var _inGameMenu:InGameMenu;
		private var _paused:Boolean;
		private var _deadPlayer:Image;
		private var _fallingBody:b2Body;
		private var _cross:Image;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _previousState:int;
		private var _guiback:Image;
		private var _touchPoint:Point;
		private var _icons:Array = [];
		private var _levelNumber:int;
		private var _finalCartoon:FinalCartoon;
		private var _leftButton:Image;
		private var _rightButton:Image;
		private var _jumpButton:Image;
		private var _isPlacingBox:Boolean = false;
		private var _menuButton:Button;
		private var _restartButton:Button;
		//private var _cloudTimer:int = 0;
		private var body:b2Body;
		private var _isJumping:Boolean = false;
		private var _jumpTimer:int = 30;
		private var _stationaryTimer:int = 30;
		private var _isEditing:Boolean = false;
		private var _boxTouched:Boolean = false;
		private var _boxOnLevel:Box;
		private var _boxOnLevelPosition:Point;
		private var _touchedBox:Box;
		private var _dragDifferenceX:Number;
		private var _dragDifferenceY:Number;
		private var _borders:Rectangle;
		private var _boxIcons:Array = [];
		private var _editButton:Button;
		private var _fadeImage:Image;
		private var _yesBtn:Button;
		private var _noBtn:Button;
		private var _iapText:Image;
		private var _hints:Array = [];
		
		public static const STATE_PLAYING:int = 1;
		public static const STATE_PLAYER_DEAD:int = 2;
		public static const STATE_VICTORY:int = 3;
		public static const STATE_MENU:int = 4;
		public static const STATE_IDLE:int = 5;
		public static var state:int = STATE_IDLE;
		public var starsCatched:int = 0;
		private var revMob:RevMob;
		
		public function Game() 
		{
			_environmentFront = new Sprite();
			_environmentFront.touchable = false;
			_environmentBack = new Sprite();
			_environmentBack.touchable = false;
			_stars = new Sprite();
			_stars.touchable = false;
			_keys = new Sprite();
			_keys.touchable = false;
			_cannons = new Sprite();
			_cannons.touchable = false;
			_doors = new Sprite();
			_doors.touchable = false;
			_btns = new Sprite();
			_btns.touchable = false;
			_cannonBalls = new Sprite();
			_cannonBalls.touchable = false;
			_boxes = new Sprite();
			_tileManager = new TileManager(false);
			_tileManager.touchable = false;
			_player = new Player(0, 0);
			_gui = new Sprite();
			//_clouds = new Sprite();
			//_clouds.touchable = false;
			//_clouds2 = new Sprite();
			//_clouds2.touchable = false;
			
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
			
			PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,onContentDismissed);
			PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,onContentDisplayed);
			PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED, onContentFailed);
			
			revMob = new RevMob(Constants.IOS_APP_ID);
			revMob.printEnvironmentInformation();
			revMob.setTestingMode(false);
			revMob.addEventListener( RevMobAdsEvent.AD_CLICKED, onAdsEvent );
			revMob.addEventListener( RevMobAdsEvent.AD_DISMISS, onAdsEvent );
			revMob.addEventListener( RevMobAdsEvent.AD_DISPLAYED, onAdsEvent );
			revMob.addEventListener( RevMobAdsEvent.AD_NOT_RECEIVED, onAdsEvent );
			revMob.addEventListener( RevMobAdsEvent.AD_RECEIVED, onAdsEvent );
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdsEvent(e:RevMobAdsEvent):void 
		{
			backFromAds();
		}
		
		private function onDismissAdsHandler(e:AirChartboostEvent):void 
		{
			//Constants.tf.text = "Dismissed";
			AirChartboost.getInstance().cacheInterstitial();
			revMob.showFullscreen();
		}
		
		private function onCloseAdsHandler(e:AirChartboostEvent):void 
		{
			//Constants.tf.text = "Closed";
			//showVictory();
			backFromAds();
		}
		
		private function onFailsAdsHandler(e:AirChartboostEvent):void 
		{
			revMob.showFullscreen();
		}
		
		public function showVictory(e:AirChartboostEvent = null):void 
		{
			if (_levelNumber != 40)
			{
				_victory.update(new Point(touch.globalX, touch.globalY));
				if (!_victory.visible)
				{
					SoundManager.muteMusic();
					_soundManager.playSound("Victory");
					starsCatched = 0;
					for (var i:int = 0; i < _stars.numChildren; ++i)
					{
						if (_stars.getChildAt(i) is Star)
							if ((_stars.getChildAt(i) as Star).catched)
								++starsCatched;
					}
					_victory.updateStars(starsCatched);
					_victory.visible = true;
					_victory.start(_player.body.GetPosition().x * _worldScale, _player.body.GetPosition().y * _worldScale);
					_player.visible = false;
					_keys.visible = false;
					dispatchEvent(new CustomEvent(CustomEvent.LEVEL_VICTORY));
				}
			}
			else
			{
				if (!_finalCartoon)
				{
					_finalCartoon = new FinalCartoon();
					_finalCartoon.addEventListener(CustomEvent.LEVEL_SELECT, onLevelSelect);
					addChild(_finalCartoon);
				}
			}
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			setupPhysics();
			
			// Draw background
			_back = new Image(Assets.manager.getTexture("Back1"));
			_back.blendMode = BlendMode.NONE;
			_back.x = 568 * 0.5 - _back.width * 0.5;
			addChild(_back);
			
			// Sprites
			//addChild(_clouds);
			//addChild(_clouds2);
			addChild(_environmentBack);
			addChild(_btns);
			addChild(_doors);
			addChild(_tileManager);
			addChild(_environmentFront);
			addChild(_boxes);
			addChild(_keys);
			addChild(_cannonBalls);
			addChild(_cannons);
			addChild(_stars);
			
			// Player
			
			addChild(_player);
			
			addChild(_gui);
			drawGUI();
			
			_cross = new Image(Assets.manager.getTexture("Cross"));
			_cross.visible = false;
			_cross.touchable = false;
			addChild(_cross);
			
			_victory = new Victory();
			_victory.visible = false;
			_victory.addEventListener(CustomEvent.MAIN_MENU, onLevelSelect);
			_victory.addEventListener(CustomEvent.NEXT_LEVEL, onNextLevel);
			_victory.addEventListener(CustomEvent.RESTART_GAME, onRestart);
			addChild(_victory);
			
			_inGameMenu = new InGameMenu();
			_inGameMenu.visible = false;
			_inGameMenu.addEventListener(CustomEvent.MAIN_MENU, onLevelSelect);
			_inGameMenu.addEventListener(CustomEvent.RESUME_GAME, onResume);
			_inGameMenu.addEventListener(CustomEvent.RESTART_GAME, onRestart);
			addChild(_inGameMenu);
			
			// Listeners
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		private function drawGUI():void 
		{
			_menuButton = new Button(Assets.manager.getTexture("PauseButton2"));
			_menuButton.x = 568 - Constants.x0 - _menuButton.width;
			_menuButton.y = 0;
			_menuButton.addEventListener(Event.TRIGGERED, onMenu);
			addChild(_menuButton);
			
			_restartButton = new Button(Assets.manager.getTexture("ResetButton2"));
			_restartButton.x = Constants.x0;
			_restartButton.y = 0;
			_restartButton.addEventListener(Event.TRIGGERED, onReset);
			addChild(_restartButton);
			
			_leftButton = new Image(Assets.manager.getTexture("LeftButton"));
			_leftButton.x = Constants.x0;
			_leftButton.y = Constants.realHeight - _leftButton.height;
			addChild(_leftButton);
			
			_rightButton = new Image(Assets.manager.getTexture("RightButton"));
			_rightButton.x = Constants.x0 + _leftButton.width;
			_rightButton.y = Constants.realHeight - _rightButton.height;
			addChild(_rightButton);
			
			_jumpButton = new Image(Assets.manager.getTexture("JumpButton"));
			_jumpButton.x = 568 - Constants.x0 - _jumpButton.width;
			_jumpButton.y = Constants.realHeight - _jumpButton.height;
			addChild(_jumpButton);
			
			_editButton = new Button(Assets.manager.getTexture("EditBtn"), "", Assets.manager.getTexture("EditBtn"));
			_editButton.x = Constants.x0;
			_editButton.y = Constants.realHeight - 120;
			_editButton.addEventListener(Event.TRIGGERED, onEdit);
			_editButton.visible = false;
			addChild(_editButton);
		}
		
		private function onEdit(e:Event):void 
		{
			if (_isEditing)
			{
				state = STATE_PLAYING;
				_isEditing = false;
				for (var i:int = 0; i < _boxes.numChildren; i++)
				{
					if ((_boxes.getChildAt(i) as Box).fixed())
					{
						(_boxes.getChildAt(i) as Box).hideArea();
					}
				}
				for (i = _boxIcons.length - 1; i >= 0; --i)
				{
					_gui.removeChild(_boxIcons[i], true);
					_boxIcons[i] = null;
					_boxIcons.splice(i, 1);
				}
			}
			else
			{
				state = STATE_IDLE;
				_isEditing = true;
				var img:Image;
				for (i = 0; i < _boxes.numChildren; i++)
				{
					if ((_boxes.getChildAt(i) as Box).fixed())
					{
						img = new Image(Assets.manager.getTexture((_boxes.getChildAt(i) as Box).name + "Idle0001"));
						_boxIcons.push(img);
						_gui.addChild(img);
						img.x = (_boxes.getChildAt(i) as Box).costumeX - 18;
						img.y = (_boxes.getChildAt(i) as Box).costumeY - 18;
						(_boxes.getChildAt(i) as Box).showArea();
					}
				}
			}
		}
		
		private function canBeEdited():Boolean
		{
			for (var i:int = 0; i < _boxes.numChildren; ++i)
			{
				if ((_boxes.getChildAt(i) as Box).fixed())
				{
					return true;
				}
			}
			return false;
		}
		
		public function loadLevel(xml:XML, levelNumber:int):void
		{
			_levelNumber = levelNumber;
			trace(_levelNumber);
			_soundManager.playMusic("Game", 100000, "Game.loadLevel");
			var physicsNeeded:Boolean = true;
			//if (levelNumber == 20)
			//{
				//physicsNeeded = false;
				//loadPhysics();
			//}
			// Tiles
			for each (var _tile:XML in xml.tiles.tile)
			{
				_tileManager.addTile(_tile.@key, int(_tile.@y / 21), int(_tile.@x / 21), physicsNeeded);
			}
			// Enviroment
			
			var img:Image;
			for each(var _object:XML in xml.environmentFront.object)
			{
				img = new Image(Assets.getAtlasTexture(_object.@key));
				img.x = _object.@x;
				img.y = _object.@y;
				img.name = _object.@key;
				_environmentFront.addChild(img);
			}
			
			for each(_object in xml.environmentBack.object)
			{
				img = new Image(Assets.getAtlasTexture(_object.@key));
				img.x = _object.@x;
				img.y = _object.@y;
				img.name = _object.@key;
				_environmentBack.addChild(img);
			}
			// Objects
			//_boxes = new Sprite();
			
			for each(_object in xml.objects.object)
			{
				var str:String = _object.@key;
				var X:Number = _object.@x;
				var Y:Number = _object.@y;
				switch (str)
				{
					case "StarBlinking0001":
					{
						var star:Star = new Star(X + 12, Y + 12);
						_stars.addChild(star);
						break;
					}
					case "Player":
					{
						_startingPosition = new Point(X + 15, Y + 15);
						_player.setStartingPoint(_startingPosition);
						_player.reset();
						break;
					}
					case "Box":
					{
						_boxOnLevel = new Box(X, Y, Box.USUAL);
						_boxes.addChild(_boxOnLevel);
						_boxOnLevelPosition = new Point(X, Y);
						break;
					}
					case "Hint":
					{
						var hint:Image = new Image(Assets.manager.getTexture("Frame"));
						hint.x = X;
						hint.y = Y;
						hint.touchable = false;
						hint.visible = false;
						_hints.push(hint);
						_stars.addChild(hint);
						break;
					}
					default:
					{
						if (str.search("Key") != -1)
						{
							var key:Key = new Key(X, Y, str);
							_keys.addChild(key);
						}
						else if (str.search("Cannon") != -1)
						{
							if (str.search("Cannon1") != -1)
								var cannon:Cannon = new Cannon(X-10, Y, str, _cannonBalls);
							else
								cannon = new Cannon(X, Y-20, str, _cannonBalls);
							_cannons.addChild(cannon);
						}
						else if (str.search("Door") != -1)
						{
							var doorKind:int;
							var angle:Number = _object.@rotation;
							if (Math.round(Math.sin(angle)) == 0)
							{
								if (Math.round(Math.cos(angle)) == 1)
								{
									doorKind = 0; // 0
								}
								else
								{
									doorKind = 2; // 180
								}
							}
							else
							{
								if (Math.round(Math.sin(angle)) == 1)
								{
									doorKind = 3; // 270
								}
								else
								{
									doorKind = 1; // 90
								}
							}
							var door:Door = new Door(X, Y, 20, 80, str, doorKind);
							_doors.addChild(door);
						}
						else if (str.search("Platform") != -1)
						{
							img = new Image(Assets.getAtlasTexture(str));
							img.pivotX += 17;
							img.pivotY += 6;
							img.x = X;
							img.y = Y;
							img.rotation = _object.@rotation;
							_environmentFront.addChild(img);
						}
						else if (str.search("FullButton") != -1)
						{
							angle = _object.@rotation;
							var btn:Btn= new Btn(X, Y, 34, 12, angle, str, _environmentFront);
							_btns.addChild(btn);
						}
						else if (str.search("Tutorial") != -1)
						{
							img = new Image(Assets.getAtlasTexture(str));
							img.x = X;
							img.y = Y;
							if (str == "Tutorial6-1")
							{
								img.x = Constants.x0;
								if (Constants.realHeight == 384)
								{
									img.x = Constants.x0 + 100;
									img.y = 275;
								}
							}
							if (str == "Tutorial2-1")
								img.y = Constants.realHeight - 120;
							_environmentFront.addChild(img);
						}
						else if (str.search("Arrow") != -1)
						{
							img = new Image(Assets.getAtlasTexture(str));
							img.x = X;
							img.y = Y;
							if (_levelNumber == 6)
							{
								img.x = Constants.x0;
								if (Constants.realHeight == 384)
								{
									img.rotation = Math.PI * 0.5;
									img.x = Constants.x0 + 90;
									img.y = 262;
								}
							}
							if (_levelNumber == 2)
								img.y = Constants.realHeight - 100;
							_environmentFront.addChild(img);
						}
						else if (str.search("Lantern") != -1)
						{
							var mc:MovieClip = new MovieClip(Assets.manager.getTextures("Lantern"));
							mc.x = X;
							mc.y = Y;
							Starling.juggler.add(mc);
							addChild(mc);
						}
						else
						{
							img = new Image(Assets.getAtlasTexture(str));
							img.x = X;
							img.y = Y;
							_stars.addChild(img);
						}
						break;
					}
				}
			}
			var kind:int;
			for (var i:int = 0; i < _doors.numChildren; ++i)
			{
				kind = (_doors.getChildAt(i) as Door).kind;
				for (var j:int = 0; j < _btns.numChildren; ++j)
				{
					if ((_btns.getChildAt(j) as Btn).kind == kind)
					{
						(_doors.getChildAt(i) as Door).btn = _btns.getChildAt(j) as Btn;
						break;
					}
				}
			}
			i = 0;
			for each (var box:XML in xml.boxes.box)
			{
				str = box.@kind;
				_startingBoxes[i] = int(str);
				++i;
			}
			for (j = i; j < 3; ++j)
			{
				_startingBoxes[j] = 0;
			}
			
			drawBoxButtons();
			//drawClouds();
			
			//_clouds.flatten();
			//_clouds2.flatten();
			_environmentBack.flatten();
			_tileManager.flatten();
			_environmentFront.flatten();
			
			_keys.visible = true;
			_player.visible = true;
			if (_boxes.numChildren > 0)
				_editButton.visible = true;
			else
				_editButton.visible = false;
		}
		
		private function loadPhysics():void 
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(0 / PhysicWorld.SCALE, 0 / PhysicWorld.SCALE);
			//bodyDef.userData = key;
			
			body = PhysicWorld.world.CreateBody(bodyDef);
			body.SetSleepingAllowed(true);
			body.SetAwake(false);
			//trace(key);
			var ptm_ratio:Number = 60;
			var arr:Array = [
			[   new b2Vec2(370/ptm_ratio, 216.5/ptm_ratio)  ,  new b2Vec2(363/ptm_ratio, 106/ptm_ratio)  ,  new b2Vec2(411/ptm_ratio, 166.5/ptm_ratio)  ,  new b2Vec2(409.5/ptm_ratio, 212/ptm_ratio)  ,  new b2Vec2(388.5/ptm_ratio, 234.5/ptm_ratio)  ] ,
			[   new b2Vec2(419.5/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(365/ptm_ratio, 45/ptm_ratio)  ,  new b2Vec2(349/ptm_ratio, 2/ptm_ratio)  ] ,
			[   new b2Vec2(363/ptm_ratio, 106/ptm_ratio)  ,  new b2Vec2(365/ptm_ratio, 45/ptm_ratio)  ,  new b2Vec2(419.5/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(411/ptm_ratio, 166.5/ptm_ratio)  ],
			[   new b2Vec2(784/ptm_ratio, 349/ptm_ratio)  ,  new b2Vec2(838/ptm_ratio, 247/ptm_ratio)  ,  new b2Vec2(832/ptm_ratio, 378/ptm_ratio)  ,  new b2Vec2(786/ptm_ratio, 379/ptm_ratio)  ] ,
			[   new b2Vec2(769/ptm_ratio, 295/ptm_ratio)  ,  new b2Vec2(752/ptm_ratio, 347/ptm_ratio)  ,  new b2Vec2(712/ptm_ratio, 355/ptm_ratio)  ,  new b2Vec2(689/ptm_ratio, 347/ptm_ratio)  ,  new b2Vec2(685/ptm_ratio, 296/ptm_ratio)  ] ,
			[   new b2Vec2(868.5/ptm_ratio, 200/ptm_ratio)  ,  new b2Vec2(934/ptm_ratio, 245/ptm_ratio)  ,  new b2Vec2(838/ptm_ratio, 247/ptm_ratio)  ,  new b2Vec2(821/ptm_ratio, 239/ptm_ratio)  ,  new b2Vec2(838/ptm_ratio, 202/ptm_ratio)  ] ,
			[   new b2Vec2(890.5/ptm_ratio, 153.5/ptm_ratio)  ,  new b2Vec2(965/ptm_ratio, 156/ptm_ratio)  ,  new b2Vec2(934/ptm_ratio, 245/ptm_ratio)  ,  new b2Vec2(868.5/ptm_ratio, 200/ptm_ratio)  ,  new b2Vec2(869.5/ptm_ratio, 170/ptm_ratio)  ] ,
			[   new b2Vec2(221.5/ptm_ratio, 455/ptm_ratio)  ,  new b2Vec2(226.5/ptm_ratio, 492.5/ptm_ratio)  ,  new b2Vec2(168/ptm_ratio, 589/ptm_ratio)  ,  new b2Vec2(168/ptm_ratio, 410/ptm_ratio)  ] ,
			[   new b2Vec2(407/ptm_ratio, 506/ptm_ratio)  ,  new b2Vec2(407/ptm_ratio, 548/ptm_ratio)  ,  new b2Vec2(392/ptm_ratio, 547/ptm_ratio)  ,  new b2Vec2(392/ptm_ratio, 507/ptm_ratio)  ] ,
			[   new b2Vec2(327/ptm_ratio, 547/ptm_ratio)  ,  new b2Vec2(168/ptm_ratio, 589/ptm_ratio)  ,  new b2Vec2(226.5/ptm_ratio, 492.5/ptm_ratio)  ,  new b2Vec2(306/ptm_ratio, 506/ptm_ratio)  ] ,
			[   new b2Vec2(821/ptm_ratio, 239/ptm_ratio)  ,  new b2Vec2(838/ptm_ratio, 247/ptm_ratio)  ,  new b2Vec2(784/ptm_ratio, 349/ptm_ratio)  ,  new b2Vec2(769/ptm_ratio, 295/ptm_ratio)  ,  new b2Vec2(793/ptm_ratio, 245/ptm_ratio)  ] ,
			[   new b2Vec2(769/ptm_ratio, 295/ptm_ratio)  ,  new b2Vec2(784/ptm_ratio, 349/ptm_ratio)  ,  new b2Vec2(752/ptm_ratio, 347/ptm_ratio)  ] ,
			[   new b2Vec2(965/ptm_ratio, 590/ptm_ratio)  ,  new b2Vec2(933/ptm_ratio, 548/ptm_ratio)  ,  new b2Vec2(934/ptm_ratio, 245/ptm_ratio)  ,  new b2Vec2(965/ptm_ratio, 156/ptm_ratio)  ] ,
			[   new b2Vec2(965/ptm_ratio, 590/ptm_ratio)  ,  new b2Vec2(168/ptm_ratio, 589/ptm_ratio)  ,  new b2Vec2(407/ptm_ratio, 548/ptm_ratio)  ,  new b2Vec2(933/ptm_ratio, 548/ptm_ratio)  ] ,
			[   new b2Vec2(327/ptm_ratio, 547/ptm_ratio)  ,  new b2Vec2(392/ptm_ratio, 547/ptm_ratio)  ,  new b2Vec2(407/ptm_ratio, 548/ptm_ratio)  ,  new b2Vec2(168/ptm_ratio, 589/ptm_ratio)  ],
			[   new b2Vec2(344/ptm_ratio, 385/ptm_ratio)  ,  new b2Vec2(320.5/ptm_ratio, 397.5/ptm_ratio)  ,  new b2Vec2(300/ptm_ratio, 378/ptm_ratio)  ,  new b2Vec2(300/ptm_ratio, 338/ptm_ratio)  ,  new b2Vec2(345/ptm_ratio, 338/ptm_ratio)  ],
			[   new b2Vec2(585/ptm_ratio, 171/ptm_ratio)  ,  new b2Vec2(562/ptm_ratio, 423/ptm_ratio)  ,  new b2Vec2(539/ptm_ratio, 454/ptm_ratio)  ,  new b2Vec2(512/ptm_ratio, 414/ptm_ratio)  ,  new b2Vec2(514/ptm_ratio, 171/ptm_ratio)  ] ,
			[   new b2Vec2(682/ptm_ratio, 454/ptm_ratio)  ,  new b2Vec2(539/ptm_ratio, 454/ptm_ratio)  ,  new b2Vec2(562/ptm_ratio, 423/ptm_ratio)  ,  new b2Vec2(729/ptm_ratio, 421/ptm_ratio)  ],
			[   new b2Vec2(739/ptm_ratio, 1/ptm_ratio)  ,  new b2Vec2(728/ptm_ratio, 168/ptm_ratio)  ,  new b2Vec2(680/ptm_ratio, 166/ptm_ratio)  ,  new b2Vec2(675/ptm_ratio, 1/ptm_ratio)  ]
			];
			for (var i:int = 0; i < arr.length; ++i)
			{
				var shape:b2PolygonShape = new b2PolygonShape();
				shape.SetAsArray(arr[i], arr[i].length);
				
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.density = 1;
				fixtureDef.friction = 0.2;
				fixtureDef.restitution = 0.0;
				fixtureDef.shape = shape;
				fixtureDef.filter.categoryBits = Category.PLATFORM;
				//fixtureDef.filter.maskBits
				body.CreateFixture(fixtureDef);
			}
		}
		
		private function drawClouds():void 
		{
			//var key:String;
			//for (var i:int = 0; i < 4; ++i)
			//{
				//for (var j:int = 0; j < 3; ++j)
				//{
					//if (Math.random() < 0.75)
					//{
						//key = "Cloud" + String(1 + Math.round(Math.random() * 12));
						//var cloud:Image = new Image(Assets.getAtlasTexture(key));
						//cloud.x = 190 * j - 95 * (i % 2) + Math.round(Math.random() * 10);
						//cloud.y = -30 + 100 * i + Math.round(Math.random() * 10);
						//_clouds.addChild(cloud);
						//
						//var cloud2:Image = new Image(Assets.getAtlasTexture(key));
						//cloud2.x = cloud.x;
						//cloud2.y = cloud.y;
						//_clouds2.addChild(cloud2);
					//}
				//}
			//}
			//_clouds2.x = 568;
		}
		
		private function drawBoxButtons():void
		{
			for (i = 0; i < 3; ++i)
			{
				var guiback:Image = new Image(Assets.manager.getTexture("GUIBack"));
				guiback.x = 229 + 45 * i;
				guiback.y = Constants.realHeight - 40 - 15;
				guiback.touchable = false;
				_gui.addChild(guiback);
			}
			
			for (var i:int = 0; i < 3; ++i)
			{
				switch (_startingBoxes[i])
				{
					case 0:
					{
						
						break;
					}
					case 1:
					{
						var icon:Image = new Image(Assets.manager.getTexture("BoxIdle0001"));
						break;
					}
					case 2:
					{
						icon = new Image(Assets.manager.getTexture("JumpingBoxIdle0001"));
						break;
					}
					case 3:
					{
						icon = new Image(Assets.manager.getTexture("FlyingBoxIdle0001"));
						break;
					}
				}
				if (icon)
				{
					icon.name = String(_startingBoxes[i]);
					icon.x = 231 + 45 * i;
					icon.y = Constants.realHeight - 38 - 15;
					_gui.addChild(icon);
					_icons[i] = icon;
					icon = null;
				}
			}
		}
		
		private function setupPhysics():void 
		{
			var playerContactListener:PlayerContactListener = new PlayerContactListener();
			_world.SetContactListener(playerContactListener);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 37 :
				{
					_left = true;
					break;
				}
				case 39 :
				{	
					_right = true;
					break;
				}
				case 38:
				{	
					_jump = true;
					break;
				}
				case Keyboard.A:
				{
					_left = true;
					break;
				}
				case Keyboard.D:
				{	
					_right = true;
					break;
				}
				case Keyboard.W:
				{	
					_jump = true;
					break;
				}
				case Keyboard.R:
				{
					onRestart(null);
					break;
				}
				case Keyboard.ESCAPE:
				{
					if (_inGameMenu.visible)
					{
						onResume(null);
					}
					else
					{
						onMenu(null);
					}
					break;
				}
				case Keyboard.H:
				{
					for (var i:int = 0; i < _hints.length; ++i)
					{
						_hints[i].visible = true;
					}
					break;
				}
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 37 :
				{
					_left = false;
					break;
				}
				case 39 :
				{
					_right = false;
					break;
				}
				case 38:
				{	
					_jump = false;
					break;
				}	
				case Keyboard.A:
				{
					_left = false;
					break;
				}
				case Keyboard.D:
				{
					_right = false;
					break;
				}
				case Keyboard.W:
				{	
					_jump = false;
					break;
				}	
			}
		}
		
		private function canBeCreated(touchP:Point):Boolean
		{
			_canBeCreated = true;
			var half:Number = 18;
			var point1:b2Vec2 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y - half) / _worldScale);
			var point2:b2Vec2 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y - half) / _worldScale);
			_world.RayCast(checkBoxCreation, point1, point2);
			if (_canBeCreated)
			{
				point1 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y - half) / _worldScale);
				point2 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y + half) / _worldScale);
				_world.RayCast(checkBoxCreation, point1, point2);
			}
			if (_canBeCreated)
			{
				point1 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y + half) / _worldScale);
				point2 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y + half) / _worldScale);
				_world.RayCast(checkBoxCreation, point1, point2);
			}
			if (_canBeCreated)
			{
				point1 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y + half) / _worldScale);
				point2 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y - half) / _worldScale);
				_world.RayCast(checkBoxCreation, point1, point2);
			}
			if (_canBeCreated)
			{
				point1 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y - half) / _worldScale);
				point2 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y + half) / _worldScale);
				_world.RayCast(checkBoxCreation, point1, point2);
			}
			if (_canBeCreated)
			{
				point1 = new b2Vec2((touchP.x + half) / _worldScale, (touchP.y - half) / _worldScale);
				point2 = new b2Vec2((touchP.x - half) / _worldScale, (touchP.y + half) / _worldScale);
				_world.RayCast(checkBoxCreation, point1, point2);
			}
			if (_canBeCreated)
			{
				_canBeCreated = checkBackTiles();
			}
			
			return _canBeCreated;
		}
		
		private function checkBackTiles():Boolean
		{
			var img:Image;
			for (var i:int = 0; i < _environmentBack.numChildren; ++i)
			{
				img = _environmentBack.getChildAt(i) as Image;
				if (img.name.search("BackTile") != -1)
				{
					if (_selection.bounds.intersects(img.bounds))
					{
						//trace("false");
						return false;
					}
				}
			}
			
			return true;
		}
		
		private function checkBoxCreation(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number
		{
			_canBeCreated = false;
			//trace(point.x, point.y);
			return 0;
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			touches = e.touches;
			for (var i:int = 0; i < touches.length; i++)
			{
				touch = touches[i];
				if (touch.phase == TouchPhase.BEGAN)
				{
					//trace(touch.target, touch.target.parent);
					if (!(touch.target is Stage))
					{
						if (touch.target.parent == _gui) // Click on box's icon
						{
							if (_isEditing)
							{
								_selection = null;
								_touchedBox = null;
								_borders = null;
								for (var j:int = 0; j < _boxes.numChildren; ++j)
								{
									if (touch.target.x == (_boxes.getChildAt(j) as Box).costumeX - 18 && touch.target.y == (_boxes.getChildAt(j) as Box).costumeY - 18)
									{
										_selection = touch.target as Image;
										_touchedBox = _boxes.getChildAt(j) as Box;
										_touchedBox.body.SetActive(false);
										_borders = (_boxes.getChildAt(j) as Box).getBorders();
										_dragDifferenceX = _selection.x - touch.globalX;
										_dragDifferenceY = _selection.y - touch.globalY;
										_buttonOldPoint = new Point(_selection.x, _selection.y);
										break;
									}
								}
							}
							else
							{
								_isPlacingBox = false;
								if (_buttonOldPoint)
								{
									
								}
								else
								{
									_selection = touch.target as Image;
									_buttonOldPoint = new Point(_selection.x, _selection.y);
									Starling.juggler.tween(_selection, 0.1, 
									{
										x: touch.globalX - 18,
										y: touch.globalY - 18 - 75,
										transition: Transitions.EASE_IN
									});
									_isPlacingBox = true;
								}
							}
						}
						else if (touch.target.parent is Box)
						{
							if ((touch.target.parent as Box).fixed())
							{
								(touch.target.parent as Box).onTap();
								if (!canBeEdited())
								{
									_editButton.visible = false;
								}
							}
						}
						else if (touch.target == _leftButton)
						{
							_left = true;
						}
						else if (touch.target == _rightButton)
						{
							_right = true;
						}
						else if (touch.target == _jumpButton)
						{
							_jump = true;
						}
						else if (touch.target == _restartButton)
						{
							//
						}
						else if (touch.target == _menuButton)
						{
							//
						}
					}
				}
				if (touch.phase == TouchPhase.MOVED)
				{
					if (_isEditing)
					{
						if (_selection)
						{
							if (touch.globalX + _dragDifferenceX >= _borders.x)
							{
								if (touch.globalX + _dragDifferenceX <= _borders.x + 32)
								{
									_selection.x = touch.globalX + _dragDifferenceX;
								}
								else
								{
									_selection.x = _borders.x + 32;
								}
							}
							else
							{
								_selection.x = _borders.x;
							}
							
							if (touch.globalY + _dragDifferenceY >= _borders.y)
							{
								if (touch.globalY + _dragDifferenceY <= _borders.y + 32)
								{
									_selection.y = touch.globalY + _dragDifferenceY;
								}
								else
								{
									_selection.y = _borders.y + 32;
								}
							}
							else
							{
								_selection.y = _borders.y;
							}
							
							if (canBeCreated(new Point(_selection.x + 18, _selection.y + 18)))
							{
								_cross.visible = false;
							}
							else
							{
								_cross.visible = true;
								_cross.x = _selection.x;
								_cross.y = _selection.y;
							}
						}
					}
					else if (_selection && _isPlacingBox && touch.target != _leftButton && touch.target != _rightButton && touch.target != _jumpButton)
					{
						_selection.x = touch.globalX - 18;
						_selection.y = touch.globalY - 18 - 75;
						if (canBeCreated(new Point(_selection.x + 18, _selection.y + 18)))
						{
							_cross.visible = false;
							_cross.x = _selection.x;
							_cross.y = _selection.y;
						}
						else
						{
							_cross.visible = true;
							_cross.x = _selection.x;
							_cross.y = _selection.y;
						}
					}
					else if (touch.globalX < Constants.x0 + 160 && touch.globalY > Constants.realHeight - 70)
					{
						if (touch.globalX < Constants.x0 + 80)
						{
							_right = false;
							_left = true;
						}
						else
						{
							_right = true;
							_left = false;
						}
					}
					else
					{
						_right = false;
						_left = false;
					}
				}
				if (touch.phase == TouchPhase.ENDED)
				{
					if (touch.target.parent is Box)
					{
						trace("NEVER NEVER EVER");
						_boxTouched = false;
						if (_isEditing)
						{
							_isEditing = false;
							if (canBeCreated(new Point(_selection.x + 18, _selection.y + 18)))
							{
								
							}
							else
							{
								switch (_selection.name)
								{
									case "Box":
									{
										_soundManager.playSound("Voice1");
										break;
									}
									case "JumpingBox":
									{
										_soundManager.playSound("Voice2");
										break;
									}
									case "FlyingBox":
									{
										_soundManager.playSound("Voice3");
										break;
									}
								}
								_cross.visible = false;
								_selection.x = _buttonOldPoint.x;
								_selection.y = _buttonOldPoint.y;
							}
							(touch.target.parent as Box).body.SetPosition(new b2Vec2((_selection.x + 18) / _worldScale, (_selection.y + 18) / _worldScale));
							(touch.target.parent as Box).hideArea();
							
							_gui.removeChild(_selection, true);
							_soundManager.playSound("BuildBox");
							(touch.target.parent as Box).showFX();
							_selection = null;
							_buttonOldPoint = null;
						}
					}
					else if (touch.target == _leftButton)
					{
						_left = false;
					}
					else if (touch.target == _rightButton)
					{
						_right = false;
					}
					else if (touch.target == _jumpButton)
					{
						_jump = false;
					}
					else if (_selection)
					{
						if (_isPlacingBox)
						{
							if (canBeCreated(new Point(_selection.x + 18, _selection.y + 18)))
							{
								var box:Box = new Box(_selection.x + 18, _selection.y + 18, int(_selection.name));
								_boxes.addChild(box);
								_gui.removeChild(_selection, true);
								_soundManager.playSound("BuildBox");
								box.showFX();
								
								if (canBeEdited())
								{
									_editButton.visible = true;
								}
							}
							else
							{
								switch (int(_selection.name))
								{
									case 1:
									{
										_soundManager.playSound("Voice1");
										break;
									}
									case 2:
									{
										_soundManager.playSound("Voice2");
										break;
									}
									case 3:
									{
										_soundManager.playSound("Voice3");
										break;
									}
								}
								_cross.visible = false;
								_selection.touchable = false;
								var tween:Tween = new Tween(_selection, 0.5, Transitions.LINEAR);
								tween.moveTo(_buttonOldPoint.x, _buttonOldPoint.y);
								tween.animate("rotation", -Math.PI * 2);
								tween.onComplete = tweenCompleted;
								tween.onCompleteArgs = [_selection];
								Starling.juggler.add(tween);
							}
							_selection = null;
							_buttonOldPoint = null;
							_isPlacingBox = false;
						}
						if (_isEditing)
						{
							if (canBeCreated(new Point(_selection.x + 18, _selection.y + 18)))
							{
								
							}
							else
							{
								switch (_selection.name)
								{
									case "Box":
									{
										_soundManager.playSound("Voice1");
										break;
									}
									case "JumpingBox":
									{
										_soundManager.playSound("Voice2");
										break;
									}
									case "FlyingBox":
									{
										_soundManager.playSound("Voice3");
										break;
									}
								}
								_cross.visible = false;
								_selection.x = _buttonOldPoint.x;
								_selection.y = _buttonOldPoint.y;
							}
							_touchedBox.moveBody((_selection.x + 18) / _worldScale, (_selection.y + 18) / _worldScale);
							_gui.removeChild(_selection, true);
							_soundManager.playSound("BuildBox");
							onEdit(null);
							_touchedBox.showFX();
							_touchedBox.body.SetActive(true);
							_selection = null;
							_buttonOldPoint = null;
							_touchedBox = null;
						}
					}
					if (touch.globalX < Constants.x0 + 160 && touch.globalY > Constants.realHeight - 70)
					{
						{
							_right = false;
							_left = false;
						}
					}
				}
			}
		}
		
		public function reset(callingFrom:String = "unknown"):void 
		{
			_victory.visible = false;
			_inGameMenu.visible = false;
			_isEditing = false;
			_stationaryTimer = 30;
			_player.visible = true;
			_keys.visible = true;
			_editButton.visible = false;
			
			if (_deadPlayer)
			{
				_fallingBody.DestroyFixture(_fallingBody.GetFixtureList());
				_world.DestroyBody(_fallingBody);
				_fallingBody = null;
				_gui.removeChild(_deadPlayer, true);
				_deadPlayer = null;
			}
			
			SoundManager.unmuteMusic();
			_soundManager.playMusic("Game", 100000, "Game.reset");
			changeState(STATE_PLAYING, "reset2");
			_paused = false;
			_cross.visible = false;
			
			_player.alive();
			_player.reset();
			
			_selection = null;
			_buttonOldPoint = null;
			
			_boxes.removeChildren(0, -1, true);
			if (_boxOnLevelPosition)
			{
				_boxOnLevel = new Box(_boxOnLevelPosition.x, _boxOnLevelPosition.y, Box.USUAL);
				_boxes.addChild(_boxOnLevel);
				_editButton.visible = true;
			}
			for (var i:int = 0; i < _doors.numChildren; i++)
			{
				(_doors.getChildAt(i) as Door).reset();
			}
			for (i = 0; i < _btns.numChildren; i++)
			{
				(_btns.getChildAt(i) as Btn).reset();
			}
			for (i = 0; i < _stars.numChildren; i++)
			{
				if (_stars.getChildAt(i) is Star)
					(_stars.getChildAt(i) as Star).reset();
			}
			for (i = 0; i < _cannons.numChildren; ++i)
			{
				(_cannons.getChildAt(i) as Cannon).resetTimer();
			}
			_cannonBalls.removeChildren(0, -1, true);
			_gui.removeChildren(0, -1, true);
			for (i = 0; i < _icons.length; ++i)
			{
				_icons[i] = null;
			}
			drawBoxButtons();
		}
		
		public function clearLevel():void
		{
			//state = STATE_PLAYING;
			_environmentBack.removeChildren(0, -1, true);
			_environmentFront.removeChildren(0, -1, true);
			_boxes.removeChildren(0, -1, true);
			_cannons.removeChildren(0, -1, true);
			_cannonBalls.removeChildren(0, -1, true);
			_keys.removeChildren(0, -1, true);
			_doors.removeChildren(0, -1, true);
			_btns.removeChildren(0, -1, true);
			_stars.removeChildren(0, -1, true);
			_gui.removeChildren(0, -1, true);
			//_clouds.removeChildren(0, -1, true);
			//_clouds2.removeChildren(0, -1, true);
			for (i = 0; i < _hints.length; ++i)
			{
				_hints[i] = null;
			}
			_hints = [];
			for (var i:int = 0; i < _icons.length; ++i)
			{
				_icons[i] = null;
			}
			_boxOnLevelPosition = null;
			_tileManager.clearTiles();
		}
		
		override public function dispose():void 
		{
			removeChild(_back, true);
			_player.dispose();
			_environmentBack.removeChildren(0, -1, true);
			_environmentFront.removeChildren(0, -1, true);
			_boxes.removeChildren(0, -1, true);
			_cannons.removeChildren(0, -1, true);
			_cannonBalls.removeChildren(0, -1, true);
			_keys.removeChildren(0, -1, true);
			_doors.removeChildren(0, -1, true);
			_btns.removeChildren(0, -1, true);
			_stars.removeChildren(0, -1, true);
			
			_tileManager.clearTiles();
			removeChild(_tileManager, true);
			super.dispose();
		}
		
		private function checkJumpAvailability(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number
		{
			_canJump = true;
			
			return 0;
		}
		
		private function handleControls():void
		{
			if (_left)
			{
				_direction = "Left";
				_player.direction = _direction;
				if (_player.connectedBodies.length > 0)
				{
					_flyingTimer = 0;
					//_player.body.SetAngularVelocity( -4); // !!!
					_player.body.SetLinearVelocity(new b2Vec2(-3, _player.body.GetLinearVelocity().y));
					_player.switchAnimation("PlayerRunningLeft");
				}
				else
				{
					if (Math.abs(_player.body.GetLinearVelocity().x) <= 3)
					{
						++_flyingTimer;
						if (_flyingTimer > 2)
						{
							_player.body.ApplyForce(new b2Vec2( -12, 0), _player.body.GetPosition());
							if (_player.body.GetLinearVelocity().y < 1)
								_player.switchAnimation("PlayerJumpingLeft");
							else
								_player.switchAnimation("PlayerFallingLeft");
						}
					}
				}
			}
			if (_right)
			{
				_direction = "Right";
				_player.direction = _direction;
				if (_player.connectedBodies.length > 0)
				{
					_flyingTimer = 0;
					//_player.body.SetAngularVelocity(4); // !!!
					_player.body.SetLinearVelocity(new b2Vec2(3, _player.body.GetLinearVelocity().y)); // !!!
					_player.switchAnimation("PlayerRunningRight");
				}
				else
				{
					if (Math.abs(_player.body.GetLinearVelocity().x) <= 3)
					{
						++_flyingTimer;
						if (_flyingTimer > 2)
						{
							_player.body.ApplyForce(new b2Vec2( 12, 0), _player.body.GetPosition());
							if (_player.body.GetLinearVelocity().y < 1)
								_player.switchAnimation("PlayerJumpingRight");
							else
								_player.switchAnimation("PlayerFallingRight");
						}
					}
				}
			}
			if (_isJumping)
			{
				--_jumpTimer;
				if (_jumpTimer < 0)
				{
					_jumpTimer = 10;
					_isJumping = false;
				}
			}
			if (_jump)
			{
				_canJump = false;
				if (_player.connectedBodies.length > 0)
				{
					//trace("jump");
					var rayCastPoint:b2Vec2 = new b2Vec2(_player.body.GetPosition().x, _player.body.GetPosition().y + 15.5 / _worldScale);
					_world.RayCast(checkJumpAvailability, _player.body.GetPosition(), rayCastPoint);
					if (!_canJump)
					{
						rayCastPoint = new b2Vec2(_player.body.GetPosition().x + 10 / _worldScale, _player.body.GetPosition().y + 15.5 / _worldScale);
						_world.RayCast(checkJumpAvailability, _player.body.GetPosition(), rayCastPoint);
					}
					if (!_canJump)
					{
						rayCastPoint = new b2Vec2(_player.body.GetPosition().x - 10 / _worldScale, _player.body.GetPosition().y + 15.5 / _worldScale);
						_world.RayCast(checkJumpAvailability, _player.body.GetPosition(), rayCastPoint);
					}
				}
				else if (_player.connectedBodies2.length > 0)
				{
					//trace(1111);
					var index:int = 0;
					var sign:Number = 1;
					var dx:Number;
					var dy:Number;
					if (_player.connectedBodies2.length > 0)
					{
						for (var k:int = 0; k < _player.connectedBodies2.length; ++k)
						{
							dy = _player.body.GetPosition().y - _player.contactPoints[k].y;
							dx = _player.body.GetPosition().x - _player.contactPoints[k].x;
							sign *= dx;
							//trace(dx, dy);
							if (dy < 0.5)
								++index;
						}
					}
					//trace(index);
					if (index == 2 && sign < 0)
					{
						_canJump = true;
					}
				}
				if (_canJump && !_isJumping)
				{
					_isJumping = true;
					_soundManager.playSound("Jump");
					//trace(_player.body.GetLinearVelocity().x, _player.body.GetLinearVelocity().y, _player.body.GetAngularVelocity());
					_player.body.SetAngularVelocity(0);
					_player.body.SetLinearVelocity(new b2Vec2(_player.body.GetLinearVelocity().x, 0));
					_player.body.ApplyImpulse(new b2Vec2(0, -4), _player.body.GetPosition());
				}
			}
			if (!_right && !_left)
			{
				_player.body.SetAngularVelocity(0);
				if (_player.connectedBodies.length > 0)
				{
					_player.switchAnimation("PlayerIdle");
				}
				else
				{
					if (_player.body.GetLinearVelocity().y < 1)
						_player.switchAnimation("PlayerJumping" + _direction);
					else
						_player.switchAnimation("PlayerFalling" + _direction);
				}
			}
		}
		
		private function updateObjects(passedTime:Number):void
		{
			_player.update(_fixedTimestepAccumulatorRatio);
			
			for (var i:int = 0; i < _btns.numChildren; i++)
			{
				(_btns.getChildAt(i) as Btn).update(_fixedTimestepAccumulatorRatio);
			}
			
			for (i = 0; i < _doors.numChildren; i++)
			{
				(_doors.getChildAt(i) as Door).update(_fixedTimestepAccumulatorRatio);
			}
			
			for (i = 0; i < _boxes.numChildren; i++)
			{
				(_boxes.getChildAt(i) as Box).update(_fixedTimestepAccumulatorRatio, passedTime);
			}
			
			for (i = 0; i < _cannonBalls.numChildren; i++)
			{
				(_cannonBalls.getChildAt(i) as CannonBall).update(_fixedTimestepAccumulatorRatio);
			}
		}
		
		private function resetObjects():void 
		{
			_player.resetPosition();
			
			for (var i:int = 0; i < _btns.numChildren; i++)
			{
				(_btns.getChildAt(i) as Btn).resetPosition();
			}
			
			for (i = 0; i < _doors.numChildren; i++)
			{
				(_doors.getChildAt(i) as Door).resetPosition();
			}
			
			for (i = 0; i < _boxes.numChildren; i++)
			{
				(_boxes.getChildAt(i) as Box).resetPosition();
			}
			
			for (i = 0; i < _cannonBalls.numChildren; i++)
			{
				(_cannonBalls.getChildAt(i) as CannonBall).resetPosition();
			}
		}
		
		private function update(e:EnterFrameEvent):void 
		{
			switch (state)
			{
				case STATE_PLAYING:
				{
					if (!_paused)
					{
						_fixedTimestepAccumulator += e.passedTime;
						const nSteps:int = Math.floor(_fixedTimestepAccumulator / FIXED_TIMESTEP);
						
						if (nSteps > 0)
						{
							_fixedTimestepAccumulator -= nSteps * FIXED_TIMESTEP;
						}
						_fixedTimestepAccumulatorRatio = _fixedTimestepAccumulator / FIXED_TIMESTEP;
						const nStepsClamped:int = Math.min(nSteps, MAX_STEPS);
						
						for (var i:int = 0; i < nStepsClamped; ++i)
						{
							handleControls();
							if (i == nStepsClamped - 1)
								resetObjects();
							_world.Step(FIXED_TIMESTEP, 8, 2);
							_world.ClearForces();
						}
						//trace(e.passedTime, nSteps, nStepsClamped, _fixedTimestepAccumulator);
						updateObjects(e.passedTime);
						_player.updateCostume(e.passedTime);
						
						for (i = 0; i < _keys.numChildren; i++)
						{
							(_keys.getChildAt(i) as Key).update();
						}
						
						for (i = 0; i < _cannons.numChildren; i++)
						{
							(_cannons.getChildAt(i) as Cannon).update(e.passedTime);
						}
						
						for (i = _cannonBalls.numChildren - 1; i >= 0; --i)
						{
							if ((_cannonBalls.getChildAt(i) as CannonBall).outOfArea)
							{
								_cannonBalls.removeChildAt(i, true);
							}
						}
						
						for (i = 0; i < _stars.numChildren; ++i)
						{
							if (_stars.getChildAt(i) is Star)
								(_stars.getChildAt(i) as Star).update(e.passedTime);
						}
						
						if (_player.body.GetPosition().y * _worldScale > 550)
						{
							state = STATE_IDLE;
							_soundManager.playSound("Fail");
							showAds();
							dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
						}
						
						if (_player.body.GetPosition().y * _worldScale < -100)
						{
							state = STATE_IDLE;
							_soundManager.playSound("Fail");
							showAds();
							dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
						}
					}
					break;
				}
				case STATE_VICTORY:
				{
					if (_levelNumber == 20)
					{
						if (!IAP.purchased)
						{
							if (!_fadeImage)
							{
								_fadeImage = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
								_fadeImage.alpha = 0.75;
								_yesBtn = new Button(Assets.manager.getTexture("Yes"), "", Assets.manager.getTexture("YesClicked"));
								_yesBtn.x = 114;
								_yesBtn.y = 200;
								_yesBtn.addEventListener(Event.TRIGGERED, onYes);
								_noBtn = new Button(Assets.manager.getTexture("No"), "", Assets.manager.getTexture("NoClicked"));
								_noBtn.x = 314;
								_noBtn.y = 200;
								_noBtn.addEventListener(Event.TRIGGERED, onNo);
								_iapText = new Image(Assets.manager.getTexture("IAPText"));
								_iapText.x = (568 - _iapText.width) * 0.5;
								_iapText.y = 100;
							}
							addChild(_fadeImage);
							addChild(_yesBtn);
							addChild(_noBtn);
							addChild(_iapText);
							
							changeState(STATE_IDLE, "IAP");
						}
						else
						{
							showVictory();
						}
					}
					else
					{
						showVictory();
					}
					break;
				}
				case STATE_PLAYER_DEAD:
				{
					if (!_deadPlayer)
					{
						SoundManager.muteMusic();
						_soundManager.playSound("Fail");
						_deadPlayer = new Image(Assets.manager.getTexture("PlayerDeath" + _player.direction));
						_deadPlayer.x = _player.body.GetPosition().x * _worldScale - _deadPlayer.width * 0.5;
						_deadPlayer.y = _player.body.GetPosition().y * _worldScale - _deadPlayer.height * 0.5;
						_gui.addChild(_deadPlayer);
					}
					if (!_fallingBody)
					{
						var circleShape:b2CircleShape = new b2CircleShape(24 / _worldScale);
						var fixtureDef:b2FixtureDef = new b2FixtureDef();
						fixtureDef.density = 1;
						fixtureDef.friction = 20;
						fixtureDef.restitution = 0.0;
						fixtureDef.shape = circleShape;
						fixtureDef.filter.maskBits = Category.OTHER;
						fixtureDef.filter.categoryBits = Category.OTHER;
						var bodyDef:b2BodyDef = new b2BodyDef();
						bodyDef.type = b2Body.b2_dynamicBody;
						bodyDef.position.Set(_player.body.GetPosition().x, _player.body.GetPosition().y);
						bodyDef.userData = this;
						_fallingBody = _world.CreateBody(bodyDef);
						_fallingBody.CreateFixture(fixtureDef);
						_fallingBody.SetSleepingAllowed(false);
						//_fallingBody.SetLinearDamping(0.3);
						if (_player.direction == "Right")
							_fallingBody.ApplyImpulse(new b2Vec2( -10, -10), _fallingBody.GetPosition());
						else
							_fallingBody.ApplyImpulse(new b2Vec2( 10, -10), _fallingBody.GetPosition());
						
						_player.die();
					}
					_deadPlayer.x = _fallingBody.GetPosition().x * _worldScale - _deadPlayer.width * 0.5;
					_deadPlayer.y = _fallingBody.GetPosition().y * _worldScale - _deadPlayer.height * 0.5;
					
					_world.Step(1/40, 8, 2);
					_world.ClearForces();
					_world.DrawDebugData();
					
					_player.update(e.passedTime);
					
					for (i = 0; i < _btns.numChildren; i++)
					{
						(_btns.getChildAt(i) as Btn).update(1);
					}
					
					for (i = 0; i < _doors.numChildren; i++)
					{
						(_doors.getChildAt(i) as Door).update(1);
					}
					
					for (i = 0; i < _boxes.numChildren; i++)
					{
						(_boxes.getChildAt(i) as Box).update(1, 1 / 60);
					}
					
					for (i = 0; i < _keys.numChildren; i++)
					{
						(_keys.getChildAt(i) as Key).update();
					}
					
					for (i = 0; i < _cannons.numChildren; i++)
					{
						(_cannons.getChildAt(i) as Cannon).update(e.passedTime);
					}
					
					for (i = 0; i < _cannonBalls.numChildren; i++)
					{
						(_cannonBalls.getChildAt(i) as CannonBall).update(1);
					}
					for (i = _cannonBalls.numChildren - 1; i >= 0; --i)
					{
						if ((_cannonBalls.getChildAt(i) as CannonBall).outOfArea)
						{
							_cannonBalls.removeChildAt(i, true);
						}
					}
					for (i = _stars.numChildren - 1; i >= 0; --i)
					{
						if (_stars.getChildAt(i) is Star)
							(_stars.getChildAt(i) as Star).update(e.passedTime);
					}
					
					if (_fallingBody.GetPosition().y > 550 / _worldScale)
					{
						_fallingBody.DestroyFixture(_fallingBody.GetFixtureList());
						_world.DestroyBody(_fallingBody);
						_fallingBody = null;
						_gui.removeChild(_deadPlayer, true);
						_deadPlayer = null;
						state = STATE_IDLE;
						
						showAds();
						//dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
						//reset("player is out of screen 2");
					}
					break;
				}
				case STATE_MENU:
				{
					_inGameMenu.update(new Point(touch.globalX, touch.globalY));
					break;
				}
				case STATE_IDLE:
				{
					
					break;
				}
			}
			//trace(_fallingBody);
			//trace(_player.body.GetPosition().y * _worldScale);
			
		}
		
		private function showAds():void 
		{
			if (!IAP.purchased)
				PlayHaven.playhaven.sendContentRequest("end_game_screen", true);
			else
				backFromAds();
		}
		
		private function backFromAds():void
		{
			if (!_deadPlayer)
			{
				dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
			}
		}
		
		private function onContentDismissed(e:PlayHavenEvent):void 
		{
			switch(e.contentDismissalReason)
			{
				case ContentDismissalReason.USER_CONTENT_TRIGGERED:
				{
					//Constants.tf.text = "OTHER REASON";
					backFromAds();
					break;
				}
				case ContentDismissalReason.USER_BUTTON_CLOSED:
				{
					//Constants.tf.text = "OTHER REASON";
					backFromAds();
					break;
				}
				case ContentDismissalReason.APP_BACKGROUNDED:
				{
					//Constants.tf.text = "OTHER REASON";
					backFromAds();
					break;
				}
				case ContentDismissalReason.NO_CONTENT_AVAILABLE:
				{
					//Constants.tf.text = "NO CONTENT";
					AirChartboost.getInstance().showInterstitial();
					break;
				}
			}
		}
		
		private function onContentDisplayed(e:PlayHavenEvent):void 
		{
			backFromAds();
		}
		
		private function onContentFailed(e:PlayHavenEvent):void 
		{
			AirChartboost.getInstance().showInterstitial();
		}
		
		private function onYes(e:Event):void 
		{
			if (StoreKit.isSupported() && StoreKit.storeKit.isStoreKitAvailable())
			{
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED, onPurchaseUserCancelled);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
			}
			IAP.buyProduct();
		}
		
		private function onNo(e:Event):void 
		{
			removeChild(_yesBtn);
			removeChild(_noBtn);
			removeChild(_fadeImage);
			removeChild(_iapText);
			
			onLevelSelect(null);
		}
		
		private function onPurchaseFailed(e:StoreKitErrorEvent):void 
		{
			onNo(null);
		}
		
		private function onPurchaseUserCancelled(e:StoreKitEvent):void 
		{
			onNo(null);
		}
		
		private function onPurchaseSuccess(e:StoreKitEvent):void 
		{
			StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
			StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_CANCELLED, onPurchaseUserCancelled);
			StoreKit.storeKit.removeEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
			
			removeChild(_yesBtn);
			removeChild(_noBtn);
			removeChild(_fadeImage);
			removeChild(_iapText);
			
			showVictory();
		}
		
		private function hideIcon(target:Image):void 
		{
			target.visible = false;
			target.touchable = true;
		}
		
		private function tweenCompleted(target:Image):void 
		{
			target.touchable = true;
		}
		
		private function victory():void 
		{
			_victory.visible = true;
		}
		
		// Victory and menu screen handlers
		private function onLevelSelect(e:CustomEvent):void 
		{
			if (_finalCartoon)
			{
				_finalCartoon.removeEventListener(CustomEvent.MAIN_MENU, onLevelSelect);
				removeChild(_finalCartoon, true);
			}
			if (_deadPlayer)
			{
				_fallingBody.DestroyFixture(_fallingBody.GetFixtureList());
				_world.DestroyBody(_fallingBody);
				_fallingBody = null;
				_gui.removeChild(_deadPlayer, true);
				_deadPlayer = null;
				state = STATE_IDLE;
				_player.alive();
				//SoundManager.unmuteMusic();
			}
			changeState(STATE_IDLE, "onMainMenu2");
			_victory.visible = false;
			_inGameMenu.visible = false;
			_paused = false;
			dispatchEvent(new CustomEvent(CustomEvent.LEVEL_SELECT));
		}
		
		private function onNextLevel(e:CustomEvent):void 
		{
			changeState(STATE_PLAYING, "onNextLevel");
			_victory.visible = false;
			SoundManager.unmuteMusic();
			dispatchEvent(new CustomEvent(CustomEvent.NEXT_LEVEL));
		}
		
		private function onResume(e:CustomEvent):void 
		{
			changeState(_previousState, "onResume");
			_inGameMenu.visible = false;
			_paused = false;
		}
		
		private function onRestart(e:CustomEvent):void 
		{
			changeState(STATE_IDLE);
			dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
			//reset("restart button");
		}
		
		private function onReset(e:Event):void 
		{
			_soundManager.playSound("Click");
			dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
			//reset();
		}
		
		private function onMenu(e:Event):void 
		{
			_previousState = state;
			//trace("Bodies: ", PhysicWorld.world.GetBodyCount());
			_soundManager.playSound("Click");
			changeState(STATE_MENU, "onMenu");
			_inGameMenu.visible = true;
			_inGameMenu.updateSounds();
			_paused = true;
		}
		
		public function changeState(st:int, callingFrom:String = "unknown"):void
		{
			//trace(callingFrom);
			state = st;
		}
	}
}