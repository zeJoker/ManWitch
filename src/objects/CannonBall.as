package objects 
{
	import assets.Assets;
	import Box2D.Collision.b2Bound;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.geom.Point;
	import helper.Category;
	import physics.PhysicWorld;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class CannonBall extends Sprite 
	{
		public var outOfArea:Boolean;
		public var cannon:Cannon;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _startingPosition:Point;
		private var _costume:MovieClip;
		private var _velocity:b2Vec2;
		private var _previousPosition:Point = new Point(0, 0);
		
		public function CannonBall(X:Number, Y:Number, velocity:b2Vec2, cannon:Cannon) 
		{
			touchable = false;
			_startingPosition = new Point(X, Y);
			_velocity = velocity;
			this.cannon = cannon;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBody();
			_costume = new MovieClip(Assets.manager.getTextures("CannonBallFlying"), 30);
			_costume.pivotX += 25;
			_costume.pivotY += 10;
			//_costume.x = _startingPosition.x + 30;
			//_costume.y = _startingPosition.y + 30;
			if (_velocity.y != 0)
			{
				_costume.rotation += Math.PI / 2;
			}
			else if (_velocity.x > 0)
			{
				_costume.scaleX = -1;
			}
			Starling.juggler.add(_costume);
			addChild(_costume);
		}
		
		private function createBody():void
		{
			// Сенсор, ловящий игрока (круг)
			var circleShape:b2CircleShape = new b2CircleShape(5 / _worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 10;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = circleShape;
			fixtureDef.filter.categoryBits = Category.BULLET;
			fixtureDef.filter.maskBits = Category.PLATFORM | Category.PLAYER;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale);
			bodyDef.userData = this;
			_body = _world.CreateBody(bodyDef);
			_body.SetBullet(true);
			_body.CreateFixture(fixtureDef);
			_body.SetSleepingAllowed(false);
			_body.SetGravity(new b2Vec2(0, 0));
		}
		
		public function explode():void
		{
			Starling.juggler.remove(_costume);
			removeChild(_costume, true);
			
			_velocity = new b2Vec2(0, 0);
			
			_costume = new MovieClip(Assets.manager.getTextures("CannonBallBoom"), 60);
			_costume.pivotX += 15;
			_costume.pivotY += 15;
			_costume.x = _body.GetPosition().x * _worldScale;
			_costume.x = _body.GetPosition().y * _worldScale;
			_costume.addEventListener(Event.COMPLETE, onBoomComplete);
			Starling.juggler.add(_costume);
			addChild(_costume);
		}
		
		private function onBoomComplete(e:Event):void 
		{
			Starling.juggler.remove(_costume);
			removeChild(_costume, true);
			//_costume = null;
			outOfArea = true;
		}
		
		public function update(ratio:Number):void
		{
			if (!outOfArea)
				_body.SetLinearVelocity(_velocity);
			_costume.x = Math.round(_body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x);
			_costume.y = Math.round(_body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y);
			
			if (_costume.x < -50 || _costume.x > 700 || _costume.y < -50 || _costume.y > 550)
				outOfArea = true;
		}
		
		public function resetPosition():void
		{
			_costume.x = _previousPosition.x = _body.GetPosition().x * _worldScale;
			_costume.y = _previousPosition.y = _body.GetPosition().y * _worldScale;
		}
		
		override public function dispose():void 
		{
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			Starling.juggler.remove(_costume);
			removeChild(_costume, true);
			
			super.dispose();
		}
		
		public function get body():b2Body
		{
			return _body;
		}
	}

}