package objects 
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.geom.Point;
	import physics.PhysicWorld;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Cannon extends Sprite 
	{
		public var catched:Boolean;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _startingPosition:Point;
		private var _costume:Image;
		private var _key:String;
		private var _timer:Number = 3;
		private var _cannonBallSprite:Sprite;
		private var _backSprite:Sprite;
		private var _smokeFx:MovieClip;
		private var _boomFx:Image;
		private var _fireFx:MovieClip;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		
		public function Cannon(X:Number, Y:Number, key:String, cannonBallSprite:Sprite) 
		{
			touchable = false;
			_startingPosition = new Point(X, Y);
			_key = key;
			_cannonBallSprite = cannonBallSprite;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_backSprite = new Sprite();
			addChild(_backSprite);
			createBody();
			_costume = new Image(Assets.manager.getTexture(_key));
			_costume.x = _startingPosition.x;
			_costume.y = _startingPosition.y;
			addChild(_costume);
		}
		
		private function createBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(_startingPosition.x / PhysicWorld.SCALE, _startingPosition.y / PhysicWorld.SCALE);
			bodyDef.userData = this;
			_body = PhysicWorld.world.CreateBody(bodyDef);
			_body.SetSleepingAllowed(false);
			var arr:Array = getPhysicArr(_key);
			for (var i:int = 0; i < arr.length; ++i)
			{
				var shape:b2PolygonShape = new b2PolygonShape();
				shape.SetAsArray(arr[i], arr[i].length);
				
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.density = 1;
				fixtureDef.friction = 0.2;
				fixtureDef.restitution = 0.0;
				fixtureDef.shape = shape;
				_body.CreateFixture(fixtureDef);
			}
		}
		
		public function update(passedTime:Number):void
		{
			_timer -= passedTime;
			if (_timer < 0)
			{
				_soundManager.playSound("Shot");
				_timer = 3;
				
				_fireFx = new MovieClip(Assets.manager.getTextures("Shot"), 30);
				_fireFx.loop = false;
				_fireFx.pivotX = 14;
				_fireFx.pivotY = 14;
				_fireFx.addEventListener(Event.COMPLETE, onFireFxComplete);
				Starling.juggler.add(_fireFx);
				_backSprite.addChild(_fireFx);
				
				var dx:Number;
				var dy:Number;
				var angle:Number;
				var velocity:b2Vec2;
				if (_key == "Cannon1")
				{
					dx = 10+12;
					dy = 0;
					velocity = new b2Vec2( 0, -12);
					angle = -Math.PI / 2;
				}
				else if (_key == "Cannon2")
				{
					dx = 0;
					dy = 10+15;
					velocity = new b2Vec2( -12, 0);
					angle = Math.PI;
				}
				else
				{
					dx = 40;
					dy = 10+15;
					velocity = new b2Vec2( 12, 0);
					angle = 0;
				}
				_fireFx.x = _startingPosition.x + dx;
				_fireFx.y = _startingPosition.y + dy;
				_smokeFx = new MovieClip(Assets.manager.getTextures("CannonFx"), 15);
				_smokeFx.loop = false;
				_smokeFx.pivotX = 6;
				_smokeFx.pivotY = 26;
				_smokeFx.x = _fireFx.x;
				_smokeFx.y = _fireFx.y;
				_smokeFx.rotation = angle;
				_smokeFx.addEventListener(Event.COMPLETE, onSmokeFxComplete);
				Starling.juggler.add(_smokeFx);
				addChild(_smokeFx);
				
				_boomFx = new Image(Assets.manager.getTexture("Boom"));
				_boomFx.pivotX = 24;
				_boomFx.pivotY = 16;
				_boomFx.x = _fireFx.x;
				_boomFx.y = _fireFx.y;
				_boomFx.scaleX = 0.01;
				_boomFx.scaleY = 0.01;
				addChild(_boomFx);
				
				var tween:Tween = new Tween(_boomFx, 0.4, Transitions.LINEAR);
				tween.moveTo(_fireFx.x + 48 * Math.cos(angle), _boomFx.y + 48 * Math.sin(angle));
				tween.animate("scaleX", 1);
				tween.animate("scaleY", 1);
				tween.onComplete = onTweenComplete;
				Starling.juggler.add(tween);
				
				var cannonBall:CannonBall = new CannonBall(_startingPosition.x + dx, _startingPosition.y + dy, velocity, this);
				_cannonBallSprite.addChild(cannonBall);
			}
		}
		
		private function onTweenComplete():void 
		{
			var tween:Tween = new Tween(_boomFx, 0.3, Transitions.LINEAR);
			//tween.moveTo(_fireFx.x + 22 + 80 * Math.cos(angle), _boomFx.y + 80 * Math.sin(angle));
			tween.animate("alpha", 0);
			tween.onComplete = onTweenComplete2;
			Starling.juggler.add(tween);
		}
		
		private function onTweenComplete2():void 
		{
			removeChild(_boomFx, true);
			_boomFx = null;
		}
		
		private function onFireFxComplete(e:Event):void 
		{
			Starling.juggler.remove(_fireFx);
			_backSprite.removeChild(_fireFx);
			_fireFx = null;
		}
		
		private function onSmokeFxComplete(e:Event):void 
		{
			Starling.juggler.remove(_smokeFx);
			removeChild(_smokeFx);
			_smokeFx = null;
		}
		
		override public function dispose():void 
		{
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			removeChild(_costume, true);
			
			super.dispose();
		}
		
		public function resetTimer():void
		{
			_timer = 3;
		}
		
		private function getPhysicArr(key:String):Array
		{
			var ptm_ratio:Number = 30;
			if (key == "Cannon1")
			{
				return [[   new b2Vec2(30 / ptm_ratio, 8 / ptm_ratio)  ,  new b2Vec2(33 / ptm_ratio, 40 / ptm_ratio)  ,  new b2Vec2(13 / ptm_ratio, 40 / ptm_ratio)  ,  new b2Vec2(13 / ptm_ratio, 8 / ptm_ratio)  ,  new b2Vec2(22 / ptm_ratio, 0 / ptm_ratio)  ]];
			}
			else if (key == "Cannon2")
			{
				return [[   new b2Vec2(11.5555553436279 / ptm_ratio, 39.888888888061 / ptm_ratio)  ,  new b2Vec2(6 / ptm_ratio, 35 / ptm_ratio)  ,  new b2Vec2(0 / ptm_ratio, 23 / ptm_ratio)  ,  new b2Vec2(10 / ptm_ratio, 18 / ptm_ratio)  ,  new b2Vec2(31 / ptm_ratio, 16 / ptm_ratio)  ,  new b2Vec2(38 / ptm_ratio, 40 / ptm_ratio)  ]];
			}
			else
			{
				return [[   new b2Vec2(9 / ptm_ratio, 16 / ptm_ratio)  ,  new b2Vec2(30 / ptm_ratio, 18 / ptm_ratio)  ,  new b2Vec2(40 / ptm_ratio, 24 / ptm_ratio)  ,  new b2Vec2(34 / ptm_ratio, 35 / ptm_ratio)  ,  new b2Vec2(26 / ptm_ratio, 40 / ptm_ratio)  ,  new b2Vec2(3 / ptm_ratio, 40 / ptm_ratio)  ]];
			}
		}
	}

}