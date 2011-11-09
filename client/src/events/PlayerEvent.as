package events
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		public static const PLAY_COMPLETE:String = "play_complete";
		public static const SOUNDCLOUD_TRACKS_LOADED:String = "soundcloud_tracks_loaded";
		
		public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}