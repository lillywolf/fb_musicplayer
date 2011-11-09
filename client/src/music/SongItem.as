package music
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SongItem extends EventDispatcher
	{
		public var _songClip:SongSlot;
		public var _song:Object;
		public var _musicPlayer:MusicPlayer;
		
		public function SongItem(musicPlayer:MusicPlayer, target:IEventDispatcher=null)
		{
			super(target);
			_musicPlayer = musicPlayer;			
		}
		
		public function createSongClip(song:Object):void
		{
			_song = song;
			_songClip = new SongSlot();
			_songClip.title.text = _song.title;
			_songClip.numPlays.text = _song.play_count;
			
			_songClip.title.autoSize = TextFieldAutoSize.NONE;
			
			if (song.can_download)
				_songClip.downloadButton.addEventListener(MouseEvent.CLICK, onDownloadButtonClicked);
			else
				_songClip.downloadButton.enabled = false;
			
			if (song.can_buy)
				_songClip.buyButton.addEventListener(MouseEvent.CLICK, onBuyButtonClicked);
			else
				_songClip.buyButton.enabled = false;
			
			_songClip.addEventListener(MouseEvent.CLICK, onSongClipClicked);
		}
		
		private function onSongClipClicked(evt:MouseEvent):void
		{
			_musicPlayer.resetSong();
			_musicPlayer.playSong(_song);
			_musicPlayer.updateTopPlayer();
			playSong();
		}
		
		private function playSong():void
		{
			// Show load effects, etc.
		}
		
		private function onDownloadButtonClicked(evt:MouseEvent):void
		{
			// Start a download
			if (_song.can_download)
				ExternalInterface.call(_song.download_url);
		}
		
		private function onBuyButtonClicked(evt:MouseEvent):void
		{
			if (_song.can_buy)
				ExternalInterface.call(_song.buy_url);
		}
		
		public function removeEventListeners():void
		{
			_songClip.removeEventListener(MouseEvent.CLICK, onSongClipClicked);
			_songClip.downloadButton.removeEventListener(MouseEvent.CLICK, onDownloadButtonClicked);
			_songClip.buyButton.removeEventListener(MouseEvent.CLICK, onBuyButtonClicked);
		}
		
		public function get songClip():SongSlot
		{
			return _songClip;
		}
		
		public function get song():Object
		{
			return _song;
		}
	}
}