package  
{
	import assets.Assets;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class SoundManager 
	{
		//[Embed (source = "../media/sounds/click.mp3")]
		//private static const ClickSound:Class;
		//[Embed (source = "../media/sounds/build_quadrate.mp3")]
		//private static const BuildBoxSound:Class;
		//[Embed (source = "../media/sounds/fail.mp3")]
		//private static const FailSound:Class;
		//[Embed (source = "../media/sounds/get_star.mp3")]
		//private static const GetStarSound:Class;
		//[Embed (source = "../media/sounds/gun_shot.mp3")]
		//private static const ShotSound:Class;
		//[Embed (source = "../media/sounds/jump.mp3")]
		//private static const JumpSound:Class;
		//[Embed (source = "../media/sounds/jump_on_rubber.mp3")]
		//private static const Jump2Sound:Class;
		//[Embed (source = "../media/sounds/qadrate_fall.mp3")]
		//private static const BoxFallSound:Class;
		//[Embed (source = "../media/sounds/qadrate_move.mp3")]
		//private static const BoxMoveSound:Class;
		//[Embed (source = "../media/sounds/show_star1.mp3")]
		//private static const ShowStar1Sound:Class;
		//[Embed (source = "../media/sounds/show_star2.mp3")]
		//private static const ShowStar2Sound:Class;
		//[Embed (source = "../media/sounds/show_star3.mp3")]
		//private static const ShowStar3Sound:Class;
		//[Embed (source = "../media/sounds/win.mp3")]
		//private static const VictorySound:Class;
		//[Embed (source = "../media/sounds/button_on.mp3")]
		//private static const ButtonSound:Class;
		//[Embed (source = "../media/sounds/platform_move.mp3")]
		//private static const PlatformMoveSound:Class;
		//[Embed (source = "../media/sounds/voice1.mp3")]
		//private static const Voice1Sound:Class;
		//[Embed (source = "../media/sounds/voice2.mp3")]
		//private static const Voice2Sound:Class;
		//[Embed (source = "../media/sounds/voice3.mp3")]
		//private static const Voice3Sound:Class;
		//
		//[Embed (source = "../media/sounds/gameplay_music.mp3")]
		//private static const GameplayMusic:Class;
		//[Embed (source = "../media/sounds/menu_music.mp3")]
		//private static const MenuMusic:Class;
		
		private static var _instance:SoundManager;
		private static var _sounds:Dictionary;
		private static var _musicChannel:SoundChannel;
		public static var mutedMusic:Boolean = false;
		public static var mutedSound:Boolean = false;
		public static var mutedMusicIngame:Boolean = false;
		public static var mutedSoundIngame:Boolean = false;
		private static var _soundTransform:SoundTransform;
		
		public function SoundManager() 
		{
			_instance = this;
			fillSoundDictionary();
		}
		
		private static function fillSoundDictionary():void 
		{
			_sounds = new Dictionary();
			_sounds["Click"] = Assets.manager.getSound("click");
			_sounds["BuildBox"] = Assets.manager.getSound("build_quadrate");
			_sounds["Fail"] = Assets.manager.getSound("fail");
			_sounds["GetStar"] = Assets.manager.getSound("get_star");
			_sounds["Shot"] = Assets.manager.getSound("gun_shot");
			_sounds["Jump"] = Assets.manager.getSound("jump");
			_sounds["Jump2"] = Assets.manager.getSound("jump_on_rubber");
			_sounds["BoxFall"] = Assets.manager.getSound("qadrate_fall");
			_sounds["BoxMove"] = Assets.manager.getSound("qadrate_move");
			_sounds["ShowStar1"] = Assets.manager.getSound("show_star1");
			_sounds["ShowStar2"] = Assets.manager.getSound("show_star2");
			_sounds["ShowStar3"] = Assets.manager.getSound("show_star3");
			_sounds["Victory"] = Assets.manager.getSound("win");
			_sounds["Button"] = Assets.manager.getSound("button_on");
			_sounds["PlatformMove"] = Assets.manager.getSound("platform_move");
			_sounds["Voice1"] = Assets.manager.getSound("voice1");
			_sounds["Voice2"] = Assets.manager.getSound("voice2");
			_sounds["Voice3"] = Assets.manager.getSound("voice3");
			
			_sounds["Menu"] = Assets.manager.getSound("menu_music");
			_sounds["Game"] = Assets.manager.getSound("gameplay_music");
			
			_soundTransform = new SoundTransform();
		}
		
		public function playMusic(key:String, loops:int, callingFrom:String = "unknown"):void
		{
			//trace(callingFrom);
			if (_sounds[key] && !mutedMusic && !mutedMusicIngame)
			{
				if (_musicChannel)
				{
					_musicChannel.stop();
				}
				_musicChannel = _sounds[key].play(0, loops, _soundTransform);
				//_musicChannel.soundTransform = new SoundTransform(0.7);
			}
		}
		
		public function playSound(key:String):SoundChannel
		{
			if (_sounds[key] && !mutedSound && !mutedSoundIngame)
			{
				return _sounds[key].play();
			}
			return null;
		}
		
		public static function muteMusic():void
		{
			_soundTransform.volume = 0;
			mutedMusic = true;
			if (_musicChannel)
			{
				_musicChannel.soundTransform = _soundTransform;
			}
		}
		
		public static function unmuteMusic():void
		{
			mutedMusic = false;
			if (!mutedMusicIngame)
			{
				_soundTransform.volume = 0.7;
				if (_musicChannel)
				{
					_musicChannel.soundTransform = _soundTransform;
				}
			}
		}
		
		public static function muteSound():void
		{
			mutedSound = true;
		}
		
		public static function unmuteSound():void
		{
			mutedSound = false;
		}
		
		public static function getInstance():SoundManager
		{
			return (_instance == null) ? new SoundManager() : _instance;
		}
	}
}