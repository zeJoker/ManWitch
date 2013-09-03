package  
{
	import assets.Assets;
	import helper.Constants;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Cartoon extends Sprite 
	{
		private var _back:Image;
		private var _part1:Image;
		private var _part2:Image;
		private var _part3:Image;
		private var _part4:Image;
		private var tween1:Tween;
		private var tween2:Tween;
		private var tween3:Tween;
		private var tween4:Tween;
		private var _skipBtn:Button;
		
		public function Cartoon()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_back = new Image(Assets.manager.getTexture("Back1"));
			_back.x = 568 * 0.5 - _back.width * 0.5;
			addChild(_back);
			
			_part1 = new Image(Assets.manager.getTexture("start01"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			addChild(_part1);
			
			_part2 = new Image(Assets.manager.getTexture("start02"));
			_part2.x = 568 - _part2.width;
			_part2.y = 0;
			_part2.alpha = 0;
			addChild(_part2);
			
			_part3 = new Image(Assets.manager.getTexture("start03"));
			_part3.x = 0;
			_part3.y = Constants.realHeight - _part3.height;
			_part3.alpha = 0;
			if (Constants.realHeight == 320)
				_part3.scaleY = 0.9;
			addChild(_part3);
			
			_part4 = new Image(Assets.manager.getTexture("start04"));
			_part4.x = 568 - _part4.width;
			_part4.y = Constants.realHeight - _part4.height;
			_part4.alpha = 0;
			if (Constants.realHeight == 320)
				_part4.scaleY = 0.9;
			addChild(_part4);
			
			_skipBtn = new Button(Assets.manager.getTexture("SkipComix"), "", Assets.manager.getTexture("SkipComix"));
			_skipBtn.x = 568 - Constants.x0 - _skipBtn.width;
			_skipBtn.y = Constants.realHeight - _skipBtn.height;
			_skipBtn.addEventListener(Event.TRIGGERED, closeCartoon);
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 0.5, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.delay = 1;
			tween1.moveTo(284 - _part1.width - 5, _part1.y);
			Starling.juggler.add(tween1);
			
			tween2 = new Tween(_part2, 0.5, Transitions.LINEAR);
			tween2.animate("alpha", 1);
			tween2.delay = 2;
			tween2.moveTo(284 + 5, _part2.y);
			Starling.juggler.add(tween2);
			
			tween3 = new Tween(_part3, 0.5, Transitions.LINEAR);
			tween3.animate("alpha", 1);
			tween3.delay = 3;
			tween3.moveTo(284 - _part1.width - 5, 170);
			Starling.juggler.add(tween3);
			
			tween4 = new Tween(_part4, 0.5, Transitions.LINEAR);
			tween4.animate("alpha", 1);
			tween4.delay = 4;
			tween4.moveTo(284 + 5, 170);
			Starling.juggler.add(tween4);
		}
		
		private function closeCartoon():void
		{
			dispatchEvent(new CustomEvent(CustomEvent.RESUME_GAME));
		}
		
		override public function dispose():void 
		{
			Starling.juggler.remove(tween1);
			Starling.juggler.remove(tween2);
			Starling.juggler.remove(tween3);
			Starling.juggler.remove(tween4);
			tween1 = null;
			tween2 = null;
			tween3 = null;
			tween4 = null;
			removeChild(_part1, true);
			removeChild(_part2, true);
			removeChild(_part3, true);
			removeChild(_part4, true);
			removeChild(_back, true);
			removeChild(_skipBtn, true);
			_part1 = null;
			_part2 = null;
			_part3 = null;
			_part4 = null;
			_skipBtn = null;
			
			super.dispose();
		}
	}

}