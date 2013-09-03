package  
{
	import assets.Assets;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Pregame extends Sprite 
	{
		[Embed (source = "../media/levels/2.xml", mimeType="application/octet-stream")]
		private var Level2:Class;
		
		public function Pregame() 
		{
			
		}
		
		public function start(bg:Texture, assets:AssetManager):void 
		{
			Assets.manager = assets;
			(Assets.manager as AssetManager).loadQueue(function onProgress(ratio:Number):void
            {
                //progressBar.ratio = ratio;
                //trace(ratio);
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                
                if (ratio == 1)
                    Starling.juggler.delayCall(play, 0.15, null);
            });
		}
		
		private function play(e:Event):void 
		{
			var game:Game = new Game();
			addChild(game);
			game.loadLevel(XML(new Level2()), 2);
			SoundManager.muteMusic();
		}
		
	}

}