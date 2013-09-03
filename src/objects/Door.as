package objects 
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Controllers.b2GravityController;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import flash.geom.Point;
	import flash.media.SoundChannel;
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
	public class Door extends Sprite 
	{
		public var sizes:Point;
		public var btn:Btn;
		
		private var _isActiveFreezed:Boolean;
		private var _isUnactiveFreezed:Boolean;
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _sensor:b2Body;
		private var _startingPosition:Point;
		private var _costume:Image;
		private var _key:String;
		private var _kind:int;
		private var _upperBound:Number;
		private var _lowerBound:Number;
		private var _velocityWhenActive:b2Vec2;
		private var _velocityWhenNotActive:b2Vec2;
		private var _nullVelocity:b2Vec2 = new b2Vec2(0, 0);
		private var _soundChannel:SoundChannel;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _previousPosition:Point = new Point(0, 0);
		
		public function Door(X:Number, Y:Number, W:Number, H:Number, key:String, kind:int) 
		{
			_startingPosition = new Point(X, Y);
			if (kind == 0 || kind == 2)
			{
				sizes = new Point(W - 10, H);
			}
			else
			{
				sizes = new Point(H, W - 10);
			}
			_key = key;
			_kind = kind;
			//trace(kind);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBody();
			drawCostume();
			fillBounds();
		}
		
		private function fillBounds():void 
		{
			switch (_kind)
			{
				case 0:
				{
					_lowerBound = _body.GetPosition().y;
					_upperBound = _lowerBound - 80 / 30;
					_velocityWhenActive = new b2Vec2(0, -5);
					_velocityWhenNotActive = new b2Vec2(0, 5);
					break;
				}
				case 1:
				{
					_lowerBound = _body.GetPosition().x;
					_upperBound = _lowerBound + 80 / 30;
					_velocityWhenActive = new b2Vec2(5, 0);
					_velocityWhenNotActive = new b2Vec2(-5, 0);
					break;
				}
				case 2:
				{
					_lowerBound = _body.GetPosition().y;
					_upperBound = _lowerBound + 80 / 30;
					_velocityWhenActive = new b2Vec2(0, 5);
					_velocityWhenNotActive = new b2Vec2(0, -5);
					break;
				}
				case 3:
				{
					_lowerBound = _body.GetPosition().x;
					_upperBound = _lowerBound - 80 / 30;
					_velocityWhenActive = new b2Vec2(-5, 0);
					_velocityWhenNotActive = new b2Vec2(5, 0);
					break;
				}
			}
		}
		
		private function drawCostume():void 
		{
			_costume = new Image(Assets.manager.getTexture(_key));
			_costume.pivotX += 10;
			_costume.pivotY += 42;
			_costume.rotation = _kind * Math.PI / 2;
			addChild(_costume);
		}
		
		private function createBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_kinematicBody;
			bodyDef.position.Set((_startingPosition.x) / _worldScale, (_startingPosition.y) / _worldScale);
			bodyDef.userData = this;
			
			_body = _world.CreateBody(bodyDef);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(sizes.x * 0.5 / _worldScale, sizes.y * 0.5 / _worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = shape;
			//fixtureDef.filter.maskBits = Category.PLAYER;
			//fixtureDef.filter.categoryBits = Category.SENSOR;
			_body.CreateFixture(fixtureDef);
			_body.SetSleepingAllowed(false);
		}
		
		public function reset():void
		{
			_body.SetPosition(new b2Vec2(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale));
			_body.SetLinearVelocity(new b2Vec2(0, 0));
		}
		
		public function enterContact(contactPoint:b2Vec2):void
		{
			var dx:Number = _body.GetPosition().x - contactPoint.x;
			var dy:Number = _body.GetPosition().y - contactPoint.y;
			switch (_kind)
			{
				case 0:
				{
					if (dy > 1.4)
					{
						_isActiveFreezed = true;
						if (btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}
						}
					}
					else if (dy < -1.4)
					{
						_isUnactiveFreezed = true;
						if (!btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					break;
				}
				case 1:
				{
					if (dx < -1.4)
					{
						_isActiveFreezed = true;
						if (btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					else if (dx > 1.4)
					{
						_isUnactiveFreezed = true;
						if (!btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					break;
				}
				case 2:
				{
					if (dy < -1.4)
					{
						_isActiveFreezed = true;
						if (btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					else if (dy > 1.4)
					{
						_isUnactiveFreezed = true;
						if (!btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					break;
				}
				case 3:
				{
					if (dx > 1.4)
					{
						_isActiveFreezed = true;
						if (btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					else if (dx < -1.4)
					{
						_isUnactiveFreezed = true;
						if (btn.isActive)
						{
							_body.SetLinearVelocity(_nullVelocity);
							if (_soundChannel)
							{
								_soundChannel.stop();
								_soundChannel = null;
							}	
						}
					}
					break;
				}
			}
		}
		
		public function exitContact(contactPoint:b2Vec2):void
		{
			var dx:Number = _body.GetPosition().x - contactPoint.x;
			var dy:Number = _body.GetPosition().y - contactPoint.y;
			switch (_kind)
			{
				case 0:
				{
					if (dy > 1.4)
					{
						_isActiveFreezed = false;
					}
					else if (dy < -1.4)
					{
						_isUnactiveFreezed = false;
					}
					break;
				}
				case 1:
				{
					if (dx < -1.4)
					{
						_isActiveFreezed = false;
					}
					else if (dx > 1.4)
					{
						_isUnactiveFreezed = false;
					}
					break;
				}
				case 2:
				{
					if (dy < -1.4)
					{
						_isActiveFreezed = false;
					}
					else if (dy > 1.4)
					{
						_isUnactiveFreezed = false;
					}
					break;
				}
				case 3:
				{
					if (dx > 1.4)
					{
						_isActiveFreezed = false;
					}
					else if (dx < -1.4)
					{
						_isUnactiveFreezed = false;
					}
					break;
				}
			}
		}
		
		public function update(ratio:Number):void
		{
			_costume.x = Math.round(_body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x);
			_costume.y = Math.round(_body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y);
			
			if (btn.isActive)
			{
				if (((getPosition() > _upperBound && _upperBound < _lowerBound) || (getPosition() < _upperBound && _upperBound > _lowerBound)) && !_isActiveFreezed)
				{
					_body.SetLinearVelocity(_velocityWhenActive);
				}
				else
				{
					_body.SetLinearVelocity(_nullVelocity);
				}
			}
			else
			{
				if (((getPosition() < _lowerBound && _upperBound < _lowerBound) || (getPosition() > _lowerBound && _upperBound > _lowerBound)) && !_isUnactiveFreezed)
				{
					_body.SetLinearVelocity(_velocityWhenNotActive);
				}
				else
				{
					_body.SetLinearVelocity(_nullVelocity);
				}
			}
			
			if (_body.GetLinearVelocity().x > 0.1 || _body.GetLinearVelocity().x < -0.1 || _body.GetLinearVelocity().y > 0.1 || _body.GetLinearVelocity().y < -0.1)
			{
				if (!_soundChannel)
				{
					_soundChannel = _soundManager.playSound("PlatformMove");
				}
			}
			else
			{
				if (_soundChannel)
				{
					_soundChannel.stop();
					_soundChannel = null;
				}
			}
		}
		
		public function resetPosition():void
		{
			_costume.x = _previousPosition.x = _body.GetPosition().x * _worldScale;
			_costume.y = _previousPosition.y = _body.GetPosition().y * _worldScale;
		}
		
		private function onSoundComplete(e:Event):void 
		{
			_soundChannel.stop();
			_soundChannel = null;
		}
		
		private function getPosition():Number
		{
			if (_kind == 0 || _kind == 2)
				return _body.GetPosition().y;
			else
				return _body.GetPosition().x;
		}
		
		override public function dispose():void 
		{
			btn = null;
			removeChild(_costume, true);
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			
			super.dispose();
		}
		
		public function get body():b2Body
		{
			return _body;
		}
		
		public function get kind():int
		{
			return int(_key.charAt(_key.length - 1));
		}
	}
}