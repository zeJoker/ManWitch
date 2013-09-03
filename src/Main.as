package 
{
	import assets.Assets;
	import Box2D.Dynamics.b2DebugDraw;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import physics.PhysicWorld;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	//[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		[Embed (source = "../media/preloader/Paused.png")]
		private const PausedClass:Class;
		[Embed (source = "../media/preloader/Click.png")]
		private const ClickClass:Class;
		
		public static var myStarling:Starling;
		public static var debugSprite:Sprite;
		
		private var debugSprite:Sprite;
		private var _pausedScreen:Bitmap;
		private var _pausedText:Bitmap;
		private var _pausedText2:Bitmap;
		private var _timer:int = 0;
		private var domain:String;
		
		public function Main():void 
		{
			if (stage)
				init(null)
			else	
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//setDebugDraw();
			
			addEventListener(Event.DEACTIVATE, onDeactivate);
			
			if (isUrl(["argh-games.com", "argh-games"]))
			{
				Assets.contentScaleFactor = 1;
				myStarling = new Starling(MainMenu, stage);
				myStarling.antiAliasing = 1;
				myStarling.start();
			}
			else
			{
				var tf:TextField = new TextField();
				tf.width = 100;
				tf.height = 100;
				tf.text = "Sorry, wrong URL!";
				tf.x = 270;
				tf.y = 200;
				addChild(tf);
			}
		}
		
		private function isUrl(urls:Array):Boolean
		{
			//return true;
			
			var url:String = stage.loaderInfo.loaderURL;
			var urlStart:Number = url.indexOf("://") + 3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			domain = url.substring(urlStart, urlEnd);
			var LastDot:Number = domain.lastIndexOf(".") - 1;
			var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
			domain = domain.substring(domEnd, domain.length);
			
			for (var i:int = 0; i < urls.length; i++)
			{
				if (domain == urls[i])							
					return true;
			}
			
			return false;
			//return true;
		}
		
		private function onDeactivate(e:Event):void 
		{
			if (!_pausedScreen)
			{
				_pausedScreen = new Bitmap(new BitmapData(640, 480, false, 0x000000));
				addChild(_pausedScreen);
				
				_pausedText = new PausedClass();
				_pausedText.x = 253;
				_pausedText.y = 224;
				addChild(_pausedText);
				
				_pausedText2 = new ClickClass();
				_pausedText2.x = 197;
				_pausedText2.y = 260;
				addChild(_pausedText2);
			}
			_pausedScreen.visible = true;
			_pausedText.visible = true;
			_pausedText2.visible = true;
			
			removeEventListener(Event.DEACTIVATE, onDeactivate);
			addEventListener(Event.ACTIVATE, onActivate);
			SoundManager.muteMusic();
			_timer = 0;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (_timer == 1)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				myStarling.stop();
			}
			else
			{
				++_timer;
			}
		}
		
		private function onActivate(e:Event):void 
		{
			_pausedScreen.visible = false;
			_pausedText.visible = false;
			_pausedText2.visible = false;
			addEventListener(Event.DEACTIVATE, onDeactivate);
			removeEventListener(Event.ACTIVATE, onActivate);
			SoundManager.unmuteMusic();
			_timer = 0;
			addEventListener(Event.ENTER_FRAME, onEnterFrame2);
		}
		
		private function onEnterFrame2(e:Event):void 
		{
			if (_timer == 1)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame2);
				myStarling.start();
			}
			else
			{
				++_timer;
			}
		}
		
		private function setDebugDraw():void
		{
			debugSprite = new Sprite();
			addChild(debugSprite);
			
			var worldDebugDraw:b2DebugDraw=new b2DebugDraw();
			worldDebugDraw.SetSprite(debugSprite);
			worldDebugDraw.SetDrawScale(PhysicWorld.SCALE);
			worldDebugDraw.SetLineThickness( 1.0);
			worldDebugDraw.SetAlpha(1);
			worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			worldDebugDraw.SetFillAlpha(0.5);
			PhysicWorld.world.SetDebugDraw(worldDebugDraw);
		}
	}
	
}