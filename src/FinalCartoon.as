package  
{
	import assets.Assets;
	import flash.display.BitmapData;
	import helper.Constants;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class FinalCartoon extends Sprite 
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
		private var _nextBtn:Button;
		private var _counter:int = 0;
		private var _spr:Sprite;
		
		public function FinalCartoon()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_back = new Image(Assets.manager.getTexture("Back1"));
			_back.x = 568 * 0.5 - _back.width * 0.5;
			addChild(_back);
			
			_spr = new Sprite();
			addChild(_spr);
			
			_part1 = new Image(Assets.manager.getTexture("final1-1"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			_spr.addChild(_part1);
			
			_part2 = new Image(Assets.manager.getTexture("final1-2"));
			_part2.x = 568 - _part2.width;
			_part2.y = 0;
			_part2.alpha = 0;
			_spr.addChild(_part2);
			
			_part3 = new Image(Assets.manager.getTexture("final1-3"));
			_part3.x = 0;
			_part3.y = Constants.realHeight - _part3.height;
			_part3.alpha = 0;
			_spr.addChild(_part3);
			
			_skipBtn = new Button(Assets.manager.getTexture("SkipComix"), "", Assets.manager.getTexture("SkipComix"));
			_skipBtn.x = 568 - Constants.x0 - _skipBtn.width;;
			_skipBtn.y = Constants.realHeight - _skipBtn.height;
			_skipBtn.addEventListener(Event.TRIGGERED, closeCartoon);
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 1, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.delay = 1;
			tween1.moveTo(284 - _part1.width - 5, _part1.y);
			Starling.juggler.add(tween1);
			
			tween2 = new Tween(_part2, 1, Transitions.LINEAR);
			tween2.animate("alpha", 1);
			tween2.delay = 2;
			tween2.moveTo(284 + 5, _part2.y);
			Starling.juggler.add(tween2);
			
			tween3 = new Tween(_part3, 1, Transitions.LINEAR);
			tween3.animate("alpha", 1);
			tween3.delay = 3;
			tween3.moveTo(284 - _part1.width - 5, 170);
			tween3.onComplete = delay;
			Starling.juggler.add(tween3);
		}
		
		private function delay():void
		{
			Starling.juggler.tween(_spr, 2, { onComplete: showNext, alpha: 0 } );
		}
		
		private function showNext():void 
		{
			_spr.alpha = 1;
			++_counter;
			switch (_counter)
			{
				case 1:
				{
					show2();
					break;
				}
				case 2:
				{
					show3();
					break;
				}
				case 3:
				{
					show4();
					break;
				}
				case 4:
				{
					show5();
					break;
				}
			}
		}
		
		private function show2():void
		{
			_spr.removeChild(_part1, true);
			_spr.removeChild(_part2, true);
			_spr.removeChild(_part3, true);
			
			_part1 = new Image(Assets.manager.getTexture("final2-1"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			_spr.addChild(_part1);
			
			_part2 = new Image(Assets.manager.getTexture("final2-2"));
			_part2.x = 568 - _part2.width;
			_part2.y = 0;
			_part2.alpha = 0;
			_spr.addChild(_part2);
			
			_part3 = new Image(Assets.manager.getTexture("final2-3"));
			_part3.x = 0;
			_part3.y = Constants.realHeight - _part3.height;
			_part3.alpha = 0;
			if (Constants.realHeight == 320)
				_part3.scaleY = 0.9;
			_spr.addChild(_part3);
			
			_part4 = new Image(Assets.manager.getTexture("final2-4"));
			_part4.x = 568 - _part4.width;
			_part4.y = Constants.realHeight - _part4.height;
			_part4.alpha = 0;
			if (Constants.realHeight == 320)
				_part4.scaleY = 0.9;
			_spr.addChild(_part4);
			
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 1, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.moveTo(284 - _part1.width - 5, _part1.y);
			Starling.juggler.add(tween1);
			
			tween2 = new Tween(_part2, 1, Transitions.LINEAR);
			tween2.animate("alpha", 1);
			tween2.delay = 1;
			tween2.moveTo(284 + 5, _part2.y);
			Starling.juggler.add(tween2);
			
			tween3 = new Tween(_part3, 1, Transitions.LINEAR);
			tween3.animate("alpha", 1);
			tween3.delay = 2;
			tween3.moveTo(284 - _part1.width - 5, 170);
			Starling.juggler.add(tween3);
			
			tween4 = new Tween(_part4, 1, Transitions.LINEAR);
			tween4.animate("alpha", 1);
			tween4.delay = 3;
			tween4.moveTo(284 + 5, 170);
			tween4.onComplete = delay;
			Starling.juggler.add(tween4);
		}
		
		private function show3():void
		{
			_spr.removeChild(_part1, true);
			_spr.removeChild(_part2, true);
			_spr.removeChild(_part3, true);
			_spr.removeChild(_part4, true);
			
			_part1 = new Image(Assets.manager.getTexture("final3-1"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			_spr.addChild(_part1);
			
			_part2 = new Image(Assets.manager.getTexture("final3-2"));
			_part2.x = 568 - _part2.width;
			_part2.y = 0;
			_part2.alpha = 0;
			_spr.addChild(_part2);
			
			_part3 = new Image(Assets.manager.getTexture("final3-3"));
			_part3.x = 0;
			_part3.y = Constants.realHeight - _part3.height;
			_part3.alpha = 0;
			_spr.addChild(_part3);
			
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 1, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.moveTo(284 - _part1.width - 5, _part1.y);
			Starling.juggler.add(tween1);
			
			tween2 = new Tween(_part2, 1, Transitions.LINEAR);
			tween2.animate("alpha", 1);
			tween2.delay = 1;
			tween2.moveTo(284 + 5, _part2.y);
			Starling.juggler.add(tween2);
			
			tween3 = new Tween(_part3, 1, Transitions.LINEAR);
			tween3.animate("alpha", 1);
			tween3.delay = 2;
			tween3.moveTo(284 - _part1.width - 5, 170);
			tween3.onComplete = delay;
			Starling.juggler.add(tween3);
		}
		
		private function show4():void
		{
			_spr.removeChild(_part1, true);
			_spr.removeChild(_part2, true);
			_spr.removeChild(_part3, true);
			
			_part1 = new Image(Assets.manager.getTexture("final4-1"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			if (Constants.realHeight == 320)
				_part1.scaleY = 0.9;
			_spr.addChild(_part1);
			
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 1, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.moveTo(284 - _part1.width * 0.5, _part1.y);
			tween1.onComplete = delay;
			Starling.juggler.add(tween1);
		}
		
		private function show5():void
		{
			_spr.removeChild(_part1, true);
			
			_part1 = new Image(Assets.manager.getTexture("final5-1"));
			_part1.x = 0;
			_part1.y = 0;
			_part1.alpha = 0;
			if (Constants.realHeight == 320)
				_part1.scaleY = 0.9;
			_spr.addChild(_part1);
			
			addChild(_skipBtn);
			
			tween1 = new Tween(_part1, 1, Transitions.LINEAR);
			tween1.animate("alpha", 1);
			tween1.moveTo(284 - _part1.width * 0.5, _part1.y);
			Starling.juggler.add(tween1);
		}
		
		private function closeCartoon():void
		{
			dispatchEvent(new CustomEvent(CustomEvent.MAIN_MENU));
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
			_spr.removeChild(_part1, true);
			_spr.removeChild(_part2, true);
			_spr.removeChild(_part3, true);
			_spr.removeChild(_part4, true);
			_spr.removeChild(_back, true);
			_spr.removeChild(_skipBtn, true);
			_part1 = null;
			_part2 = null;
			_part3 = null;
			_part4 = null;
			_skipBtn = null;
			_back = null;
			
			super.dispose();
		}
	}

}