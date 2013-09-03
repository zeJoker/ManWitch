package objects
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2WeldJoint;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
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
	public class Box extends Sprite 
	{
		public static const USUAL:int = 1;
		public static const JUMPING:int = 2;
		public static const FLYING:int = 3;
		public var kind:int;
		public static var sizes:Point = new Point(32, 32);
		public var startingPosition:Point;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var collisionFunc:Function;
		private var tapFunc:Function;
		private var _costume:MovieClip;
		private var _joint:b2Joint;
		private var _fixed:Boolean;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _smokeFX:MovieClip;
		private var _editingArea:Image;
		private var _previousPosition:Point = new Point(0, 0);
		private var _previousAngle:Number = 0;
		private var _animations:Dictionary = new Dictionary();
		
		public function Box(X:Number, Y:Number, boxKind:int) 
		{
			kind = boxKind;
			_fixed = true;
			switch (kind)
			{
				case 1:
				{
					name = "Box";
					addAnimation(name + "Idle", 1, true);
					addAnimation(name + "Action", 20, false);
					addAnimation(name + "CollidedLeft", 15, false);
					addAnimation(name + "CollidedRight", 15, false);
					break;
				}
				case 2:
				{
					name = "JumpingBox";
					addAnimation(name + "Idle", 1, true);
					addAnimation(name + "Action", 20, false);
					break;
				}
				case 3:
				{
					name = "FlyingBox";
					addAnimation(name + "Idle", 1, true);
					addAnimation(name + "Action", 20, false);
					break;
				}
			}
			startingPosition = new Point(X, Y);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_smokeFX = new MovieClip(Assets.getAtlasTextures("Appearing"), 10);
			_smokeFX.pivotX += 50;
			_smokeFX.pivotY += 50;
			_smokeFX.loop = false;
			_smokeFX.smoothing = TextureSmoothing.NONE;
			_smokeFX.touchable = false;
			_smokeFX.addEventListener(Event.COMPLETE, onFXComplete);
			
			_editingArea = new Image(Assets.getAtlasTexture(name));
			_editingArea.x = startingPosition.x - 36;
			_editingArea.y = startingPosition.y - 36;
			_editingArea.smoothing = TextureSmoothing.NONE;
			_editingArea.visible = false;
			_editingArea.touchable = false;
			addChild(_editingArea);
			
			createBody();
			setFunctions();
			switchAnimation(name + "Idle");
		}
		
		public function showFX():void
		{
			_smokeFX.stop();
			_smokeFX.play();
			addChild(_smokeFX);
			Starling.juggler.add(_smokeFX);
			_smokeFX.x = _body.GetPosition().x * _worldScale;
			_smokeFX.y = _body.GetPosition().y * _worldScale;
		}
		
		private function onFXComplete(e:Event):void 
		{
			removeChild(_smokeFX);
			Starling.juggler.remove(_smokeFX);
			_smokeFX.stop();
		}
		
		public function showArea():void
		{
			_editingArea.visible = true;
			_costume.visible = false;
		}
		
		public function hideArea():void
		{
			_editingArea.visible = false;
			_costume.visible = true;
		}
		
		public function moveBody(movX:Number, movY:Number):void
		{
			_world.DestroyJoint(_joint);
			_body.SetPosition(new b2Vec2( movX, movY));
			var weldJointDef:b2WeldJointDef = new b2WeldJointDef();
			weldJointDef.Initialize(_body, _world.GetGroundBody(), _world.GetGroundBody().GetWorldCenter());
			_joint = _world.CreateJoint(weldJointDef);
		}
		
		private function addAnimation(key:String, fps:Number, looped:Boolean):void
		{
			_animations[key] = new MovieClip(Assets.manager.getTextures(key), fps);
			_animations[key].loop = looped;
			_animations[key].name = key;
			_animations[key].smoothing = TextureSmoothing.NONE;
		}
		
		private function switchAnimation(key:String):void
		{
			if (_costume)
			{
				_costume.stop();
				Starling.juggler.remove(_costume);
				removeChild(_costume);
			}
			_costume = _animations[key];
			_costume.play();
			_costume.pivotX = _costume.width >> 1;
			_costume.pivotY = _costume.height >> 1;
			_costume.x = Math.round( -_costume.width >> 1);
			_costume.y = Math.round( -_costume.height >> 1);
			addChild(_costume);
			Starling.juggler.add(_costume);
		}
		
		private function createBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			//bodyDef.type = b2Body.b2_staticBody;
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(startingPosition.x / _worldScale, startingPosition.y / _worldScale);
			bodyDef.userData = this;
			
			_body = _world.CreateBody(bodyDef);
			_body.SetSleepingAllowed(false);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(sizes.x * 0.5 / _worldScale, sizes.y * 0.5 / _worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = 0.2;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = shape;
			_body.CreateFixture(fixtureDef);
			
			var weldJointDef:b2WeldJointDef = new b2WeldJointDef();
			weldJointDef.Initialize(_body, _world.GetGroundBody(), _world.GetGroundBody().GetWorldCenter());
			_joint = _world.CreateJoint(weldJointDef);
		}
		
		private function setFunctions():void
		{
			switch (kind)
			{
				case 1:
				{
					collisionFunc = collidedAnimation;
					tapFunc = turnOnGravity;
					break;
				}
				case 2:
				{
					collisionFunc = jumpBox;
					tapFunc = turnOnGravity;
					break;
				}
				case 3:
				{
					collisionFunc = doNothing;
					tapFunc = turnOnGravity;
					break;
				}
			}
		}
		
		// Universal function
		private function doNothing(collidedBody:b2Body = null):void
		{
			//
		}
		
		// Functions for taping
		private function turnOnGravity():void
		{
			if (_fixed)
			{
				_fixed = false;
				if (_joint)
				{
					_world.DestroyJoint(_joint);
					_joint = null;
				}
				if (!_costume.isComplete)
				{
					switchAnimation(name + "Action");
					_costume.loop = false;
				}
			}
		}
		
		// Functions for collision
		private function jumpBox(collidedBody:b2Body):void
		{
			var impulse:b2Vec2 = new b2Vec2(0, 0);
			var difference:b2Vec2 = new b2Vec2(_body.GetPosition().x - collidedBody.GetPosition().x, _body.GetPosition().y - collidedBody.GetPosition().y);
			if (difference.y > 25 / _worldScale)
			{
				impulse.y = -7;
				collidedBody.SetLinearVelocity(new b2Vec2(0, 0));
				_soundManager.playSound("Jump2");
			}
			
			collidedBody.ApplyImpulse(impulse, collidedBody.GetPosition());
			
			switchAnimation(name + "Action");
			_costume.loop = false;
		}
		
		private function collidedAnimation(collided:b2Body):void
		{
			if (_costume.isComplete)
			{
				if (kind == 1)
				{
					if (collided.GetPosition().x - _body.GetPosition().x > 0)
						switchAnimation(name + "CollidedRight");
					else
						switchAnimation(name + "CollidedLeft");
				}
			}
		}
		
		public function onCollision(collided:b2Body):void
		{
			collisionFunc(collided);
		}
		
		public function onTap():void
		{
			tapFunc();
		}
		
		override public function dispose():void 
		{
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			removeChild(_costume, true);
			
			super.dispose();
		}
		
		public function update(ratio:Number, passedTime:Number):void
		{
			_costume.x = _body.GetPosition().x * _worldScale * ratio + (1 - ratio) * _previousPosition.x;
			_costume.y = _body.GetPosition().y * _worldScale * ratio + (1 - ratio) * _previousPosition.y;
			_costume.rotation = _body.GetAngle() * ratio + (1 - ratio) * _previousAngle;
			
			if (kind == 3 && !_joint && !_fixed)
			{
				_body.SetFixedRotation(true);
				_body.ApplyForce(new b2Vec2(0, -25 * passedTime * 50), new b2Vec2(_body.GetPosition().x, _body.GetPosition().y));
			}
		}
		
		public function resetPosition():void
		{
			_costume.x = _previousPosition.x = _body.GetPosition().x * _worldScale;
			_costume.y = _previousPosition.y = _body.GetPosition().y * _worldScale;
			_costume.rotation = _previousAngle = _body.GetAngle();
		}
		
		public function getBorders():Rectangle
		{
			return new Rectangle(_editingArea.x + 2, _editingArea.y + 2, 62, 62);
		}
		
		public function get body():b2Body
		{
			return _body;
		}
		
		public function fixed():Boolean
		{
			return _fixed;
		}
		
		public function get costumeX():Number
		{
			return _costume.x;
		}
		
		public function get costumeY():Number
		{
			return _costume.y;
		}
		
		public function set costumeX(value:Number):void
		{
			_costume.x = value;
		}
		
		public function set costumeY(value:Number):void
		{
			_costume.y = value;
		}
	}

}