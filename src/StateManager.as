package  
{
	import assets.Assets;
	import com.freshplanet.ane.AirChartboost;
	import com.freshplanet.nativeExtensions.Flurry;
	import com.playhaven.PlayHaven;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import helper.Constants;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class StateManager extends Sprite 
	{
		private var _mainMenu:MainMenu;
		private var _levelSelect:LevelSelect;
		private var _game:Game;
		private var _fadeImage:Image;
		private var _saved:Object;
		private var _loading:Image;
		private var _levelNumber:int;
		private var _cartoon:Cartoon;
		private var _soundManager:SoundManager;
		private var _flurry:Flurry;
		
		public function StateManager() 
		{
			//
		}
		
		public function start(backTexture:Texture):void
		{
			Assets.contentScaleFactor = Starling.contentScaleFactor;
			Assets.manager = new AssetManager(Starling.contentScaleFactor, false);
			_saved = LocalStore.data;
			if (!_saved.levels)
			{
				//_firstRun = true;
				_saved.levels = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
				_saved.purchased = "not purchased";
				LocalStore.save();
			}
			//trace(_saved.levels);
			//_saved.levels = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
			//_saved.levels = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
			
			//SoundManager.mutedMusicIngame = true;
			
			_loading = new Image(backTexture);
			if (Starling.contentScaleFactor == 4)
			{
				_loading.width = 2048 / 4;
				_loading.height = 1536 / 4;
			}
			_loading.x = 568 * 0.5 - _loading.width * 0.5;
			addChild(_loading);
			//trace(_loading.x, _loading.y, _loading.width, _loading.height);
			
			var appDir:File = File.applicationDirectory;
            Assets.manager.verbose = Capabilities.isDebugger;
            Assets.manager.enqueue(
                appDir.resolvePath("media/sounds"),
                appDir.resolvePath("media/" + String(Starling.contentScaleFactor) + "x")
            );
			
			Assets.manager.loadQueue(onProgress);
		}
		
		private function onProgress(ratio:Number):void
		{
			//Constants.tf.text = String(ratio);
			if (ratio == 1)
				Starling.juggler.delayCall(showMainMenu, 0.15, null);
		}
		
		private function showMainMenu(e:Event):void
		{
			removeChild(_loading, true);
			_loading = null;
			
			_soundManager = SoundManager.getInstance();
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			
			_flurry = Flurry.getInstance();
			_flurry.setIOSAPIKey("WDH7VYXVHB437QDYTZZ3");
			_flurry.startSession();
			
			_mainMenu = new MainMenu();
			_mainMenu.addEventListener(CustomEvent.LEVEL_SELECT, fromMainToLevel);
			_mainMenu.addEventListener(CustomEvent.MAIN_MENU, fromLevelToMain);
			_mainMenu.addEventListener(CustomEvent.CLEAR_PROGRESS, clearProgress);
			addChild(_mainMenu);
			
			_levelSelect = new LevelSelect(_saved.levels, LocalStore.save);
			_levelSelect.addEventListener(CustomEvent.MAIN_MENU, fromLevelToMain);
			_levelSelect.addEventListener(CustomEvent.START_GAME, fromLevelToGame);
			addChild(_levelSelect);
			_levelSelect.visible = false;
			
			_game = new Game();
			_game.addEventListener(CustomEvent.LEVEL_SELECT, fromGameToLevel);
			_game.addEventListener(CustomEvent.NEXT_LEVEL, onNextLevel);
			_game.addEventListener(CustomEvent.LEVEL_VICTORY, onLevelVictory);
			_game.addEventListener(CustomEvent.RESTART_GAME, onRestartGame);
			addChild(_game);
			_game.visible = false;
			
			_fadeImage = new Image(Texture.fromBitmapData(new BitmapData(568, 384, false, 0x000000)));
			_fadeImage.touchable = false;
			addChild(_fadeImage);
			_fadeImage.visible = false;
			
			//var tf:TextField = new TextField(200, 100, "");
			//tf.x = 100;
			//tf.y = 20;
			//tf.text = String(AirChartboost.getInstance().isChartboostSupported) + String(PlayHaven.isSupported()) + String(ProductStore.isSupported);
			//addChild(tf);
		}
		
		// Reset game
		private function onRestartGame(e:CustomEvent):void 
		{
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: onRestartGame2,
				alpha: 1
			});
		}
		
		private function onRestartGame2():void 
		{
			_game.reset("onRestartGame2");
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		// Clear progress
		private function clearProgress(e:CustomEvent):void 
		{
			_saved.levels = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
			LocalStore.save();
			
			_levelSelect.removeEventListener(CustomEvent.MAIN_MENU, fromLevelToMain);
			_levelSelect.removeEventListener(CustomEvent.START_GAME, fromLevelToGame);
			removeChild(_levelSelect, true);
			_levelSelect = null;
			_levelSelect = new LevelSelect(_saved.levels, LocalStore.save);
			_levelSelect.addEventListener(CustomEvent.MAIN_MENU, fromLevelToMain);
			_levelSelect.addEventListener(CustomEvent.START_GAME, fromLevelToGame);
			addChild(_levelSelect);
			_levelSelect.visible = false;
		}
		
		// Next Level
		private function onNextLevel(e:CustomEvent):void 
		{
			if (_levelNumber < 40)
			{
				++_levelNumber;
				_game.clearLevel();
				_game.loadLevel(_levelSelect.getXML(_levelNumber), _levelNumber);
				_game.visible = true;
			}
			else
			{
				trace("Finish game");
			}
		}
		
		// Level Victory
		private function onLevelVictory(e:CustomEvent):void 
		{
			if (_saved.levels[_levelNumber - 1] < _game.starsCatched)
			{
				if (_levelNumber < 40)
				{
					if (_saved.levels[_levelNumber] == -1)
					{
						_saved.levels[_levelNumber] = 0;
					}
				}
				_saved.levels[_levelNumber - 1] = _game.starsCatched;
			}
			LocalStore.save();
			_levelSelect.updateLevelButtons();
		}
		
		// Levels -> Game
		private function fromLevelToGame(e:CustomEvent):void 
		{
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			_levelNumber = _levelSelect.levelNumber;
			if (_levelNumber != 1)
			{
				_game.loadLevel(_levelSelect.getXML(_levelNumber), _levelNumber);
				Game.state = Game.STATE_PLAYING;
			}
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: _levelNumber == 1 ? showComix : fromLevelToGame2,
				alpha: 1
			});
		}
		
		private function showComix():void 
		{
			_cartoon = new Cartoon();
			_cartoon.addEventListener(CustomEvent.RESUME_GAME, onCloseCartoon);
			addChild(_cartoon);
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		private function onCloseCartoon(e:CustomEvent):void 
		{
			_cartoon.removeEventListener(CustomEvent.RESUME_GAME, onCloseCartoon);
			removeChild(_cartoon, true);
			_cartoon = null;
			
			_game.loadLevel(_levelSelect.getXML(1), 1);
			Game.state = Game.STATE_PLAYING;
			
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: fromLevelToGame2,
				alpha: 1
			});
		}
		
		private function fromLevelToGame2():void 
		{
			_levelSelect.reset();
			_levelSelect.visible = false;
			_game.visible = true;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		// Game -> Levels
		private function fromGameToLevel(e:CustomEvent):void 
		{
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: fromGameToLevel2,
				alpha: 1
			});
		}
		
		private function fromGameToLevel2():void 
		{
			_levelSelect.reset();
			_levelSelect.visible = true;
			_game.visible = false;
			_game.clearLevel();
			SoundManager.unmuteMusic();
			_soundManager.playMusic("Menu", 100000, "fromGameToLevel2");
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		// Levels -> Main Menu
		private function fromLevelToMain(e:CustomEvent):void 
		{
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: fromLevelToMain2,
				alpha: 1
			});
		}
		
		private function fromLevelToMain2():void 
		{
			_mainMenu.reset();
			_levelSelect.reset();
			_mainMenu.visible = true;
			_levelSelect.visible = false;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		// Main Menu -> Levels
		private function fromMainToLevel(e:CustomEvent):void 
		{
			_fadeImage.visible = true;
			_fadeImage.alpha = 0;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: fromMainToLevel2,
				alpha: 1 }
			);
		}
		
		private function fromMainToLevel2():void 
		{
			_mainMenu.visible = false;
			_levelSelect.visible = true;
			
			Starling.juggler.tween(_fadeImage, 0.25, { 
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: hideFadeImage,
				alpha: 0
			});
		}
		
		// Hide fade image
		private function hideFadeImage():void 
		{
			_fadeImage.visible = false;
		}
	}

}