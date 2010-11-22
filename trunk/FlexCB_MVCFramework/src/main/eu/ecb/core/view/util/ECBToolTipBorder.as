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
	import flash.display.Graphics;
	
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.graphics.IFill;
	import mx.graphics.RectangularDropShadow;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	import mx.skins.halo.ToolTipBorder;

	/**
	 * @private
	 */ 
	public class ECBToolTipBorder extends ToolTipBorder
	{
		public function ECBToolTipBorder()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number,
        	h:Number):void{
        	var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundAlpha:Number= getStyle("backgroundAlpha");
			var borderColor:uint = getStyle("borderColor");
			
			graphics.clear();		
			graphics.lineStyle(2, 0xAAAAAA, 0.4);	
			graphics.beginFill(backgroundColor, 0.4);
			graphics.drawRect(4, 1, w, h);
			graphics.endFill();
			
			graphics.lineStyle(1, borderColor, 100);
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRect(3, 0, w, h);
			graphics.endFill();
		} 
	}
}