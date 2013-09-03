package assets
{
	import adobe.utils.CustomActions;
    import flash.display.Bitmap;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
	import starling.utils.AssetManager;
    
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class Assets
    {
        // If you're developing a game for the Flash Player / browser plugin, you can directly
        // embed all textures directly in this class. This demo, however, provides two sets of
        // textures for different resolutions. That's useful especially for mobile development,
        // where you have to support devices with different resolutions.
        //
        // For that reason, the actual embed statements are in separate files; one for each
        // set of textures. The correct set is chosen depending on the "contentScaleFactor".
        
        // true type fonts
        
        //[Embed(source="../media/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]        
        //private static const UbuntuRegular:Class;
        
        // sounds
        
        //[Embed(source="../media/audio/click.mp3")]
        //private static const Click:Class;
        
        // static members
        
        private static var sContentScaleFactor:Number = 1;
        private static var sTextures:Dictionary = new Dictionary();
        private static var sSounds:Dictionary = new Dictionary();
        private static var sTextureAtlas:TextureAtlas;
        private static var sBitmapFontsLoaded:Boolean;
		private static var sMainMenuAtlas:TextureAtlas;
		public static var manager:AssetManager;
        
        public static function getTexture(name:String):Texture
        {
            //if (sTextures[name] == undefined)
            //{
                //var data:Object = create(name);
                //
                //if (data is Bitmap)
                    //sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
                //else if (data is ByteArray)
                    //sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
            //}
            
            return (manager as AssetManager).getTexture(name);
        }
        
        public static function getAtlasTexture(name:String):Texture
        {
            //prepareAtlas();
            //return sTextureAtlas.getTexture(name);
			return (manager as AssetManager).getTexture(name);
        }
        
        public static function getAtlasTextures(prefix:String):Vector.<Texture>
        {
            //prepareAtlas();
            //return sTextureAtlas.getTextures(prefix);
			return (manager as AssetManager).getTextures(prefix);
        }
        
        //public static function getSound(name:String):Sound
        //{
            //var sound:Sound = sSounds[name] as Sound;
            //if (sound) return sound;
            //else throw new ArgumentError("Sound not found: " + name);
        //}
        
        //public static function loadBitmapFonts():void
        //{
            //if (!sBitmapFontsLoaded)
            //{
                //var texture:Texture = getTexture("DesyrelTexture");
                //var xml:XML = XML(create("DesyrelXml"));
                //TextField.registerBitmapFont(new BitmapFont(texture, xml));
                //sBitmapFontsLoaded = true;
            //}
        //}
        
        //public static function prepareSounds():void
        //{
            //sSounds["Click"] = new Click();   
        //}
        
        //private static function prepareAtlas():void
        //{
            //if (sTextureAtlas == null)
            //{
                //var texture:Texture = getTexture("AtlasTexture");
                //var xml:XML = XML(create("AtlasXml"));
                //sTextureAtlas = new TextureAtlas(texture, xml);
            //}
        //}
        
        //private static function create(name:String):Object
        //{
            //var textureClass:Class = AssetEmbeds_1x;
            //return new textureClass[name];
        //}
		
		public static function getMainMenuAtlas():TextureAtlas
		{
			return manager.getTextureAtlas("MainMenuAtlas");
		}
        
        public static function get contentScaleFactor():Number { return sContentScaleFactor; }
        public static function set contentScaleFactor(value:Number):void 
        {
            for each (var texture:Texture in sTextures)
                texture.dispose();
            //trace(value);
            sTextures = new Dictionary();
            //sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
			if (value <= 1)
				sContentScaleFactor = 1;
			else if (value < 2.1)
				sContentScaleFactor = 2;
			else
				sContentScaleFactor = 4;
			
			//trace(sContentScaleFactor);
        }
    }
}