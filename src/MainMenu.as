package  
{
	import assets.Assets;
	import com.freshplanet.ane.AirChartboost;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import com.playhaven.PlayHaven;
	import flash.display.BitmapData;
	import flash.events.IMEEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import helper.Constants;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class MainMenu extends Sprite 
	{
		private var _playButton:Button;
		//private var _creditsButton:Button;
		private var _continueButton:Button;
		private var _moreGamesButton:Button;
		private var _removeAds:Button;
		private var _restore:Button;
		private var _continueOff:Image;
		private var _firstRun:Boolean = false;
		private var _levelSelect:LevelSelect;
		private var _editor:Editor;
		private var _back:Image;
		private var _touch:Touch;
		private var _touchPoint:Point = new Point(0, 0);
		private var _player:MovieClip;
		private var _sharedObject:SharedObject = SharedObject.getLocal("ForeverSteve");
		private var _saved:Object;
		private var _soundManager:SoundManager;
		//private var _credits:Image;
		//private var _closeCredits:Button;
		private var _followUs:Button;
		private var _fadeImage:Image;
		private var _playerIdle:Image;
		private var _playerRunning:MovieClip;
		private var _playerScratching:MovieClip;
		private var _animationTimer:Number = 3;
		private var _attention:Sprite;
		private var yesbtn:Button;
		private var nobtn:Button;
		private var _arghBtn:Button;
		private var _mutedMusicIcon:Image;
		private var _mutedSoundIcon:Image;
		private var _loading:Image;
		private var _landscape:Image;
		//private var _clouds:Sprite;
		//private var _clouds2:Sprite;
		private var _title:Image;
		
		public function MainMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if (LocalStore.data.levels[0] == 0)
				_firstRun = true;
			
			_soundManager = SoundManager.getInstance();
			
			//removeChild(_loading, true);
			_soundManager.playMusic("Menu", 100000);
			
			_back = new Image(Assets.manager.getTexture("Back1"));
			_back.x = 568 * 0.5 - _back.width * 0.5;
			addChild(_back);
			
			//_clouds = new Sprite();
			//addChild(_clouds);
			//_clouds2 = new Sprite();
			//addChild(_clouds2);
			
			//drawClouds();
			
			_landscape = new Image(Assets.manager.getTexture("MainMenuBack"));
			_landscape.x = 568 * 0.5 - _landscape.width * 0.5;
			addChild(_landscape);
			
			var fire1:MovieClip = new MovieClip(Assets.manager.getTextures("Fire_Torch"), 12);
			fire1.x = 84;
			fire1.y = -59;
			Starling.juggler.add(fire1);
			addChild(fire1);
			
			var fire2:MovieClip = new MovieClip(Assets.manager.getTextures("Fire_Torch"), 12);
			fire2.x = 423;
			fire2.y = -59;
			Starling.juggler.add(fire2);
			addChild(fire2);
			
			_title = new Image(Assets.manager.getTexture("Title"));
			_title.x = 284 - _title.width * 0.5 + 5;
			_title.y = 10;
			addChild(_title);
			
			_continueButton = new Button(Assets.manager.getTexture("ContinueBtn"), "", Assets.manager.getTexture("ContinueBtnClicked"));
			_continueButton.x = 194;
			_continueButton.y = 90;
			_continueButton.alphaWhenDisabled = 1;
			_continueButton.addEventListener(Event.TRIGGERED, onPlay);
			addChild(_continueButton);
			
			_continueOff = new Image(Assets.manager.getTexture("ContinueBtnClicked"));
			_continueOff.x = 194;
			_continueOff.y = 90;
			if (_firstRun)
				addChild(_continueOff);
			
			_playButton = new Button(Assets.manager.getTexture("NewGameBtn"), "", Assets.manager.getTexture("NewGameBtnClicked"));
			_playButton.x = 194;
			_playButton.y = 150;
			_playButton.alphaWhenDisabled = 1;
			_playButton.addEventListener(Event.TRIGGERED, onNewGame);
			addChild(_playButton);
			
			//_creditsButton = new Button(Assets.manager.getTexture("CreditsBtn"), "", Assets.manager.getTexture("CreditsBtnClicked"));
			//_creditsButton.x = 194;
			//_creditsButton.y = 170;
			//_creditsButton.alphaWhenDisabled = 1;
			//_creditsButton.addEventListener(Event.TRIGGERED, onCredits);
			//addChild(_creditsButton);
			
			_moreGamesButton = new Button(Assets.manager.getTexture("MoreGamesButton"), "", Assets.manager.getTexture("MoreGamesButtonClicked"));
			_moreGamesButton.x = 194;
			_moreGamesButton.y = 210;
			_moreGamesButton.alphaWhenDisabled = 1;
			_moreGamesButton.addEventListener(Event.TRIGGERED, onMoreGames);
			addChild(_moreGamesButton);
			
			_restore = new Button(Assets.manager.getTexture("RestoreBtn"), "", Assets.manager.getTexture("RestoreBtnClicked"));
			_restore.x = Constants.x0 + 5;
			_restore.y = Constants.realHeight - _restore.height * 0.75 - 5;
			_restore.alphaWhenDisabled = 1;
			_restore.scaleX = 0.75;
			_restore.scaleY = 0.75;
			_restore.addEventListener(Event.TRIGGERED, onRestore);
			addChild(_restore);
			
			_removeAds = new Button(Assets.manager.getTexture("RemoveAds"), "", Assets.manager.getTexture("RemoveAdsClicked"));
			_removeAds.x = Constants.x0 + 5;
			_removeAds.y = Constants.realHeight - _removeAds.height - _restore.height * 0.75 - 5;
			_removeAds.alphaWhenDisabled = 1;
			_removeAds.scaleX = 0.75;
			_removeAds.scaleY = 0.75;
			_removeAds.addEventListener(Event.TRIGGERED, onRemoveAds);
			addChild(_removeAds);
			IAP.addButton(_removeAds);
			if (IAP.purchased)
			{
				_removeAds.visible = false;
			}
			
			var _muteSoundButton:Button = new Button(Assets.manager.getTexture("MuteSoundButton"));
			_muteSoundButton.x = 568 - Constants.x0 - 60;
			_muteSoundButton.y = 0;
			_muteSoundButton.addEventListener(Event.TRIGGERED, onMuteSound);
			addChild(_muteSoundButton);
			
			var _muteMusicButton:Button = new Button(Assets.manager.getTexture("MuteMusicButton"));
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
			
			_playerIdle = new Image(Assets.manager.getTexture("PlayerMenuIdle0001"));
			_playerIdle.x = 370;
			_playerIdle.y = 168;
			addChild(_playerIdle);
			
			_playerScratching = new MovieClip(Assets.manager.getTextures("PlayerMenuScratching"), 10);
			_playerScratching.x = 386;
			_playerScratching.y = 184;
			addChild(_playerScratching);
			_playerScratching.stop();
			_playerScratching.visible = false;
			Starling.juggler.add(_playerScratching);
			
			_playerRunning = new MovieClip(Assets.manager.getTextures("PlayerMenuRunning"), 20);
			_playerRunning.x = 370;
			_playerRunning.y = 168;
			addChild(_playerRunning);
			_playerRunning.stop();
			_playerRunning.visible = false;
			Starling.juggler.add(_playerRunning);
			
			//_credits = new Image(Assets.manager.getTexture("Credits"));
			//_credits.x = 0;
			//if (Starling.contentScaleFactor == 4)
				//_credits.x = Constants.x0 / Starling.contentScaleFactor;
			//_credits.y = 0;
			//if (Constants.realHeight == 320)
				//_credits.y = - 20;
			//_credits.visible = false;
			//addChild(_credits);
			
			//_closeCredits = new Button(Assets.manager.getTexture("CloseCredits"), "", Assets.manager.getTexture("CloseCredits"));
			//_closeCredits.x = 568 - Constants.x0 - 42 - 20;
			//_closeCredits.y = 20;
			//_closeCredits.visible = false;
			//_closeCredits.addEventListener(Event.TRIGGERED, onCloseCredits);
			//addChild(_closeCredits);
			
			//_followUs = new Button(Assets.getAtlasTexture("FollowUs"), "", Assets.getAtlasTexture("FollowUs"));
			//_followUs.x = 164;
			//_followUs.y = 410;
			//_followUs.visible = false;
			//_followUs.addEventListener(Event.TRIGGERED, onFacebook);
			//addChild(_followUs);
			
			// +Draw Call!
			//_arghBtn = new Button(Texture.fromBitmapData(new BitmapData(200, 200, true, 0x000000)), "", Texture.fromBitmapData(new BitmapData(200, 200, true, 0x000000)));
			//_arghBtn.x = 184;
			//_arghBtn.y = 90;
			//_arghBtn.visible = false;
			//_arghBtn.addEventListener(Event.TRIGGERED, onFacebook);
			//addChild(_arghBtn);
			
			createAttentionSprite();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
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
		
		private function updateSounds():void
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
			_continueButton.enabled = value;
			_playButton.enabled = value;
			//_creditsButton.enabled = value;
		}
		
		private function onNewGame(e:Event):void 
		{
			if (!_attention)
			{
				createAttentionSprite();
			}
			if (!_firstRun)
			{
				_attention.visible = true;
			}
			else
			{
				onPlay(null);
				_continueOff.visible = false;
				_firstRun = false;
			}
			_soundManager.playSound("Click");
		}
		
		private function createAttentionSprite():void 
		{
			_attention = new Sprite();
			_attention.visible = false;
			addChild(_attention);
			var back:Image = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
			back.alpha = 0.75;
			_attention.addChild(back);
			var back2:Image = new Image(Assets.manager.getTexture("AttentionBack"));
			back2.x = 127;
			back2.y = 50;
			_attention.addChild(back2);
			var text:Image = new Image(Assets.manager.getTexture("AttentionText"));
			text.x = 134;
			text.y = 100;
			_attention.addChild(text);
			yesbtn = new Button(Assets.manager.getTexture("Yes"), "", Assets.manager.getTexture("YesClicked"));
			yesbtn.x = 114;
			yesbtn.y = 230;
			yesbtn.addEventListener(Event.TRIGGERED, onClearProgress);
			_attention.addChild(yesbtn);
			nobtn = new Button(Assets.manager.getTexture("No"), "", Assets.manager.getTexture("NoClicked"));
			nobtn.x = 314;
			nobtn.y = 230;
			nobtn.addEventListener(Event.TRIGGERED, onCancel);
			_attention.addChild(nobtn);
		}
		
		private function onCancel(e:Event):void 
		{
			_soundManager.playSound("Click");
			_attention.visible = false;
		}
		
		private function onClearProgress(e:Event):void 
		{
			_attention.visible = false;
			dispatchEvent(new CustomEvent(CustomEvent.CLEAR_PROGRESS));
			onPlay(null);
		}
		
		private function onFacebook(e:Event):void 
		{
			navigateToURL(new URLRequest("http://www.facebook.com/ArghGames"));
		}
		
		private function onCredits(e:Event):void 
		{
			_soundManager.playSound("Click");
			//_credits.visible = true;
			//_closeCredits.visible = true;
			_arghBtn.visible = true;
		}
		
		private function onCloseCredits(e:Event):void 
		{
			//_closeCredits.visible = false;
			//_credits.visible = false;
			//_followUs.visible = false;
			_arghBtn.visible = false;
		}
		
		private function onMoreGames(e:Event):void 
		{
			_soundManager.playSound("Click");
			// ==========================================
			PlayHaven.playhaven.sendContentRequest("more_games", false);
			//AirChartboost.getInstance().showInterstitial();
		}
		
		private function onRemoveAds(e:Event):void 
		{
			_soundManager.playSound("Click");
			IAP.buyProduct();
			//LocalStore.data.purchased = true;
			//LocalStore.save();
			//Constants.tf.text = "PURCHASED";
		}
		
		private function onRestore(e:Event):void 
		{
			_soundManager.playSound("Click");
			IAP.restoreTransactions();
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			_touch = e.getTouch(stage);
		}
		
		private function saveProgress():void
		{
			_sharedObject.flush();
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (!_attention.visible)
			{
				if (_touch)
				{
					_touchPoint.x = _touch.globalX;
					_touchPoint.y = _touch.globalY;
				}
			}
			
			if (_playerIdle.visible)
				_animationTimer -= e.passedTime;
			if (_animationTimer < 0)
			{
				_animationTimer = 2 + 2 * Math.random();
				_playerIdle.visible = false;
				_playerScratching.visible = true;
				_playerScratching.play();
				_playerScratching.addEventListener(Event.COMPLETE, onAnimationComplete);
			}
			
			//_clouds.x -= 0.5;
			//_clouds2.x -= 0.5;
			//if (_clouds.x == -568)
				//_clouds.x = 568;
			//if (_clouds2.x == -568)
				//_clouds2.x = 568;
		}
		
		private function onAnimationComplete(e:Event):void 
		{
			_playerScratching.removeEventListener(Event.COMPLETE, onAnimationComplete);
			
			_playerIdle.visible = true;
			_playerScratching.visible = false;
			_playerScratching.stop();
		}
		
		private function onPlay(e:Event):void 
		{
			setEnable(false);
			_soundManager.playSound("Click");
			
			_playerIdle.visible = false;
			_playerScratching.stop();
			_playerScratching.removeEventListener(Event.COMPLETE, onAnimationComplete);
			_playerScratching.visible = false;
			_playerRunning.visible = true;
			_playerRunning.play();
			Starling.juggler.tween(_playerRunning, 2, {
				transition: Transitions.LINEAR,
				x: 570,
				y: 168,
				onComplete: dispatchEvent,
				onCompleteArgs: [new CustomEvent(CustomEvent.LEVEL_SELECT)]
			});
		}
		
		public function reset():void
		{
			setEnable(true);
			_playerRunning.visible = false;
			_playerRunning.stop();
			_playerRunning.x = 370;
			_playerIdle.visible = true;
		}
		
		private function onEditor(e:Event):void 
		{
			if (!_editor)
			{
				_editor = new Editor();
			}
			addChild(_editor);
		}
		
	}

}