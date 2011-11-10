package utils
{
	import avmplus.USE_ITRAITS;
	
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	
	import events.PlayerEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import music.MusicPlayer;
	import music.SongItem;
	
	public class SongLoader extends EventDispatcher
	{		
		private var urlRequest:URLRequest;
		public var sound:Sound;
		private var sc:SoundChannel;
		private var slc:SoundLoaderContext;
		private var position:Number;
		public var isPlaying:Boolean;
		
		public var _scClient:SoundcloudClient;
		public var _song:Object;
		
		public function SongLoader(target:IEventDispatcher=null)
		{
			super(target);
			position = 0;
			slc = new SoundLoaderContext();
		}
		
		public function loadSong(song:Object):void
		{
			_song = song;
			urlRequest = _scClient.getSignedURLRequest(_song.url);
//			urlRequest = new URLRequest(_song.url);
			sound = new Sound(urlRequest);
		}
		
		private function onSoundLoadError(evt:IOErrorEvent):void
		{
			trace("error: " + evt.text);
		}
		
		public function playSong(song:Object):void
		{
		 	isPlaying = true;
			if (position && sc)
				resumeSong();
			else
				startSong(song);
		}
		
		public function pauseSong():void
		{
			if (sc)
			{
				position = sc.position;
				sc.stop();
				isPlaying = false;
			}
		}
		
		public function resumeSong():void
		{
			sc = sound.play(position);
			sc.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);			
		}
		
		public function startSong(song:Object):void
		{
			if (sc)
				sc.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			position = 0;
			loadSong(song);
			sc = sound.play(position);
			sc.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}	
		
		private function onSoundComplete(evt:Event):void
		{
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAY_COMPLETE));	
			resetSong();
		}
		
		public function resetSong():void
		{
			if (sc)
			{
				sc.stop();
				sc.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			position = 0;
			isPlaying = false;
		}
		
		public function getSongProgress():Number
		{
			if (sc)
				return sc.position/song.duration;
			else
				return 0;
		}
		
		public function getSongSecondsElapsed():int
		{
			if (sc)
				return sc.position / 1000;
			else
				return 0;
		}
		
		public function set scClient(val:SoundcloudClient):void
		{
			_scClient = val;
		}
		
		public function set song(val:Object):void
		{
			_song = val;
		}
		
		public function get song():Object
		{
			return _song;
		}
	}
}