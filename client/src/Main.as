package
{	
	import events.PlayerEvent;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.text.TextField;
	
	import music.MusicPlayer;
	
	import utils.SoundCloudManager;
	
	public class Main extends Sprite
	{
		public var musicPlayer:MusicPlayer;
		private var scManager:SoundCloudManager;
		private var verificationCode:TextField;
		
		public var LOCAL_SONGS:Array = [
			{title: "Everybody On Your Block", url: "/site/mp3/everybody_on_your_block.mp3", duration: 180000, play_count: 100, can_download: true, download_url: "", can_buy: false, buy_url: ""},		
			{title: "The Devil You Know", url: "/site/mp3/the_devil_you_know.mp3", duration: 180000, play_count: 100, can_download: false, download_url: "", can_buy: false, buy_url: ""},		
			{title: "Love Too Serious", url: "/site/mp3/love_too_serious.mp3", duration: 180000, play_count: 100, can_download: true, download_url: "", can_buy: false, buy_url: ""}		
			];
		
		[Embed(source='fonts/Arial.ttf', fontFamily="Arial", embedAsCFF="false")]
		public var Arial:Class;
		
		public function Main()
		{
			Security.allowDomain("*");
			musicPlayer = new MusicPlayer();
//			musicPlayer.songs = LOCAL_SONGS;
			scManager = new SoundCloudManager(musicPlayer);	
			scManager.addEventListener(PlayerEvent.SOUNDCLOUD_TRACKS_LOADED, onSoundCloudTracksLoaded);
			addChild(musicPlayer);
		}
		
		private function onSoundCloudTracksLoaded(evt:PlayerEvent):void
		{
			musicPlayer.initialize(scManager.scClient);
			updateVerificationCode();
		}
		
		private function updateVerificationCode():void
		{
			musicPlayer.playerClip.verificationSubmit.visible = false;
			musicPlayer.playerClip.verificationCode.visible = false;
			musicPlayer.playerClip.verificationSubmit.addEventListener(MouseEvent.CLICK, onSubmitVerificationCode);	
		}
		
		private function onSubmitVerificationCode(evt:MouseEvent):void
		{
			scManager.getAccessToken(musicPlayer.playerClip.verificationCode.text);
		}
	}
}