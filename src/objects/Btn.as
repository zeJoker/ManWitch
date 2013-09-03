package objects 
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import flash.geom.Point;
	import helper.Category;
	import physics.PhysicWorld;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Btn extends Sprite 
	{
		public var isActive:Boolean;
		public var sizes:Point;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _sensor:b2Body;
		private var _startingPosition:Point;
		private var _costumeBase:Image;
		private var _costumeFace:Image;
		private var _kind:int;
		private var _type:int;
		private var _angle:Number;
		private var _baseSprite:Sprite;
		private var _previousPosition:Point = new Point(0, 0);
		
		public function Btn(X:Number, Y:Number, W:Number, H:Number, angle:Number, key:String, baseSprite:Sprite) 
		{
			_startingPosition = new Point(X, Y);
			sizes = new Point(W, H);
			_kind = int(key.charAt(key.length - 1));
			_angle = angle;
			_baseSprite = baseSprite;
			if (Math.round(Math.sin(_angle)) == 0)
			{
				if (Math.round(Math.cos(_angle)) == 1)
				{
					_type = 0; // 0
				}
				else
				{
					_type = 2; // 180
				}
			}
			else
			{
				if (Math.round(Math.sin(_angle)) == 1)
				{
					_type = 3; // 270
				}
				else
				{
					_type = 1; // 90
				}
			}
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBody();
			drawCostume();
		}
		
		private function drawCostume():void 
		{
			_costumeFace = new Image(Assets.manager.getTexture("ButtonEyesA" + String(_kind)));
			_costumeFace.pivotX = 7;
			_costumeFace.pivotY = 6;
			_costumeFace.rotation = _angle;
			addChild(_costumeFace);
			_costumeBase = new Image(Assets.manager.getTexture("ButtonBase"));
			_costumeBase.pivotX = 10;
			_costumeBase.pivotY = 4;
			_costumeBase.rotation = _angle;
			_costumeBase.x = _startingPosition.x - 8 * Math.round(Math.sin(_angle));
			_costumeBase.y = _startingPosition.y + 8 * Math.round(Math.cos(_angle));
			_baseSprite.addChild(_costumeBase);
		}
		
		private function createBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set((_startingPosition.x) / _worldScale, (_startingPosition.y) / _worldScale);
			bodyDef.userData = this;
			
			_body = _world.CreateBody(bodyDef);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(9 / _worldScale, 9 / _worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = shape;
			fixtureDef.filter.maskBits = Category.PLAYER;
			fixtureDef.filter.categoryBits = Category.SENSOR | Category.PLAYER;
			_body.CreateFixture(fixtureDef);
			
			var jd:b2PrismaticJointDef = new b2PrismaticJointDef();
			jd.Initialize(_body, _world.GetGroundBody(), _body.GetWorldCenter(), new b2Vec2(-Math.round(Math.sin(_angle)), Math.round(Math.cos(_angle))));
			jd.lowerTranslation = -0.5;
			jd.upperTranslation = 0;
			jd.enableLimit = true;
			jd.maxMotorForce = 6;
			jd.motorSpeed = 3;
			jd.enableMotor = true;
			_world.CreateJoint(jd);
			
			var bodyDef2:b2BodyDef = new b2BodyDef();
			bodyDef2.type = b2Body.b2_staticBody;
			bodyDef2.position.Set((_startingPosition.x - 20 * Math.round(Math.sin(_angle))) / _worldScale, (_startingPosition.y + 20 * Math.round(Math.cos(_angle))) / _worldScale);
			bodyDef2.userData = this;
			
			_sensor = _world.CreateBody(bodyDef2);
			
			var shape2:b2PolygonShape = new b2PolygonShape();
			shape2.SetAsBox(4 / _worldScale, 4 / _worldScale);
			
			var fixtureDef2:b2FixtureDef = new b2FixtureDef();
			fixtureDef2.density = 1;
			fixtureDef2.friction = 10;
			fixtureDef2.restitution = 0.0;
			fixtureDef2.shape = shape2;
			fixtureDef2.isSensor = true;
			_sensor.CreateFixture(fixtureDef2);
		}
		
		public function update(ratio:Number):void
		{
			_costumeFace.x = Math.round(_body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x);
			_costumeFace.y = Math.round(_body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y);
		}
		
		public function resetPosition():void
		{
			_costumeFace.x = _previousPosition.x = _body.GetPosition().x * _worldScale;
			_costumeFace.y = _previousPosition.y = _body.GetPosition().y * _worldScale;
		}
		
		public function reset():void
		{
			_body.SetPosition(new b2Vec2((_startingPosition.x) / _worldScale, (_startingPosition.y) / _worldScale));
		}
		
		override public function dispose():void 
		{
			removeChild(_costumeFace, true);
			_baseSprite.removeChild(_costumeBase, true);
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			_sensor.SetUserData(null);
			_sensor.DestroyFixture(_sensor.GetFixtureList());
			_world.DestroyBody(_sensor);
			_baseSprite = null;
			
			super.dispose();
		}
		
		public function get kind():int
		{
			return _kind;
		}
	}

}