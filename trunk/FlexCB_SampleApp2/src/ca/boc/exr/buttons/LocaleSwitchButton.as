package ca.boc.exr.buttons
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.Application;

	[ResourceBundle("flex_cb_sample_app_2_lang")]
	public class LocaleSwitchButton extends Button
	{
		private var currentLocale:String;
		
		public function LocaleSwitchButton()
		{
			super();
			this.addEventListener(MouseEvent.CLICK, switchLocale);
			this.currentLocale = resourceManager.localeChain[0];
			this.label = this.currentLocale+" : "+ resourceManager.getString("flex_cb_sample_app_2_lang", "switch_language");
		}

		private function getNextLocale():String {
			var allLocales:Array = resourceManager.getLocales();
			var currentLocale:String = resourceManager.localeChain[0]; //just treat the first item as the current locale
			
			var n:int = allLocales.indexOf(currentLocale);
			n++;
			
			if (n >= allLocales.length) {
				n = 0; 
			}
			return allLocales[n];
		}
		
		private function switchLocale(event:Event):void {
			var nextLocale:String = getNextLocale();
			resourceManager.localeChain = [ nextLocale ];
			this.currentLocale = nextLocale;
			this.label = this.currentLocale+" : "+ resourceManager.getString("flex_cb_sample_app_2_lang", "switch_language");
			
			//some languages would need a different font to have the right characters
			var fontFamily:String = resourceManager.getString("flex_cb_sample_app_2_lang", "app_fontFamily");
			if (fontFamily) {
				Application.application.setStyle( "fontFamily", fontFamily);
			}			
		}
		
	}
}