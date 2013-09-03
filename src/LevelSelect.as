package  
{
	import assets.Assets;
	import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	import helper.Constants;
	import mx.core.ButtonAsset;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class LevelSelect extends Sprite 
	{
		[Embed (source = "../media/levels/1.xml", mimeType="application/octet-stream")]
		private var Level1:Class;
		[Embed (source = "../media/levels/2.xml", mimeType="application/octet-stream")]
		private var Level2:Class;
		[Embed (source = "../media/levels/3.xml", mimeType="application/octet-stream")]
		private var Level3:Class;
		[Embed (source = "../media/levels/4.xml", mimeType="application/octet-stream")]
		private var Level4:Class;
		[Embed (source = "../media/levels/5.xml", mimeType="application/octet-stream")]
		private var Level5:Class;
		[Embed (source = "../media/levels/6.xml", mimeType="application/octet-stream")]
		private var Level6:Class;
		[Embed (source = "../media/levels/7.xml", mimeType="application/octet-stream")]
		private var Level7:Class;
		[Embed (source = "../media/levels/8.xml", mimeType="application/octet-stream")]
		private var Level8:Class;
		[Embed (source = "../media/levels/9.xml", mimeType="application/octet-stream")]
		private var Level9:Class;
		[Embed (source = "../media/levels/10.xml", mimeType="application/octet-stream")]
		private var Level10:Class;
		[Embed (source = "../media/levels/11.xml", mimeType="application/octet-stream")]
		private var Level11:Class;
		[Embed (source = "../media/levels/12.xml", mimeType="application/octet-stream")]
		private var Level12:Class;
		[Embed (source = "../media/levels/13.xml", mimeType="application/octet-stream")]
		private var Level13:Class;
		[Embed (source = "../media/levels/14.xml", mimeType="application/octet-stream")]
		private var Level14:Class;
		[Embed (source = "../media/levels/15.xml", mimeType="application/octet-stream")]
		private var Level15:Class;
		[Embed (source = "../media/levels/16.xml", mimeType="application/octet-stream")]
		private var Level16:Class;
		[Embed (source = "../media/levels/17.xml", mimeType="application/octet-stream")]
		private var Level17:Class;
		[Embed (source = "../media/levels/18.xml", mimeType="application/octet-stream")]
		private var Level18:Class;
		[Embed (source = "../media/levels/19.xml", mimeType="application/octet-stream")]
		private var Level19:Class;
		[Embed (source = "../media/levels/20.xml", mimeType="application/octet-stream")]
		private var Level20:Class;
		[Embed (source = "../media/levels/21.xml", mimeType="application/octet-stream")]
		private var Level21:Class;
		[Embed (source = "../media/levels/22.xml", mimeType="application/octet-stream")]
		private var Level22:Class;
		[Embed (source = "../media/levels/23.xml", mimeType="application/octet-stream")]
		private var Level23:Class;
		[Embed (source = "../media/levels/24.xml", mimeType="application/octet-stream")]
		private var Level24:Class;
		[Embed (source = "../media/levels/25.xml", mimeType="application/octet-stream")]
		private var Level25:Class;
		[Embed (source = "../media/levels/26.xml", mimeType="application/octet-stream")]
		private var Level26:Class;
		[Embed (source = "../media/levels/27.xml", mimeType="application/octet-stream")]
		private var Level27:Class;
		[Embed (source = "../media/levels/28.xml", mimeType="application/octet-stream")]
		private var Level28:Class;
		[Embed (source = "../media/levels/29.xml", mimeType="application/octet-stream")]
		private var Level29:Class;
		[Embed (source = "../media/levels/30.xml", mimeType="application/octet-stream")]
		private var Level30:Class;
		[Embed (source = "../media/levels/31.xml", mimeType="application/octet-stream")]
		private var Level31:Class;
		[Embed (source = "../media/levels/32.xml", mimeType="application/octet-stream")]
		private var Level32:Class;
		[Embed (source = "../media/levels/33.xml", mimeType="application/octet-stream")]
		private var Level33:Class;
		[Embed (source = "../media/levels/34.xml", mimeType="application/octet-stream")]
		private var Level34:Class;
		[Embed (source = "../media/levels/35.xml", mimeType="application/octet-stream")]
		private var Level35:Class;
		[Embed (source = "../media/levels/36.xml", mimeType="application/octet-stream")]
		private var Level36:Class;
		[Embed (source = "../media/levels/37.xml", mimeType="application/octet-stream")]
		private var Level37:Class;
		[Embed (source = "../media/levels/38.xml", mimeType="application/octet-stream")]
		private var Level38:Class;
		[Embed (source = "../media/levels/39.xml", mimeType="application/octet-stream")]
		private var Level39:Class;
		[Embed (source = "../media/levels/40.xml", mimeType="application/octet-stream")]
		private var Level40:Class;
		
		private var _back:Image;
		private var _game:Game;
		private var _levels:Array = [new Level1(), new Level2(), new Level3(), new Level4(), new Level5(), new Level6(), new Level7(), new Level8(), new Level9(), new Level10(), new Level11(), new Level12(), new Level13(), new Level14(), new Level15(), new Level16(), new Level17(), new Level18(), new Level19(), new Level20()];
		private var _levels2:Array = [new Level21(), new Level22(), new Level23(), new Level24(), new Level25(), new Level26(), new Level27(), new Level28(), new Level29(), new Level30(), new Level31(), new Level32(), new Level33(), new Level34(), new Level35(), new Level36(), new Level37(), new Level38(), new Level39(), new Level40()];
		private var _backButton:Button;
		private var _saveFunction:Function;
		private var _levelProgress:Array;
		private var _currentLevelIndex:int = 0;
		private var _stars:Array = [];
		private var _buttons:Array = [];
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _cartoon:Cartoon;
		private var _fadeImage:Image;
		private var _mutedMusicIcon:Image;
		private var _mutedSoundIcon:Image;
		private var _levelNumber:int;
		//private var _clouds:Sprite;
		//private var _clouds2:Sprite;
		private var _nextLevels:Button;
		private var _prevLevels:Button;
		private var _sprite:Sprite;
		private var _sprite2:Sprite;
		private var _iapText:Image;
		
		public function LevelSelect(levels:Array, saveFunction:Function) 
		{
			_saveFunction = saveFunction;
			_levelProgress = levels;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_back = new Image(Assets.manager.getTexture("Back1"));
			_back.x = 568 * 0.5 - _back.width * 0.5;
			addChild(_back);
			
			//_clouds = new Sprite();
			//addChild(_clouds);
			//_clouds2 = new Sprite();
			//addChild(_clouds2);
			
			//drawClouds();
			
			drawLevelButtons();
			
			var _muteSoundButton:Button = new Button(Assets.manager.getTexture("MuteSoundButton"), "", Assets.manager.getTexture("MuteSoundButton"));
			_muteSoundButton.x = 568 - Constants.x0 - 60;
			_muteSoundButton.y = 0;
			_muteSoundButton.addEventListener(Event.TRIGGERED, onMuteSound);
			addChild(_muteSoundButton);
			
			var _muteMusicButton:Button = new Button(Assets.manager.getTexture("MuteMusicButton"), "", Assets.manager.getTexture("MuteMusicButton"));
			_muteMusicButton.x = 568 - Constants.x0 - 60 - 60;
			_muteMusicButton.y = 0;
			_muteMusicButton.addEventListener(Event.TRIGGERED, onMuteMusic);
			addChild(_muteMusicButton);
			
			_mutedMusicIcon = new Image(Assets.manager.getTexture("ThinCross"));
			_mutedMusicIcon.x = 568 - Constants.x0 - 60 - 60 + 15;
			_mutedMusicIcon.y = 16;
			_mutedMusicIcon.touchable = false;
			_mutedMusicIcon.visible = false;
			addChild(_mutedMusicIcon);
			
			_mutedSoundIcon = new Image(Assets.manager.getTexture("ThinCross"));
			_mutedSoundIcon.x = 568 - Constants.x0 - 60 + 15;
			_mutedSoundIcon.y = 16;
			_mutedSoundIcon.touchable = false;
			_mutedSoundIcon.visible = false;
			addChild(_mutedSoundIcon);
			
			_backButton = new Button(Assets.manager.getTexture("BackButton"), "", Assets.manager.getTexture("BackButton"));
			_backButton.x = Constants.x0;
			_backButton.addEventListener(Event.TRIGGERED, onBack);
			addChild(_backButton);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			//_clouds.x -= 0.5;
			//_clouds2.x -= 0.5;
			//if (_clouds.x == -568)
				//_clouds.x = 568;
			//if (_clouds2.x == -568)
				//_clouds2.x = 568;
		}
		
		private function drawClouds():void 
		{
			//var key:String;
			//for (var i:int = 0; i < 4; ++i)
			//{
				//for (var j:int = 0; j < 3; ++j)
				//{
					//if (Math.random() < 0.75)
					//{
						//key = "Cloud" + String(1 + Math.round(Math.random() * 12));
						//var cloud:Image = new Image(Assets.getAtlasTexture(key));
						//cloud.x = 190 * j - 95 * (i % 2) + Math.round(Math.random() * 10);
						//cloud.y = -30 + 100 * i + Math.round(Math.random() * 10);
						//_clouds.addChild(cloud);
						//
						//var cloud2:Image = new Image(Assets.getAtlasTexture(key));
						//cloud2.x = cloud.x;
						//cloud2.y = cloud.y;
						//_clouds2.addChild(cloud2);
					//}
				//}
			//}
			//_clouds2.x = 568;
		}
		
		private function onMuteMusic(e:Event):void 
		{
			if (SoundManager.mutedMusicIngame)
			{
				SoundManager.mutedMusicIngame = false;
				_mutedMusicIcon.visible = false;
				SoundManager.unmuteMusic();
			}
			else
			{
				SoundManager.mutedMusicIngame = true;
				_mutedMusicIcon.visible = true;
				SoundManager.muteMusic();
			}
		}
		
		private function onMuteSound(e:Event):void 
		{
			if (SoundManager.mutedSoundIngame)
			{
				SoundManager.mutedSoundIngame = false;
				_mutedSoundIcon.visible = false;
				SoundManager.unmuteSound();
			}
			else
			{
				SoundManager.mutedSoundIngame = true;
				_mutedSoundIcon.visible = true;
				SoundManager.muteSound();
			}
		}
		
		public function updateSounds():void
		{
			if (SoundManager.mutedSoundIngame)
			{
				_mutedSoundIcon.visible = true;
			}
			else
			{
				_mutedSoundIcon.visible = false;
			}
			if (SoundManager.mutedMusicIngame)
			{
				_mutedMusicIcon.visible = true;
			}
			else
			{
				_mutedMusicIcon.visible = false;
			}
		}
		
		private function setEnable(value:Boolean = true):void
		{
			for (var i:int = 0; i < _buttons.length; ++i)
			{
				_buttons[i].enabled = value;
			}
			_backButton.enabled = value;
		}
		
		private function drawLevelButtons():void 
		{
			_sprite = new Sprite();
			addChild(_sprite);
			var img:Image;
			var button:Button;
			var counter:int = 0;
			var star:Image;
			var number:Image;
			var number2:Image;
			var distanceX:int = Math.round((568 - Constants.x0 * 2) / 6);
			var distanceY:int = Math.round((Constants.realHeight - 70) / 4);
			//trace(distanceX, distanceY);
			for (var i:int = 0; i < 4; ++i)
			{
				for (var j:int = 0; j < 5; ++j)
				{
					++counter;
					img = new Image(Assets.manager.getTexture("RedSquare"));
					img.x = Constants.x0 + distanceX - 29 + distanceX * j;
					img.y = 61 + distanceY * i;
					_sprite.addChild(img);
					
					button = new Button(Assets.manager.getTexture("GreenSquare"), "", Assets.manager.getTexture("GreenSquare"));
					button.x = Constants.x0 + distanceX - 30 + distanceX * j;
					button.y = 60 + distanceY * i;
					button.name = String(counter);
					button.alphaWhenDisabled = 1;
					button.addEventListener(Event.TRIGGERED, onPlay);
					_sprite.addChild(button);
					_buttons[i * 5 + j] = button;
					
					if (_levelProgress[i * 5 + j] == -1)
					{
						button.visible = false;
					}
					
					_stars[i * 5 + j] = [];
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = Constants.x0 + distanceX - 20 - 18 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j][0] = star;
					if (_levelProgress[i * 5 + j] < 1)
					{
						star.visible = false;
					}
					
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = Constants.x0 + distanceX - 20 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j][1] = star;
					if (_levelProgress[i * 5 + j] < 2)
					{
						star.visible = false;
					}
					
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = Constants.x0 + distanceX - 20 + 18 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j][2] = star;
					if (_levelProgress[i * 5 + j] < 3)
					{
						star.visible = false;
					}
					
					if (i * 5 + j + 1 < 10)
					{						
						number = new Image(Assets.manager.getTexture("Number" + String(i * 5 + j + 1)));
						number.x = Constants.x0 + distanceX + distanceX * j - int(number.width / 2);
						number.y = 60 + distanceY * i + 10;
						number.touchable = false;
						_sprite.addChild(number);
					}
					else
					{
						var k:int = i * 5 + j + 1;
						number = new Image(Assets.manager.getTexture("Number" + String(int(k / 10))));
						number2 = new Image(Assets.manager.getTexture("Number" + String(k - (int(k / 10)) * 10)));
						var eqWidth:Number = number.width + number2.width;
						number.x = Constants.x0 + distanceX + distanceX * j - int(eqWidth / 2);
						number2.x = number.x + number.width;
						number.y = 60 + distanceY * i + 10;
						number2.y = 60 + distanceY * i + 10;
						number.touchable = false;
						number2.touchable = false;
						_sprite.addChild(number);
						_sprite.addChild(number2);
					}
				}
			}
			_nextLevels = new Button(Assets.manager.getTexture("NextLevelsBtn"), "", Assets.manager.getTexture("NextLevelsBtn"));
			_nextLevels.x = 568 - Constants.x0 - distanceX * 0.5;
			_nextLevels.y = 60 + distanceY * 2 - _nextLevels.height * 0.5;
			_nextLevels.addEventListener(Event.TRIGGERED, onNextLevels);
			addChild(_nextLevels);
			
			drawLevelButtons2();
			//updateLevelButtons();
		}
		
		private function drawLevelButtons2():void 
		{
			var img:Image;
			var button:Button;
			var counter:int = 0;
			var star:Image;
			var number:Image;
			var number2:Image;
			var distanceX:int = Math.round((568 - Constants.x0 * 2) / 6);
			var distanceY:int = Math.round((Constants.realHeight - 70) / 4);
			//trace(distanceX, distanceY);
			for (var i:int = 0; i < 4; ++i)
			{
				for (var j:int = 0; j < 5; ++j)
				{
					++counter;
					img = new Image(Assets.manager.getTexture("RedSquare"));
					img.x = 568 + Constants.x0 + distanceX - 29 + distanceX * j;
					img.y = 61 + distanceY * i;
					_sprite.addChild(img);
					
					button = new Button(Assets.manager.getTexture("GreenSquare"), "", Assets.manager.getTexture("GreenSquare"));
					button.x = 568 + Constants.x0 + distanceX - 30 + distanceX * j;
					button.y = 60 + distanceY * i;
					button.name = String(counter + 20);
					button.alphaWhenDisabled = 1;
					button.addEventListener(Event.TRIGGERED, onPlay);
					_sprite.addChild(button);
					_buttons[i * 5 + j + 20] = button;
					
					if (_levelProgress[i * 5 + j + 20] == -1)
					{
						button.visible = false;
					}
					
					_stars[i * 5 + j + 20] = [];
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = 568 + Constants.x0 + distanceX - 20 - 18 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j + 20][0] = star;
					if (_levelProgress[i * 5 + j + 20] < 1)
					{
						star.visible = false;
					}
					
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = 568 + Constants.x0 + distanceX - 20 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j + 20][1] = star;
					if (_levelProgress[i * 5 + j + 20] < 2)
					{
						star.visible = false;
					}
					
					star = new Image(Assets.manager.getTexture("LevelStar"));
					star.x = 568 + Constants.x0 + distanceX - 20 + 18 + distanceX * j;
					star.y = 85 + distanceY * i;
					star.touchable = false;
					_sprite.addChild(star);
					_stars[i * 5 + j + 20][2] = star;
					if (_levelProgress[i * 5 + j + 20] < 3)
					{
						star.visible = false;
					}
					
					if (i * 5 + j + 1 + 20 < 10)
					{						
						number = new Image(Assets.manager.getTexture("Number" + String(i * 5 + j + 1 + 20)));
						number.x = 568 + Constants.x0 + distanceX + distanceX * j - int(number.width / 2);
						number.y = 60 + distanceY * i + 10;
						number.touchable = false;
						_sprite.addChild(number);
					}
					else
					{
						var k:int = i * 5 + j + 1 + 20;
						number = new Image(Assets.manager.getTexture("Number" + String(int(k / 10))));
						number2 = new Image(Assets.manager.getTexture("Number" + String(k - (int(k / 10)) * 10)));
						var eqWidth:Number = number.width + number2.width;
						number.x = 568 + Constants.x0 + distanceX + distanceX * j - int(eqWidth / 2);
						number2.x = number.x + number.width;
						number.y = 60 + distanceY * i + 10;
						number2.y = 60 + distanceY * i + 10;
						number.touchable = false;
						number2.touchable = false;
						_sprite.addChild(number);
						_sprite.addChild(number2);
					}
				}
			}
			_prevLevels = new Button(Assets.manager.getTexture("NextLevelsBtn"), "", Assets.manager.getTexture("NextLevelsBtn"));
			_prevLevels.scaleX = -1;
			_prevLevels.x = 568 + Constants.x0 + distanceX * 0.5;
			_prevLevels.y = 60 + distanceY * 2 - _prevLevels.height * 0.5;
			_prevLevels.visible = false;
			_prevLevels.addEventListener(Event.TRIGGERED, onPrevLevels);
			_sprite.addChild(_prevLevels);
			updateLevelButtons();
		}
		
		private function onPrevLevels(e:Event):void 
		{
			Starling.juggler.tween(_prevLevels, 0.2, { alpha:0, onComplete:showPrevLevels } );
		}
		
		private function showPrevLevels():void 
		{
			_prevLevels.alpha = 1;
			_prevLevels.visible = false;
			
			Starling.juggler.tween(_sprite, 0.5, { x: 0, transition:Transitions.EASE_IN, onComplete:prevLevelsShowed } );
		}
		
		private function prevLevelsShowed():void 
		{
			_nextLevels.visible = true;
		}
		
		private function onNextLevels(e:Event):void 
		{
			Starling.juggler.tween(_nextLevels, 0.2, { alpha:0, onComplete:showNextLevels } );
		}
		
		public function showNextLevels():void 
		{
			_nextLevels.alpha = 1;
			_nextLevels.visible = false;
			
			if (!IAP.purchased)
			{
				if (!_fadeImage)
				{
					_fadeImage = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
					addChild(_fadeImage);
				}
				_fadeImage.x = 568;
				_fadeImage.alpha = 0;
				
				Starling.juggler.tween(_fadeImage, 0.5, { x: 0, transition:Transitions.EASE_IN, alpha:0.75, onComplete:showButtons } );
			}
			
			Starling.juggler.tween(_sprite, 0.5, { x: -568, transition:Transitions.EASE_IN, onComplete:nextLevelsShowed } );
		}
		
		private function showButtons():void 
		{
			if (!_sprite2)
			{
				_sprite2 = new Sprite();
				addChild(_sprite2);
				
				var yesBtn:Button = new Button(Assets.manager.getTexture("Yes"), "", Assets.manager.getTexture("YesClicked"));
				yesBtn.x = 100;
				yesBtn.y = 200;
				yesBtn.addEventListener(Event.TRIGGERED, onYes);
				_sprite2.addChild(yesBtn);
				var noBtn:Button = new Button(Assets.manager.getTexture("No"), "", Assets.manager.getTexture("NoClicked"));
				noBtn.x = 300;
				noBtn.y = 200;
				noBtn.addEventListener(Event.TRIGGERED, onNo);
				_sprite2.addChild(noBtn);
				_iapText = new Image(Assets.manager.getTexture("IAPText"));
				_iapText.x = (568 - _iapText.width) * 0.5;
				_iapText.y = 100;
				_sprite2.addChild(_iapText);
			}
			_sprite2.alpha = 0;
			_sprite2.x = 0;
			Starling.juggler.tween(_sprite2, 0.2, { alpha:1 } );
		}
		
		private function onYes(e:Event):void 
		{
			if (StoreKit.isSupported() && StoreKit.storeKit.isStoreKitAvailable())
			{
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED, onPurchaseUserCancelled);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
			}
			IAP.buyProduct();
		}
		
		private function onPurchaseFailed(e:StoreKitErrorEvent):void 
		{
			onNo(null);
		}
		
		private function onPurchaseUserCancelled(e:StoreKitEvent):void 
		{
			onNo(null);
		}
		
		private function onPurchaseSuccess(e:StoreKitEvent):void 
		{
			StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
			StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_CANCELLED, onPurchaseUserCancelled);
			StoreKit.storeKit.removeEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
			removeChild(_sprite2);
			removeChild(_fadeImage, true);
			_fadeImage = null;
		}
		
		private function onNo(e:Event):void 
		{
			Starling.juggler.tween(_fadeImage, 0.5, { x: 568, transition:Transitions.EASE_IN, alpha:0 } );
			Starling.juggler.tween(_sprite2, 0.5, { x: 568, transition:Transitions.EASE_IN, alpha:0 } );
			Starling.juggler.tween(_sprite, 0.5, { x: 0, transition:Transitions.EASE_IN, onComplete:prevLevelsShowed } );
		}
		
		private function nextLevelsShowed():void 
		{
			_prevLevels.visible = true;
		}
		
		public function updateLevelButtons():void
		{
			for (var i:int = 0; i < _buttons.length; ++i)
			{
				if (_levelProgress[i] < 0)
				{
					_buttons[i].visible = false;
					_stars[i][0].visible = false;
					_stars[i][1].visible = false;
					_stars[i][2].visible = false;
				}
				else
				{
					_buttons[i].visible = true;
					_stars[i][0].visible = false;
					_stars[i][1].visible = false;
					_stars[i][2].visible = false;
					if (_levelProgress[i] == 1)
					{
						_stars[i][0].visible = true;
					}
					if (_levelProgress[i] == 2)
					{
						_stars[i][0].visible = true;
						_stars[i][1].visible = true;
					}
					if (_levelProgress[i] == 3)
					{
						_stars[i][0].visible = true;
						_stars[i][1].visible = true;
						_stars[i][2].visible = true;
					}
				}
			}
		}
		
		private function onPlay(e:Event):void 
		{
			setEnable(false);
			_soundManager.playSound("Click");
			_levelNumber = int((e.target as Button).name);
			dispatchEvent(new CustomEvent(CustomEvent.START_GAME));
		}
		
		private function hideFadeImage():void 
		{
			_fadeImage.visible = false;
		}
		
		private function onBack(e:Event):void 
		{
			_soundManager.playSound("Click");
			setEnable(false);
			dispatchEvent(new CustomEvent(CustomEvent.MAIN_MENU));
		}
		
		public function reset():void
		{
			setEnable(true);
			updateSounds();
		}
		
		public function get levelNumber():int
		{
			return _levelNumber;
		}
		
		public function getXML(index:int):XML
		{
			if (index <= 20)
				return XML(_levels[index - 1]);
			else
				return XML(_levels2[index - 1 - 20]);
		}
	}

}