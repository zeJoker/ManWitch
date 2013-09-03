package physics
{
	import adobe.utils.CustomActions;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.geom.Point;
	import objects.Box;
	import objects.Btn;
	import objects.Cannon;
	import objects.CannonBall;
	import objects.Door;
	import objects.Key;
	import objects.Player;
	import objects.Star;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class PlayerContactListener extends b2ContactListener 
	{
		private var _player:Player;
		private var _wmf:b2WorldManifold;
		private var _door:Door;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		
		public function PlayerContactListener() 
		{
			
		}
		
		override public function BeginContact(contact:b2Contact):void 
		{
			// Player's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Player)
			{
				// With star
				if (contact.GetFixtureB().GetBody().GetUserData() is Star)
				{
					var star:Star = contact.GetFixtureB().GetBody().GetUserData();
					if (!star.catched)
					{
						//trace("star catched!");
						//star.catched = true;
						//star.visible = false;
						star.disappear();
						_soundManager.playSound("GetStar");
					}
				}
				// With key TODO!
				if (contact.GetFixtureB().GetBody().GetUserData() is Key)
				{
					Game.state = Game.STATE_VICTORY;
				}
				if (contact.GetFixtureB().GetBody().GetUserData() is CannonBall)
				{
					Game.state = Game.STATE_PLAYER_DEAD;
					if (contact.GetFixtureA().GetBody().GetPosition().x < contact.GetFixtureB().GetBody().GetPosition().x)
						(contact.GetFixtureA().GetBody().GetUserData() as Player).direction = "Right";
					else
						(contact.GetFixtureA().GetBody().GetUserData() as Player).direction = "Left";
				}
				if (contact.GetFixtureB().GetBody().GetUserData() is String)
				{
					if (contact.GetFixtureB().GetBody().GetUserData().charAt(0) == "S")
					{
						Game.state = Game.STATE_PLAYER_DEAD;
						if (contact.GetFixtureA().GetBody().GetPosition().x < contact.GetFixtureB().GetBody().GetPosition().x)
							(contact.GetFixtureA().GetBody().GetUserData() as Player).direction = "Right";
						else
							(contact.GetFixtureA().GetBody().GetUserData() as Player).direction = "Left";
					}
				}
				
				_player = contact.GetFixtureA().GetBody().GetUserData();
				_wmf = new b2WorldManifold();
				contact.GetWorldManifold(_wmf);
				
				var dx:Number = _wmf.m_points[0].x - _player.body.GetPosition().x;
				var dy:Number = _wmf.m_points[0].y - _player.body.GetPosition().y;
				var angle:Number = Math.atan2(dy, dx) * 180 / Math.PI;
				if (angle < 135 && angle > 45)
				{
					_player.connectedBodies.push(contact.GetFixtureB().GetBody());
				}
				if (angle < 180 && angle > 0)
				{
					_player.connectedBodies2.push(contact.GetFixtureB().GetBody());
					_player.contactPoints.push(_wmf.m_points[0]);
				}
			}
			
			// Box's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Box)
			{
				if (contact.GetFixtureB().GetBody().GetType() == b2Body.b2_dynamicBody)
				{
					contact.GetFixtureA().GetBody().GetUserData().onCollision(contact.GetFixtureB().GetBody());
				}
			}
			
			// Button's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Btn)
			{
				if (contact.GetFixtureB().GetBody().GetType() == b2Body.b2_staticBody)
				{
					contact.GetFixtureA().GetBody().GetUserData().isActive = true;
					_soundManager.playSound("Button");
				}
			}
			
			// CannonBall's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is CannonBall)
			{
				if (!(contact.GetFixtureB().GetBody().GetUserData() is Cannon))
				{
					contact.GetFixtureA().GetBody().GetUserData().explode();
				}
			}
			
			// Door's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Door)
			{
				_door = contact.GetFixtureA().GetBody().GetUserData();
				_wmf = new b2WorldManifold();
				contact.GetWorldManifold(_wmf);
				_door.enterContact(new b2Vec2(_wmf.m_points[0].x, _wmf.m_points[0].y));
			}
			
			// ========================================================
			// Double
			if (contact.GetFixtureB().GetBody().GetUserData() is Player)
			{
				// With coin
				if (contact.GetFixtureA().GetBody().GetUserData() is Star)
				{
					star = contact.GetFixtureA().GetBody().GetUserData();
					if (!star.catched)
					{
						//trace("star earned!");
						//star.catched = true;
						//star.visible = false;
						star.disappear();
						_soundManager.playSound("GetStar");
					}
				}
				// With key
				if (contact.GetFixtureA().GetBody().GetUserData() is Key)
				{
					Game.state = Game.STATE_VICTORY;
				}
				if (contact.GetFixtureA().GetBody().GetUserData() is CannonBall)
				{
					Game.state = Game.STATE_PLAYER_DEAD;
					if (contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x)
						(contact.GetFixtureB().GetBody().GetUserData() as Player).direction = "Right";
					else
						(contact.GetFixtureB().GetBody().GetUserData() as Player).direction = "Left";
				}
				if (contact.GetFixtureA().GetBody().GetUserData() is String)
				{
					if (contact.GetFixtureA().GetBody().GetUserData().charAt(0) == "S")
					{
						Game.state = Game.STATE_PLAYER_DEAD;
						if (contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x)
							(contact.GetFixtureB().GetBody().GetUserData() as Player).direction = "Right";
						else
							(contact.GetFixtureB().GetBody().GetUserData() as Player).direction = "Left";
					}
				}
				
				_player = contact.GetFixtureB().GetBody().GetUserData();
				_wmf = new b2WorldManifold();
				contact.GetWorldManifold(_wmf);
				
				dx = _wmf.m_points[0].x - _player.body.GetPosition().x;
				dy = _wmf.m_points[0].y - _player.body.GetPosition().y;
				angle = Math.atan2(dy, dx) * 180 / Math.PI;
				if (angle < 135 && angle > 45)
				{
					_player.connectedBodies.push(contact.GetFixtureA().GetBody());
				}
				if (angle < 210 && angle > -30)
				{
					_player.connectedBodies2.push(contact.GetFixtureA().GetBody());
					_player.contactPoints.push(_wmf.m_points[0]);
				}
			}
			
			// Box's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Box)
			{
				if (contact.GetFixtureA().GetBody().GetType() == b2Body.b2_dynamicBody)
				{
					contact.GetFixtureB().GetBody().GetUserData().onCollision(contact.GetFixtureA().GetBody());
				}
			}
			
			// Button's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Btn)
			{
				if (contact.GetFixtureA().GetBody().GetType() == b2Body.b2_staticBody)
				{
					contact.GetFixtureB().GetBody().GetUserData().isActive = true;
					_soundManager.playSound("Button");
				}
			}
			
			// CannonBall's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is CannonBall)
			{
				if (contact.GetFixtureA().GetBody().GetUserData() is Cannon)
				{
					if (contact.GetFixtureA().GetBody().GetUserData() != contact.GetFixtureB().GetBody().GetUserData().cannon)
						contact.GetFixtureB().GetBody().GetUserData().explode();
				}
				else
				{
					contact.GetFixtureB().GetBody().GetUserData().explode();
				}
			}
			
			// Door's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Door)
			{
				_door = contact.GetFixtureB().GetBody().GetUserData();
				_wmf = new b2WorldManifold();
				contact.GetWorldManifold(_wmf);
				_door.enterContact(new b2Vec2(_wmf.m_points[0].x, _wmf.m_points[0].y));
			}
		}
		
		override public function EndContact(contact:b2Contact):void 
		{
			// Player's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Player)
			{
				_player = contact.GetFixtureA().GetBody().GetUserData();
				
				var body:b2Body = contact.GetFixtureB().GetBody()
				for (var i:int = 0; i < _player.connectedBodies.length; i++)
				{
					if (_player.connectedBodies[i] == body)
					{
						_player.connectedBodies.splice(i, 1);
						break;
					}
				}
				for (i = 0; i < _player.connectedBodies2.length; i++)
				{
					if (_player.connectedBodies2[i] == body)
					{
						_player.connectedBodies2.splice(i, 1);
						_player.contactPoints.splice(i, 1);
						break;
					}
				}
			}
			
			// Button's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Btn)
			{
				if (contact.GetFixtureB().GetBody().GetType() == b2Body.b2_staticBody)
				{
					contact.GetFixtureA().GetBody().GetUserData().isActive = false;
					_soundManager.playSound("Button");
				}
			}
			
			// Door's contacts
			if (contact.GetFixtureA().GetBody().GetUserData() is Door)
			{	
				_door = contact.GetFixtureA().GetBody().GetUserData();
				body = contact.GetFixtureB().GetBody();
				_door.exitContact(body.GetPosition());
			}
			
			// ==================================================================
			// Double
			// Player's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Player)
			{				
				_player = contact.GetFixtureB().GetBody().GetUserData();
				
				body = contact.GetFixtureA().GetBody()
				for (i = 0; i < _player.connectedBodies.length; i++)
				{
					if (_player.connectedBodies[i] == body)
					{
						_player.connectedBodies.splice(i, 1);
						break;
					}
				}
				for (i = 0; i < _player.connectedBodies2.length; i++)
				{
					if (_player.connectedBodies2[i] == body)
					{
						_player.connectedBodies2.splice(i, 1);
						_player.contactPoints.splice(i, 1);
						break;
					}
				}
			}
			
			// Button's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Btn)
			{
				if (contact.GetFixtureA().GetBody().GetType() == b2Body.b2_staticBody)
				{
					contact.GetFixtureB().GetBody().GetUserData().isActive = false;
					_soundManager.playSound("Button");
				}
			}
			
			// Door's contacts
			if (contact.GetFixtureB().GetBody().GetUserData() is Door)
			{
				_door = contact.GetFixtureB().GetBody().GetUserData();
				body = contact.GetFixtureA().GetBody();
				_door.exitContact(body.GetPosition());
			}
		}
		
		//override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void 
		//{
			//if (contact.GetFixtureA().GetBody().GetUserData() is Box)
			//{
				//trace(impulse.normalImpulses[0]);
				//if (impulse.normalImpulses[0] > 2)
				//{
					//if (contact.GetFixtureB().GetBody().GetType() == b2Body.b2_staticBody)
					//{
						//if (contact.GetFixtureB().GetBody().GetPosition().y - contact.GetFixtureA().GetBody().GetPosition().y > 0.9)
							//_soundManager.playSound("BoxFall");
					//}
				//}
			//}
			//if (contact.GetFixtureB().GetBody().GetUserData() is Box)
			//{
				//trace(impulse.normalImpulses[0]);
				//if (impulse.normalImpulses[0] > 2)
				//{
					//if (contact.GetFixtureA().GetBody().GetType() == b2Body.b2_staticBody)
					//{
						//if (contact.GetFixtureA().GetBody().GetPosition().y - contact.GetFixtureB().GetBody().GetPosition().y > 0.9)
							//_soundManager.playSound("BoxFall");
					//}
				//}
			//}
		//}
	}

}