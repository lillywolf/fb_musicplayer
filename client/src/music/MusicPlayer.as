package music
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	
	import events.PlayerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import utils.SongLoader;
	import utils.SoundCloudManager;
	
	public class MusicPlayer extends MovieClip
	{
		public var playerClip:lightPlayer;
		private var songLoader:SongLoader;
		public var autoPlay:Boolean;
		public var _songs:Array;
		public var songItems:Array;
		public var currentSongIndex:int;
		
		public static const NUM_SONGS_DISPLAYED:int = 4;
		
		public function MusicPlayer()
		{
			super();
			autoPlay = false;
			currentSongIndex = 0;
			songLoader = new SongLoader();
			songLoader.addEventListener(PlayerEvent.PLAY_COMPLETE, onSongPlayComplete);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);	
		}
		
		public function initialize(scClient:SoundcloudClient):void
		{
			// Initialize first song
			songLoader.scClient = scClient;
			if (_songs[0])
				songLoader.song = _songs[0];
			createLightPlayer();	
			updateTopPlayer();
		}
		
		public function createLightPlayer():void
		{
			// Clear out any song slots that might be in the UI design
			playerClip = new lightPlayer();
			clearSongClips();
			playerClip.topPlayer.playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClicked);
			playerClip.scrollDown.addEventListener(MouseEvent.CLICK, onSongsScrollDown);
			playerClip.scrollUp.addEventListener(MouseEvent.CLICK, onSongsScrollUp);
			showSongs();
			
			// Clears fill from song slots
			resetSongItems();			
			
			addChild(playerClip);
		}
		
		private function showSongs():void
		{
			clearSongItems();
			songItems = new Array();
			for (var i:int = currentSongIndex; i < NUM_SONGS_DISPLAYED + currentSongIndex; i++)
			{
				var si:SongItem = new SongItem(this);
				si.createSongClip(songs[i]);
				si.songClip.x = 19.3;
				si.songClip.y = 153 + 45.6 * (i - currentSongIndex);
				playerClip.addChild(si.songClip);
				songItems.push(si);
				
				// Hide all songClip fills unless they belong to the currently playing song
				if (si.song != songLoader.song)
				{
					si.songClip.songSlotFill.visible = false;
					si.songClip.songSlotFillMask.visible = false;
				}
			}		
		}
		
		private function clearSongItems():void
		{
			for each (var si:SongItem in songItems)
			{
				si.removeEventListeners();
				if (playerClip.contains(si.songClip))
					playerClip.removeChild(si.songClip);
			}
		}
		
		private function resetSongItems():void
		{
			for each (var si:SongItem in songItems)
			{
				si.songClip.songSlotFill.visible = false;
				si.songClip.songSlotFillMask.visible = false;
			}			
		}
		
		private function clearSongClips():void
		{
			var toClear:Array = new Array();
			for (var i:int = 0; i < playerClip.numChildren; i++)
			{
				var child:DisplayObject = playerClip.getChildAt(i);
				if (child is SongSlot)
					toClear.push(child);
			}
			for each (var ss:SongSlot in toClear)
			{			
				playerClip.removeChild(ss);
			}
		}
		
		public function	refreshSong(song:Object):void
		{			
			resetSongItems();
			updateTopPlayer();
		}
		
		public function updateTopPlayer():void
		{	
			playerClip.topPlayer.songTitle.text = songLoader.song.title;
			playerClip.topPlayer.downloadButton.removeEventListener(MouseEvent.CLICK, onDownloadButtonClicked);
			playerClip.topPlayer.buyButton.removeEventListener(MouseEvent.CLICK, onBuyButtonClicked);
			
			if (songLoader.song.can_download)
			{
				playerClip.topPlayer.downloadButton.enabled = true;				
				playerClip.topPlayer.downloadButton.addEventListener(MouseEvent.CLICK, onDownloadButtonClicked);
			}
			else
				playerClip.topPlayer.downloadButton.enabled = false;
		
			if (songLoader.song.can_buy)
			{
				playerClip.topPlayer.buyButton.enabled = true;
				playerClip.topPlayer.buyButton.addEventListener(MouseEvent.CLICK, onBuyButtonClicked);
			}
			else
				playerClip.topPlayer.buyButton.enabled = false;
		}
		
		private function onPlayButtonClicked(evt:MouseEvent):void
		{
			if (songLoader && songLoader.song)
			{
				playSong(songLoader.song);
			}	
		}	
		
		private function onSongsScrollDown(evt:MouseEvent):void
		{
			if (currentSongIndex + NUM_SONGS_DISPLAYED < _songs.length)
			{
				currentSongIndex++;
				showSongs();
			}
		}
		
		private function onSongsScrollUp(evt:MouseEvent):void
		{
			if (currentSongIndex > 0)
			{
				currentSongIndex--;
				showSongs();
			}
		}		
		
		public function resetSong():void
		{
			hidePlayerBar();
			resetSongItems();
			songLoader.resetSong();
			playerClip.topPlayer.gotoAndStop("stopped");
		}
		
		public function hidePlayerBar():void
		{			
			playerClip.topPlayer.songLoaderBar.songBarBack.visible = false;
			playerClip.topPlayer.songLoaderBar.songBarMask.visible = false;
		}
		
		public function showPlayerBar():void
		{			
			playerClip.topPlayer.songLoaderBar.songBarBack.visible = true;
			playerClip.topPlayer.songLoaderBar.songBarMask.visible = true;
		}	
		
		public function showSongSlotFill():void
		{
			var si:SongItem = getCurrentSongItem();
			si.songClip.songSlotFill.visible = true;
			si.songClip.songSlotFillMask.visible = true;
		}
		
		public function getCurrentSongItem():SongItem
		{
			for each (var si:SongItem in songItems)
			{
				if (si.song == songLoader.song)
					return si;
			}
			return null;
		}
		
		public function playSong(song:Object):void
		{
			showPlayerBar();
			showPauseButton();
			songLoader.playSong(song);
			showSongSlotFill();
		}
		
		public function showPauseButton():void
		{
			playerClip.topPlayer.gotoAndStop("playing");
			playerClip.topPlayer.getChildByName("pauseButton").removeEventListener(MouseEvent.CLICK, onPauseButtonClicked)
			playerClip.topPlayer.getChildByName("pauseButton").addEventListener(MouseEvent.CLICK, onPauseButtonClicked);
		}
		
		private function onPauseButtonClicked(evt:MouseEvent):void
		{
			pauseSong();
		}
		
		public function pauseSong():void
		{
			songLoader.pauseSong();
			playerClip.topPlayer.gotoAndStop("stopped");	
			playerClip.topPlayer.playButton.removeEventListener(MouseEvent.CLICK, onPlayButtonClicked);
			playerClip.topPlayer.playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClicked);
		}
		
		private function onSongPlayComplete(evt:PlayerEvent):void
		{
			var index:int = _songs.indexOf(songLoader.song);
			if (_songs.length > index + 1 && autoPlay)
				playSong(_songs[index + 1]);
		}
		
		private function onDownloadButtonClicked(evt:MouseEvent):void
		{
			if (songLoader.song.can_download)
				ExternalInterface.call(songLoader.song.download_url);
		}
		
		private function onBuyButtonClicked(evt:MouseEvent):void
		{
			if (songLoader.song.can_buy)
				ExternalInterface.call(songLoader.song.buy_url);
		}
		
		private function onEnterFrame(evt:Event):void
		{
			checkSongProgress();
			checkSongTime();
		}
		
		private function checkSongProgress():void
		{
			if (songLoader && playerClip)
			{
				playerClip.topPlayer.songLoaderBar.songBarMask.scaleX = songLoader.getSongProgress();
				var si:SongItem = getCurrentSongItem();
				if (si)
					si.songClip.songSlotFillMask.scaleX = songLoader.getSongProgress();				
			}
		}
		
		private function checkSongTime():void
		{
			var seconds:int = songLoader.getSongSecondsElapsed();
			var min:int = Math.floor(seconds/60);
			var secondString:String = (seconds < 10) ? "0" + (seconds - min * 60).toString() : (seconds - min * 60).toString();
			
			if (playerClip)
				playerClip.topPlayer.songTime.text = min.toString() + ":" + secondString;
		}
		
		public function set songs(val:Array):void
		{
			_songs = val;
		}
		
		public function get songs():Array
		{
			return _songs;
		}
	}
}