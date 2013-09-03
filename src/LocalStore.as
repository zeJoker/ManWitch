package  
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class LocalStore 
	{
		private static var _sharedObject:SharedObject = SharedObject.getLocal("ForeverSteveCache");
		public static var data:Object = _sharedObject.data;
		
		public static function save():void
		{
			_sharedObject.flush();
		}
		
		public static function clear():void
		{
			_sharedObject.clear();
		}
	}

}