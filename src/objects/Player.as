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
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import helper.Category;
	import physics.PhysicWorld;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Player extends Sprite
	{
		public var direction:String = "Right";
		public var connectedBodies:Vector.<b2Body> = new Vector.<b2Body>();
		public var connectedBodies2:Vector.<b2Body> = new Vector.<b2Body>();
		public var contactPoints:Vector.<b2Vec2> = new Vector.<b2Vec2>();
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _startingPosition:Point;
		private var _costume:MovieClip;
		private var _headBody:b2Body;
		private var _idleTimer:Number = 2;
		private var _animations:Dictionary = new Dictionary();
		private var _currentAnimation:String = "";
		private var _dead:Boolean;
		private var _previousPosition:Point = new Point(0, 0);
		
		public function Player(X:int, Y:int) 
		{
			touchable = false;
			_startingPosition = new Point(X, Y);
			name = "Player";
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBodies();
			
			//addAnimation("PlayerLeft", 10, true);
			addAnimation("PlayerIdle", 1, true);
			addAnimation("PlayerRunningLeft", 16, true);
			addAnimation("PlayerJumpingLeft", 1, true);
			addAnimation("PlayerFallingLeft", 1, true);
			addAnimation("PlayerScratching", 14, true);
			addAnimation("PlayerYo", 14, true);
			addAnimation("PlayerStretching", 14, true);
			addAnimation("PlayerWinking", 14, true);
			//addAnimation("PlayerRight", 10, true);
			addAnimation("PlayerRunningRight", 16, true);
			addAnimation("PlayerJumpingRight", 1, true);
			addAnimation("PlayerFallingRight", 1, true);
			
			switchAnimation(name + "RunningRight");
		}
		
		private function addAnimation(key:String, fps:Number, looped:Boolean):void
		{
			_animations[key] = new MovieClip(Assets.manager.getTextures(key), fps);
			_animations[key].loop = looped;
			_animations[key].name = key;
			_animations[key].smoothing = TextureSmoothing.NONE;
		}
		
		public function switchAnimation(key:String):void
		{
			if (key == "PlayerIdle")
			{
				if (_idleTimer < 0)
				{
					if (_currentAnimation == "")
						key = selectAnimation();
					else
						key = _currentAnimation;
				}
			}
			else
			{
				if (key != "PlayerScratching")
					_idleTimer = 2 + Math.random();
			}
			
			if (_costume)
			{
				if (_costume.name == key)
					return;
				
				_costume.stop();
				Starling.juggler.remove(_costume);
				removeChild(_costume);
				_costume = null;
			}
			_costume = _animations[key];
			_costume.play();
			_costume.pivotX = _costume.width >> 1;
			_costume.pivotY = _costume.height >> 1;
			_costume.x = Math.round( -_costume.width >> 1);
			_costume.y = Math.round( -_costume.height >> 1);
			if (key == _currentAnimation)
			{
				_costume.loop = false;
				_costume.addEventListener(Event.COMPLETE, onCustomIdleComplete);
			}
			addChild(_costume);
			Starling.juggler.add(_costume);
		}
		
		private function selectAnimation():String 
		{
			var rnd:Number = Math.random();
			if (rnd < 0.25)
			{
				_currentAnimation = "PlayerScratching";
				return "PlayerScratching";
			}
			else if (rnd < 0.5)
			{
				_currentAnimation = "PlayerYo";
				return "PlayerYo";
			}
			else if (rnd < 0.75)
			{
				_currentAnimation = "PlayerStretching";
				return "PlayerStretching";
			}
			else
			{
				_currentAnimation = "PlayerWinking";
				return "PlayerWinking";
			}
		}
		
		private function createBodies():void
		{
			// Нижняя часть тела (круг)
			var circleShape:b2CircleShape = new b2CircleShape(14.5 / _worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 20;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = circleShape;
			fixtureDef.filter.maskBits = Category.PLAYER | Category.SENSOR | Category.PLATFORM | Category.BULLET;
			fixtureDef.filter.categoryBits = Category.PLAYER;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale);
			bodyDef.userData = this;
			_body = _world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
			_body.SetSleepingAllowed(false);
			_body.SetLinearDamping(0.3);
			//_body.SetFixedRotation(true); // !!!
			// Верхняя часть тела (круг)
			//_headBody;
			//var headShape:b2CircleShape = new b2CircleShape(24 / _worldScale);
			//fixtureDef = new b2FixtureDef();
			//fixtureDef.density = 1;
			//fixtureDef.friction = 0;
			//fixtureDef.restitution = 0.0;
			//fixtureDef.shape = headShape;
			//bodyDef = new b2BodyDef();
			//bodyDef.type = b2Body.b2_dynamicBody;
			//bodyDef.position.Set(_startingPosition.x / _worldScale, (_startingPosition.y - 15) / _worldScale);
			//bodyDef.userData = this;
			//_headBody = _world.CreateBody(bodyDef);
			//_headBody.CreateFixture(fixtureDef);
			//_headBody.SetSleepingAllowed(false);
			//_headBody.SetFixedRotation(true);
			//_headBody.SetLinearDamping(0.3);
			// Соединение двух тел
			//var revJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			//revJointDef.Initialize(_body, _headBody, _body.GetWorldCenter());
			//revJointDef.maxMotorTorque = 1.0;
			//revJointDef.enableMotor = true;
			//_world.CreateJoint(revJointDef);
		}
		
		public function reset():void
		{
			_body.SetPosition(new b2Vec2(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale));
			_body.SetLinearVelocity(new b2Vec2(0, 0));
			//_headBody.SetPosition(new b2Vec2(_startingPosition.x / _worldScale, (_startingPosition.y - 15) / _worldScale));
			//_headBody.SetLinearVelocity(new b2Vec2(0, 0));
			_costume.x = _body.GetPosition().x * _worldScale;
			_costume.y = _body.GetPosition().y * _worldScale;
		}
		
		public function die():void
		{
			_body.SetPosition(new b2Vec2(0 / _worldScale, -100 / _worldScale));
			_body.SetLinearVelocity(new b2Vec2(0, 0));
			_dead = true;
		}
		
		public function alive():void
		{
			_body.SetPosition(new b2Vec2(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale));
			_body.SetLinearVelocity(new b2Vec2(0, 0));
			_dead = false;
		}
		
		public function update(ratio:Number):void
		{
			//_costume.x = Math.round(_body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x);
			//_costume.y = Math.round(_body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y);
			_costume.x = _body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x;
			_costume.y = _body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y - 2;
			
			if (_dead)
			{
				_body.SetPosition(new b2Vec2(0 / _worldScale, -100 / _worldScale));
				_body.SetLinearVelocity(new b2Vec2(0, 0));
				_costume.x = 0;
				_costume.y = -100;
			}
		}
		
		public function updateCostume(passedTime:Number):void
		{
			if (_costume.name == "PlayerIdle")
			{
				_idleTimer -= passedTime;
			}
		}
		
		public function resetPosition():void
		{
			_costume.x = _previousPosition.x = _body.GetPosition().x * _worldScale;
			_costume.y = _previousPosition.y = _body.GetPosition().y * _worldScale;
		}
		
		private function onCustomIdleComplete(e:Event):void 
		{
			_costume.removeEventListener(Event.ADDED, onCustomIdleComplete);
			_idleTimer = 2 + Math.random();
			_costume.stop();
			_currentAnimation = "";
		}
		
		override public function dispose():void 
		{
			//_world.DestroyBody(_headBody);
			_world.DestroyBody(_body);
			removeChild(_costume, true);
			
			super.dispose();
		}
		
		public function get body():b2Body
		{
			return _body;
		}
		
		public function setStartingPoint(p:Point):void
		{
			_startingPosition = p;
		}
	}

}