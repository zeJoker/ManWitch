package  
{
	import assets.Assets;
	import com.playhaven.PlayHaven;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import helper.Constants;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Victory extends Sprite 
	{
		[Embed (source = "../media/particle1.pex", mimeType = "application/octet-stream")]
		private const FireworksConfig:Class;
		
		private var _back:Image;
		private var _happySteve:Image;
		private var _star1:Image;
		private var _star2:Image;
		private var _star3:Image;
		private var _restartButton:Button;
		private var _nextButton:Button;
		private var _menuButton:Button;
		private var _moreGamesButton:Button;
		private var _fadeImage:Image;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _fireworks:PDParticleSystem;
		private var _removeAds:Button;
		
		public function Victory() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_fadeImage = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
			_fadeImage.alpha = 0;
			addChild(_fadeImage);
			
			_fireworks = new PDParticleSystem(XML(new FireworksConfig()), Assets.getAtlasTexture("StarBlinking0001"));
			addChild(_fireworks);
			Starling.juggler.add(_fireworks);
			
			_back = new Image(Assets.manager.getTexture("VictoryBack"));
			_back.x = -10;
			_back.y = 384;
			addChild(_back);
			
			_happySteve = new Image(Assets.getAtlasTexture("HappySteve"));
			_happySteve.pivotX += 90;
			_happySteve.pivotY += 200;
			addChild(_happySteve);
			
			_restartButton = new Button(Assets.manager.getTexture("RestartButton"), "", Assets.manager.getTexture("RestartButtonClicked"));
			_restartButton.x = 568;
			_restartButton.y = 130;
			_restartButton.addEventListener(Event.TRIGGERED, onRestart);
			addChild(_restartButton);
			
			_menuButton = new Button(Assets.manager.getTexture("MenuButton"), "", Assets.manager.getTexture("MenuButtonClicked"));
			_menuButton.x = 568;
			_menuButton.y = 70;
			_menuButton.addEventListener(Event.TRIGGERED, onMenu);
			addChild(_menuButton);
			
			_nextButton = new Button(Assets.manager.getTexture("NextLevelButton"), "", Assets.manager.getTexture("NextLevelButtonClicked"));
			_nextButton.x = 568;
			_nextButton.y = 10;
			_nextButton.addEventListener(Event.TRIGGERED, onNext);
			addChild(_nextButton);
			
			_moreGamesButton = new Button(Assets.getAtlasTexture("MoreGamesBtn"), "", Assets.getAtlasTexture("MoreGamesBtnClicked"));
			_moreGamesButton.x = 568;
			_moreGamesButton.y = 190;
			_moreGamesButton.addEventListener(Event.TRIGGERED, onMoreGames);
			addChild(_moreGamesButton);
			
			_removeAds = new Button(Assets.getAtlasTexture("RemoveAds"), "", Assets.getAtlasTexture("RemoveAdsClicked"));
			_removeAds.x = 568;
			_removeAds.y = 250;
			_removeAds.addEventListener(Event.TRIGGERED, onRemoveAds);
			addChild(_removeAds);
			IAP.addButton(_removeAds);
			if (IAP.purchased)
			{
				_removeAds.visible = false;
			}
			
			_star1 = new Image(Assets.manager.getTexture("Star1"));
			_star1.x = 284 - 130;
			_star1.y = 75;
			_star1.pivotX += 25;
			_star1.pivotY += 25;
			addChild(_star1);
			
			_star2 = new Image(Assets.manager.getTexture("Star2"));
			_star2.x = 284 - 250;
			_star2.y = 205;
			_star1.pivotX += 25;
			_star1.pivotY += 25;
			addChild(_star2);
			
			_star3 = new Image(Assets.manager.getTexture("Star3"));
			_star3.x = 274;
			_star3.y = 240;
			_star3.pivotX += 25;
			_star3.pivotY += 25;
			addChild(_star3);
		}
		
		public function start(fromX:Number, fromY:Number):void
		{
			reset();
			
			Starling.juggler.tween(_fadeImage, 1, {
				transition: Transitions.LINEAR,
				alpha: 0.9
			});
			
			_fireworks.emitterX = fromX;
			_fireworks.emitterY = fromY;
			_fireworks.start(0.2);
			
			_happySteve.x = fromX;
			_happySteve.y = fromY;
			_happySteve.scaleX = 0.4;
			_happySteve.scaleY = 0.4;
			Starling.juggler.tween(_happySteve, 1, {
				transition: Transitions.LINEAR,
				x: 200,
				y: 210,
				scaleX: 1,
				scaleY: 1
			});
			
			Starling.juggler.tween(_back, 1, {
				transition: Transitions.LINEAR,
				y: 290
			});
				
			Starling.juggler.tween(_nextButton, 0.5, {
				transition: Transitions.LINEAR,
				x: 350,
				delay: 0.25
			});
			
			Starling.juggler.tween(_menuButton, 0.5, {
				transition: Transitions.LINEAR,
				x: 350,
				delay: 0.65
			});	
			
			Starling.juggler.tween(_restartButton, 0.5, {
				transition: Transitions.LINEAR,
				x: 350,
				delay: 1.05 
			});	
			
			Starling.juggler.tween(_moreGamesButton, 0.5, {
				transition: Transitions.LINEAR,
				x: 350,
				delay: 1.45 
			});	
			
			Starling.juggler.tween(_removeAds, 0.5, {
				transition: Transitions.LINEAR,
				x: 350,
				delay: 1.85 
			});	
		}
		
		private function reset():void
		{
			_nextButton.x = 568;
			_menuButton.x = 568;
			_restartButton.x = 568;
			_moreGamesButton.x = 568;
			_removeAds.x = 568;
			_back.y = 384;
		}
		
		public function updateStars(count:int):void
		{
			switch (count)
			{
				case 0:
				{
					_star1.visible = false;
					_star2.visible = false;
					_star3.visible = false;
					break;
				}
				case 1:
				{
					_star1.visible = true;
					_star2.visible = false;
					_star3.visible = false;
					break;
				}
				case 2:
				{
					_star1.visible = true;
					_star2.visible = true;
					_star3.visible = false;
					break;
				}
				case 3:
				{
					_star1.visible = true;
					_star2.visible = true;
					_star3.visible = true;
					break;
				}
			}
			_star1.scaleX = 0;
			_star1.scaleY = 0;
			_star2.scaleX = 0;
			_star2.scaleY = 0;
			_star3.scaleX = 0;
			_star3.scaleY = 0;
			if (_star1.visible)
			{
				var tween1:Tween = new Tween(_star1, 0.5, Transitions.EASE_OUT_BACK);
				tween1.delay = 1.5;
				tween1.animate("scaleX", 1);
				tween1.animate("scaleY", 1);
				tween1.onStart = showStarSound;
				tween1.onStartArgs = ["ShowStar1"];
				Starling.juggler.add(tween1);
			}
			if (_star2.visible)
			{
				var tween2:Tween = new Tween(_star2, 0.5, Transitions.EASE_OUT_BACK);
				tween2.delay = 2;
				tween2.animate("scaleX", 1);
				tween2.animate("scaleY", 1);
				tween2.onStart = showStarSound;
				tween2.onStartArgs = ["ShowStar2"];
				Starling.juggler.add(tween2);
			}
			if (_star3.visible)
			{
				var tween3:Tween = new Tween(_star3, 0.5, Transitions.EASE_OUT_BACK);
				tween3.delay = 2.5;
				tween3.animate("scaleX", 1);
				tween3.animate("scaleY", 1);
				tween3.onStart = showStarSound;
				tween3.onStartArgs = ["ShowStar3"];
				Starling.juggler.add(tween3);
			}
		}
		
		private function onRemoveAds(e:Event):void 
		{
			_soundManager.playSound("Click");
			IAP.buyProduct();
		}
		
		private function onMoreGames(e:Event):void 
		{
			_soundManager.playSound("Click");
			PlayHaven.playhaven.sendContentRequest("more_games", true);
		}
		
		private function showStarSound(str:String):void
		{
			if (visible)
				_soundManager.playSound(str);
		}
		
		private function onRestart(e:Event):void 
		{
			_soundManager.playSound("Click");
			dispatchEvent(new CustomEvent(CustomEvent.RESTART_GAME));
		}
		
		private function onMenu(e:Event):void 
		{
			_soundManager.playSound("Click");
			dispatchEvent(new CustomEvent(CustomEvent.MAIN_MENU));
		}
		
		private function onNext(e:Event):void 
		{
			_soundManager.playSound("Click");
			dispatchEvent(new CustomEvent(CustomEvent.NEXT_LEVEL));
		}
		
		public function update(p:Point):void
		{
			
		}
	}

}