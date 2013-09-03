package  
{
	import assets.Assets;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import helper.Constants;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class InGameMenu extends Sprite 
	{
		private var _back:Image;
		private var _resumeButton:Button;
		private var _mainMenuButton:Button;
		private var _restartButton:Button;
		private var _fadeImage:Image;
		private var _soundManager:SoundManager = SoundManager.getInstance();
		private var _muteSoundButton:Button;
		private var _muteMusicButton:Button;
		private var _mutedMusicIcon:Image;
		private var _mutedSoundIcon:Image;
		
		public function InGameMenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_fadeImage = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
			_fadeImage.alpha = 0.75;
			addChild(_fadeImage);
			
			_back = new Image(Assets.manager.getTexture("MenuBack"));
			_back.x = 126;
			_back.y = 0;
			addChild(_back);
			
			_resumeButton = new Button(Assets.manager.getTexture("ResumeButton"), "", Assets.manager.getTexture("ResumeButtonClicked"));
			_resumeButton.x = 195;
			_resumeButton.y = 130;
			_resumeButton.addEventListener(Event.TRIGGERED, onResume);
			addChild(_resumeButton);
			
			_restartButton = new Button(Assets.manager.getTexture("RestartButton"), "", Assets.manager.getTexture("RestartButtonClicked"));
			_restartButton.x = 200;
			_restartButton.y = 180;
			_restartButton.addEventListener(Event.TRIGGERED, onRestart);
			addChild(_restartButton);
			
			_mainMenuButton = new Button(Assets.manager.getTexture("MainMenuButton"), "", Assets.manager.getTexture("MainMenuButtonClicked"));
			_mainMenuButton.x = 200;
			_mainMenuButton.y = 235;
			_mainMenuButton.addEventListener(Event.TRIGGERED, onMenu);
			addChild(_mainMenuButton);
			
			_muteSoundButton = new Button(Assets.manager.getTexture("MuteSoundButton2"));
			_muteSoundButton.x = Constants.x0 + 60;
			_muteSoundButton.y = 0;
			_muteSoundButton.addEventListener(Event.TRIGGERED, onMuteSound);
			addChild(_muteSoundButton);
			
			_muteMusicButton = new Button(Assets.manager.getTexture("MuteMusicButton2"));
			_muteMusicButton.x = Constants.x0;
			_muteMusicButton.y = 0;
			_muteMusicButton.addEventListener(Event.TRIGGERED, onMuteMusic);
			addChild(_muteMusicButton);
			
			_mutedMusicIcon = new Image(Assets.manager.getTexture("ThinCross2"));
			_mutedMusicIcon.x = Constants.x0 + 15;
			_mutedMusicIcon.y = 16;
			_mutedMusicIcon.touchable = false;
			_mutedMusicIcon.visible = false;
			addChild(_mutedMusicIcon);
			
			_mutedSoundIcon = new Image(Assets.manager.getTexture("ThinCross2"));
			_mutedSoundIcon.x = Constants.x0 + 60 + 15;
			_mutedSoundIcon.y = 16;
			_mutedSoundIcon.touchable = false;
			_mutedSoundIcon.visible = false;
			addChild(_mutedSoundIcon);
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
		
		private function onResume(e:Event):void 
		{
			_soundManager.playSound("Click");
			dispatchEvent(new CustomEvent(CustomEvent.RESUME_GAME));
		}
		
		public function update(p:Point):void
		{
			
		}
	}

}