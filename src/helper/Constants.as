package helper
{
	import flash.text.TextField;
    import starling.errors.AbstractClassError;

    public class Constants
    {
        public function Constants() { throw new AbstractClassError(); }
        
        // We chose this stage size because it is used by many mobile devices; 
        // it's e.g. the resolution of the iPhone (non-retina), which means that your game
        // will be displayed without any black bars on all iPhone models.
        // 
        // To use landscape mode, exchange the values of width and height, and set the
        // "aspectRatio" element in the config XML to "portrait".
        
        public static const STAGE_WIDTH:int  = 568;
        public static const STAGE_HEIGHT:int = 384;
		public static var realHeight:int;
		public static var x0:int;
		public static const IOS_APP_ID:String = "5157bc8799d6aa0c00000014";
		//public static var tf:TextField;
        
        public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
    }
}