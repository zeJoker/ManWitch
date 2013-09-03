package physics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DestructionListener;
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author TheJoker
	 */
	public class PhysicWorld
	{
		public static const SCALE:Number = 30;
		private static var _world:b2World;
		
		public function PhysicWorld()
		{
			// constructor
			_world = new b2World(new b2Vec2(0, 10), true);
		}
		
		static public function get world():b2World 
		{
			if (_world == null)
				_world = new b2World(new b2Vec2(0, 10), true);
			
			return _world;
		}
		
		static public function set world(value:b2World):void 
		{
			_world = value;
		}
		
	}

}