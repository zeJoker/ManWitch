package
{
	import assets.AssetEmbeds_1x;
	import assets.Assets;
	import com.freshplanet.ane.AirChartboost;
	import com.freshplanet.ane.AirChartboostEvent;
	import com.milkmangames.nativeextensions.RateBox;
	import com.playhaven.events.ContentDismissalReason;
	import com.playhaven.events.PlayHavenEvent;
	import com.playhaven.PlayHaven;
	import com.revmob.airextension.RevMob;
    import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	import flash.filesystem.File;
    import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import helper.Constants;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.events.Event;
    import starling.core.Starling;
    
    [SWF(frameRate="60", backgroundColor="#000")]
    public class Main_iOS extends Sprite
    {
		// Startup image for SD screens
        [Embed(source="../media/background1x.jpg")]
        private static var Background:Class;
        [Embed(source="../media/background2x.jpg")]
        private static var Background2:Class;
        [Embed(source="../media/background4x.jpg")]
        private static var Background4:Class;
		
        private var mStarling:Starling;
		private var LoadingClass:Class;
		private var revMob:RevMob;
		private var background:Bitmap;
		private var scale:int;
		private var viewPort:Rectangle;
		private var screenHeight:int;
		private var screenWidth:int;
        
        public function Main_iOS()
        {
            // set general properties
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            Starling.multitouchEnabled = true;
            Starling.handleLostContext = false;
			
            screenWidth  = stage.fullScreenWidth;
            screenHeight = stage.fullScreenHeight;
            viewPort = new Rectangle();
			scale = Math.round(screenWidth / 568);
			
			viewPort.width = 568 * scale;
			viewPort.height = 384 * scale;
			Constants.realHeight = screenHeight / scale;
			viewPort.x = (screenWidth - viewPort.width) / 2;
			Constants.x0 = -viewPort.x / scale;
            
			if (screenWidth == 480)
			{
				LoadingClass = Background;
			}
			else if (screenWidth == 1136)
			{
				LoadingClass = Background2;
			}
			else
			{
				LoadingClass = Background4;
			}
			background = new LoadingClass();
            if (screenWidth == 2048)
			{
				background.width  = screenWidth;
				background.height = screenHeight;
			}
            background.x = screenWidth * 0.5 - background.width * 0.5;
            background.smoothing = true;
			background.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
            addChild(background);
        }
		
		private function onAdded(e:flash.events.Event):void 
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
			
			PlayHaven.create("706bb797ba3d4431a42575cfb6a2042e", "a790399955814d0ca4081f83490da55a");
			PlayHaven.playhaven.reportGameOpen();
			
			fillIAP();
			
			if (!IAP.purchased)
			{
				IAP.getProduct();
				AirChartboost.getInstance().startSession("5157bd5b17ba47f53c00002b", "369aef14b5a77f216e8f68fd66b0a648dd81f735");
				if (!AirChartboost.getInstance().hasCachedInterstitial())
					AirChartboost.getInstance().cacheInterstitial();
				//IAP.purchased = true;
				//LocalStore.data.purchased = true;
			}
			
			if (!IAP.purchased)
			{
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,onContentDismissed);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,onContentDisplayed);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED, onContentFailed);
				PlayHaven.playhaven.sendContentRequest("on_launch", false);
			}
			
			if (RateBox.isSupported())
			{
				RateBox.create("629396017",	"Feedback", 
				"We Need Your Help! Please take a moment to rate this game. It will help us make more games. If you love this game please let us know! :)",
				"Rate This App", "Remind Me Later", "Don't Ask Again", 3, 0, 1, 2);
				//"Rate This App", "Remind Me Later", "Don't Ask Again", 3, 0, 0, 0);
				//RateBox.rateBox.useTestMode();
			}
			
			NativeApplication.nativeApplication.executeInBackground = true;
            mStarling = new Starling(StateManager, stage, viewPort, null, "auto", "baseline");
			mStarling.antiAliasing = 0;
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.stage.stageWidth = 568;
			mStarling.stage.stageHeight = 384;
			//mStarling.showStatsAt("center");
            mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:StateManager):void
                {
                    mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
                    removeChild(background);
                    
                    var bgTexture:Texture = Texture.fromBitmap(background, false, false, scale);
					background = null;
					
					NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
					
                    app.start(bgTexture);
                    mStarling.start();
                });
		}
		
		private function fillIAP():void 
		{
			if (!LocalStore.data.purchased)
			{
				LocalStore.data.purchased == "not purchased";
				LocalStore.save();
			}
			
			if (LocalStore.data.purchased == "purchased")
				IAP.purchased = true;
			else if (LocalStore.data.purchased == "not purchased")
				IAP.purchased = false;
			
			if (LocalStore.data.sexyGirl)
			{
				if (LocalStore.data.sexyGirl == 1)
					IAP.sexyGirlPurchased = true;
			}
			else
			{
				LocalStore.data.sexyGirl = 0;
				LocalStore.save();
			}
			
			if (LocalStore.data.hints)
			{
				IAP.hintsLeft = LocalStore.data.hints;
			}
			else
			{
				LocalStore.data.hints = 3;
				LocalStore.save();
			}
		}
		
		private function onContentDismissed(e:PlayHavenEvent):void 
		{
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,onContentDismissed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,onContentDisplayed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED, onContentFailed);
			switch(e.contentDismissalReason)
			{
				case ContentDismissalReason.USER_CONTENT_TRIGGERED:
				{
					trace("the user or content unit closed the window.");
					break;
				}
				case ContentDismissalReason.USER_BUTTON_CLOSED:
				{
					trace("the close button was pushed.");
					break;
				}
				case ContentDismissalReason.APP_BACKGROUNDED:
				{
					trace("the app was sent to the background.");
					break;
				}
				case ContentDismissalReason.NO_CONTENT_AVAILABLE:
				{
					trace("no content was found for the placement.");
					AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
					AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
					AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
					AirChartboost.getInstance().showInterstitial();
					break;
				}
			}
		}
		
		private function onFailsAdsHandler(e:AirChartboostEvent):void 
		{
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
			revMob = new RevMob(Constants.IOS_APP_ID);
			revMob.printEnvironmentInformation();
			revMob.setTestingMode(false);
			revMob.showFullscreen();
		}
		
		private function onCloseAdsHandler(e:AirChartboostEvent):void 
		{
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
		}
		
		private function onDismissAdsHandler(e:AirChartboostEvent):void 
		{
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().removeEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
			revMob = new RevMob(Constants.IOS_APP_ID);
			revMob.printEnvironmentInformation();
			revMob.setTestingMode(false);
			revMob.showFullscreen();
		}
		
		private function onContentDisplayed(e:PlayHavenEvent):void 
		{
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,onContentDismissed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,onContentDisplayed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED, onContentFailed);
		}
		
		private function onContentFailed(e:PlayHavenEvent):void 
		{
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,onContentDismissed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,onContentDisplayed);
			PlayHaven.playhaven.removeEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED, onContentFailed);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
			AirChartboost.getInstance().showInterstitial();
		}
		
		private function onActivate(e:flash.events.Event):void 
		{
			if (RateBox.isSupported())
			{
				RateBox.rateBox.onLaunch();
			}
			NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			//Constants.tf.text = "ACTIVATED";
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			SoundManager.unmuteMusic();
			mStarling.start();
		}
		
		private function onDeactivate(e:flash.events.Event):void 
		{
			NativeApplication.nativeApplication.removeEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			SoundManager.muteMusic();
			mStarling.stop();
		}
		
		public static function loadAds():void
		{
			AirChartboost.getInstance().startSession("5157bd5b17ba47f53c00002b", "369aef14b5a77f216e8f68fd66b0a648dd81f735");
		}
		
		public static function showAds(key:String, onFailsAdsHandler:Function, onCloseAdsHandler:Function, onDismissAdsHandler:Function):void
		{
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL, onFailsAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_CLOSE_INTERSTITIAL, onCloseAdsHandler);
			AirChartboost.getInstance().addEventListener(AirChartboostEvent.DID_DISMISS_INTERSTITIAL, onDismissAdsHandler);
			if (!AirChartboost.getInstance().hasCachedInterstitial(key))
				AirChartboost.getInstance().cacheInterstitial(key);
			AirChartboost.getInstance().showInterstitial(key);
		}
    }
}