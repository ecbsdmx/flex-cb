// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
// Copyright (C) 2008 European Central Bank. All rights reserved.
//
// Redistribution and use in source and binary forms,
// with or without modification, are permitted
// provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// Neither the name of the European Central Bank
// nor the names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
package eu.ecb.core.view.util
{

	import flash.display.GradientType;
	import mx.core.UIComponent;
	import mx.core.EdgeMetrics;
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	import mx.skins.halo.HaloColors;

	/**
	 *@private 
	* The skin for the background of a MenuBar.
	*/
	public class MenuBarCustomSkin extends Border
	{
		private static var cache:Object = {};
		
		private var _borderMetrics:EdgeMetrics = new EdgeMetrics(0, 0, 0, 0);
		
		public function MenuBarCustomSkin()
		{
			super();
		}
		
		override public function get borderMetrics():EdgeMetrics
		{
			return _borderMetrics;
		}
		
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
		
			var bevel:Boolean = getStyle("bevel");
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var fillAlphas:Array = getStyle("fillAlphas");
			var fillColors:Array = getStyle("fillColors");
			StyleManager.getColorNames(fillColors);
			var themeColor:uint = getStyle("themeColor");
			var derStyles:Object = calcDerivedStyles(themeColor, fillColors[0],
				fillColors[1]);
			var borderColorDrk1:Number =
				ColorUtil.adjustBrightness2(borderColor, -25);
			var cr:Number = Math.max(0, cornerRadius);
			var cr1:Number = Math.max(0, cornerRadius - 1);
			var upFillColors:Array = [ fillColors[0], fillColors[1] ];
			var upFillAlphas:Array = [ fillAlphas[0], fillAlphas[1] ];
			graphics.clear();
			drawRoundRect(1, 1, w - 2, h - 2, cr1, upFillColors, upFillAlphas,
				verticalGradientMatrix(1, 1, w - 2, h - 2));
		}

		private static function calcDerivedStyles(themeColor:uint,		
			fillColor0:uint, fillColor1:uint):Object
		{
			var key:String = HaloColors.getCacheKey(themeColor,
			fillColor0, fillColor1);
			if (!cache[key]) {
				var o:Object = cache[key] = {};
				HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);	
			}
			return cache[key];
		}
	}
}