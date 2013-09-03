package helper 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2Joint;
	import objects.Btn;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Trigger 
	{
		public var button:Btn;
		public var target:b2Body;
		public var joint:b2Joint;
		public var targets:Array = [];
		
		private var _reusable:Boolean = false;
		private var _activated:Boolean = false;
		private var action:Function;
		
		public function Trigger(kind:int) 
		{
			switch (kind)
			{
				case 1:
				{
					action = simpleAction;
					break;
				}
				case 2:
				{
					action = setDynamic;
					break;
				}
			}
		}
		
		private function simpleAction():void
		{
			if (target.GetPosition().y > 4)
			{
				target.ApplyForce(new b2Vec2(0, -50), target.GetPosition());
			}
		}
		
		private function setDynamic():void
		{
			for (var i:int = 0; i < targets.length; i++)
			{
				targets[i].activate();
			}
			button.isActive = false;
		}
		
		private function doNothing():void 
		{
			// Null
		}
		
		public function update():void
		{
			if (button.isActive)
			{
				action();
			}
		}
		
		public function get activated():Boolean
		{
			return _activated;
		}
	}

}