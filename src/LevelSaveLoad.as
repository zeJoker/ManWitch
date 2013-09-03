package  
{
	import flash.events.Event;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class LevelSaveLoad
	{
		public var loaded:Boolean = false;
		public var loadedXML:XML;
		private var _fileReference:FileReference;
		
		public function LevelSaveLoad() 
		{
			
		}
		
		public function saveLevel(xml:XML):void
		{
			_fileReference = new FileReference();
			_fileReference.save(xml, "Level.xml");
		}
		
		public function loadLevel():void
		{
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.SELECT, onLoad);
			_fileReference.browse();
		}
		
		private function onLoad(e:Event):void 
		{
			_fileReference.addEventListener(Event.COMPLETE, onLevelLoaded);
			_fileReference.load();
		}
		
		private function onLevelLoaded(e:Event):void 
		{
			loaded = true;
			loadedXML = XML(e.target.data);
		}
	}
}