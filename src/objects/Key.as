package objects 
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.geom.Point;
	import helper.Category;
	import physics.PhysicWorld;
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
	public class Key extends Sprite 
	{
		public var catched:Boolean;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _startingPosition:Point;
		private var _costume:Image;
		private var _type:String;
		private var _glowFx:MovieClip;
		private var _angle:Number = 0;
		private var _previousPosition:Point = new Point(0, 0);
		
		public function Key(X:Number, Y:Number, kind:String) 
		{
			_startingPosition = new Point(X, Y);
			_type = kind;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBody();
			
			_glowFx = new MovieClip(Assets.manager.getTextures("Glowing"), 12);
			_glowFx.x = _startingPosition.x - (_glowFx.width >> 1);
			_glowFx.y = _startingPosition.y - (_glowFx.height>> 1);
			addChild(_glowFx);
			Starling.juggler.add(_glowFx);
			
			_costume = new Image(Assets.manager.getTexture(_type));
			_costume.x = _startingPosition.x - (_costume.width >> 1);
			_costume.y = _startingPosition.y - (_costume.height >> 1);
			addChild(_costume);
		}
		
		private function createBody():void
		{
			// Сенсор, ловящий игрока (круг)
			var circleShape:b2CircleShape = new b2CircleShape(12 / _worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 10;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = circleShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = Category.PLAYER;
			fixtureDef.filter.maskBits = Category.PLAYER;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale);
			bodyDef.userData = this;
			_body = _world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
			_body.SetSleepingAllowed(false);
		}
		
		public function update():void
		{
			_angle += Math.PI / 90;
			_costume.y = _startingPosition.y - (_costume.height >> 1) + 10 * Math.sin(_angle);
			_glowFx.y = _startingPosition.y - (_glowFx.height>> 1) + 10 * Math.sin(_angle);
		}
		
		override public function dispose():void 
		{
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			removeChild(_costume, true);
			Starling.juggler.remove(_glowFx);
			removeChild(_glowFx, true);
			
			super.dispose();
		}
	}

}