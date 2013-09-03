package  
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class CustomEvent extends Event 
	{
		public static const RESUME_GAME:String = "resume game";
		public static const RESTART_GAME:String = "restart game";
		public static const MAIN_MENU:String = "main menu";
		public static const NEXT_LEVEL:String = "next level";
		public static const LEVEL_VICTORY:String = "level victory";
		public static const LEVEL_SELECT:String = "level select";
		public static const START_GAME:String = "start game";
		public static const CLEAR_PROGRESS:String = "clear progress";
		
		public function CustomEvent(type:String) 
		{
			super(type);
		}
		
	}

}