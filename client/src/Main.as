package
{
	import basic_ui_fla.button_buy_blue_8;
	
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
		
		[Embed(source='fonts/Arial.ttf', fontFamily="Arial", embedAsCFF="false")]
		public var Arial:Class;
		
		public function Main()
		{
			Security.allowDomain("*");
			musicPlayer = new MusicPlayer();
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