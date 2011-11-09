package utils
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.events.SoundcloudAuthEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	
	import events.PlayerEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.xml.XMLDocument;
	
	import music.MusicPlayer;
	
	import org.iotashan.oauth.OAuthToken;
	
	public class SoundCloudManager extends EventDispatcher
	{
		public var scClient:SoundcloudClient;
		protected var _musicPlayer:MusicPlayer;
		
		private static const LILLY_SOUNDCLOUD_ACCESS_CODE:String = "302883";
		
		public function SoundCloudManager(musicPlayer:MusicPlayer, target:IEventDispatcher=null)
		{
			super(target);
			_musicPlayer = musicPlayer;
			scClient = new SoundcloudClient("738091d6d02582ddd19de7109b79e47b", "b8f231ac6dc380b6efb2a8a88cd6d9fe", new OAuthToken("YcqXtz0xDgoGbz89Bdfw", "ccoemGqvYzKur1Y5p6fmQ1pTSgcNxVFQQeyZjr1ng"), false);
			
//			scClient.addEventListener(SoundcloudAuthEvent.REQUEST_TOKEN, onRequestTokenReturned);
//			scClient.addEventListener(SoundcloudAuthEvent.ACCESS_TOKEN, accessTokenHandler);			
//			var delegate:SoundcloudDelegate = scClient.getRequestToken();
//			delegate.addEventListener(SoundcloudFaultEvent.FAULT, faultHandler);
			
			getUserData();
		}
		
		private function onRequestTokenReturned(event:SoundcloudAuthEvent):void
		{
			// Go to authorize page
			scClient.authorizeUser();	
		}
		
		public function getAccessToken(code:String):void
		{
			var delegate:SoundcloudDelegate = scClient.getAccessToken(uint(code).toString());
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, faultHandler);
			trace("requesting SoundCloud access token");
		}
		
		private function accessTokenHandler(evt:SoundcloudAuthEvent):void
		{
			getUserData();
		}
		
		private function getUserData():void
		{			
			var delegate:SoundcloudDelegate = scClient.sendRequest("me", URLRequestMethod.GET);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, getMeCompleteHandler);			
		}
		
		protected function getMeCompleteHandler(event:SoundcloudEvent):void
		{
			trace("user data received. they call me " + event.data.username);
			getUserTracks();
		}
		
		protected function getUserTracks():void
		{
			var delegate:SoundcloudDelegate = scClient.sendRequest("me/tracks", URLRequestMethod.GET);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, getTracksCompleteHandler);			
		}
		
		protected function getTracksCompleteHandler(event:SoundcloudEvent):void
		{
			_musicPlayer.songs = new Array();		
			var tracks:XMLList = (event.data as XML).children();
			for each (var trackXML:XML in tracks)
			{
				_musicPlayer.songs.push({
					title: trackXML.child("title"), 
					url: trackXML.child("stream-url"),
					duration: trackXML.child("duration"),
					play_count: trackXML.child("playback-count"),
					can_download: true, 
					download_url: trackXML.child("download-url"),
					can_buy: false,
					buy_url: trackXML.child("purchase-url")});
			}
			
			dispatchEvent(new PlayerEvent(PlayerEvent.SOUNDCLOUD_TRACKS_LOADED));
		}
		
		protected function faultHandler(event:SoundcloudFaultEvent):void
		{
			trace("error: " + event.message);
		}		
		
		
	}
}