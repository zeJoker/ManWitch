package objects 
{
	import assets.Assets;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.geom.Point;
	import helper.Category;
	import physics.PhysicWorld;
	import starling.animation.Transitions;
	import starling.animation.Tween;
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
	public class Star extends Sprite 
	{
		public var catched:Boolean;
		
		private var _world:b2World = PhysicWorld.world;
		private var _worldScale:int = PhysicWorld.SCALE;
		private var _body:b2Body;
		private var _startingPosition:Point;
		private var _costume:MovieClip;
		private var _timer:Number;
		private var tween:Tween;
		
		public function Star(X:Number, Y:Number) 
		{
			_startingPosition = new Point(X, Y);
			_timer = 1 + Math.random() * 2;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createBody();
			createCostume();
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
			fixtureDef.filter.categoryBits = Category.SENSOR;
			fixtureDef.filter.maskBits = Category.PLAYER;
			fixtureDef.isSensor = true;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(_startingPosition.x / _worldScale, _startingPosition.y / _worldScale);
			bodyDef.userData = this;
			_body = _world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
			_body.SetSleepingAllowed(false);
		}
		
		private function createCostume():void
		{
			_costume = new MovieClip(Assets.manager.getTextures("StarBlinking0001"));
			_costume.pivotX = 12;
			_costume.pivotY = 12;
			_costume.x = _startingPosition.x;
			_costume.y = _startingPosition.y;
			addChild(_costume);
			Starling.juggler.add(_costume);
		}
		
		private function hideBody():void
		{
			_body.SetUserData(null);
			_body.DestroyFixture(_body.GetFixtureList());
			_world.DestroyBody(_body);
			_body = null;
		}
		
		public function reset():void
		{
			if (!_body)
			{
				createBody();
			}
			_costume.scaleX = 1;
			_costume.scaleY = 1;
			_costume.rotation = 0;
			if (catched)
			{
				catched = false;
				Starling.juggler.remove(tween);
			}
			visible = true;
			_timer = 1 + Math.random() * 2;
		}
		
		public function update(timePassed:Number):void
		{
			if (!catched)
				_timer -= timePassed;
			if (_timer < 0)
			{
				_timer = 1 + Math.random() * 2;
				Starling.juggler.remove(_costume);
				removeChild(_costume, true);
				_costume = new MovieClip(Assets.manager.getTextures("StarBlinking"), 12);
				_costume.loop = false;
				_costume.addEventListener(Event.COMPLETE, onBlinkingComplete);
				_costume.pivotX = 12;
				_costume.pivotY = 12;
				_costume.x = _startingPosition.x;
				_costume.y = _startingPosition.y;
				addChild(_costume);
				Starling.juggler.add(_costume);
			}
			if (catched && _body)
			{
				hideBody();
			}
		}
		
		private function onBlinkingComplete(e:Event):void 
		{
			if (!catched)
			{
				Starling.juggler.remove(_costume);
				removeChild(_costume, true);
				_costume = new MovieClip(Assets.manager.getTextures("StarBlinking0001"));
				_costume.pivotX = 12;
				_costume.pivotY = 12;
				_costume.x = _startingPosition.x;
				_costume.y = _startingPosition.y;
				addChild(_costume);
				Starling.juggler.add(_costume);
			}
		}
		
		public function disappear():void
		{
			catched = true;
			tween = new Tween(_costume, 0.5, Transitions.LINEAR);
			tween.animate("scaleX", 0);
			tween.animate("scaleY", 0);
			tween.animate("rotation", Math.PI * 2);
			tween.onComplete = hideStar;
			Starling.juggler.add(tween);
		}
		
		private function hideStar():void 
		{
			visible = false;
		}
		
		override public function dispose():void 
		{
			if (_body)
			{
				_body.SetUserData(null);
				_body.DestroyFixture(_body.GetFixtureList());
				_world.DestroyBody(_body);
			}
			removeChild(_costume, true);
			
			super.dispose();
		}
	}

}