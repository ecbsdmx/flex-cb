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
	import mx.containers.HBox;
	import mx.controls.LinkButton;
	import mx.controls.Image;
	import flash.events.MouseEvent;

	/**
	 * Displays a link to go one level up. This can be useful for instance
	 * when drilling down in a column chart.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class LinkUp extends HBox
	{
		
		/*==============================Fields================================*/
		
		[Embed(source="../../../assets/images/arrow.gif")] 
		private var _arrow:Class;
		
		private var _link:LinkButton;
		
		/*===========================Constructor==============================*/
		
		public function LinkUp()
		{
			super();
			setStyle("horizontalGap", 0);
			setStyle("verticalAlign", "middle");
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */  
		override protected function createChildren():void {
			super.createChildren();
			
			if (null == _link) {
				var image:Image = new Image();
				image.source = _arrow;
				addChild(image);
				_link = new LinkButton();
				_link.label = "Go one level up";
				_link.addEventListener(MouseEvent.MOUSE_OVER, 
					onHoverOverUnderline, false, 0, true);
				_link.addEventListener(MouseEvent.MOUSE_OUT, 
					onHoverOutUnderline, false, 0, true);
				addChild(_link);
			}
		}
		
		/*=========================Private methods============================*/
		
		private function onHoverOverUnderline(event:MouseEvent):void 
		{
			if (event.target is LinkButton) {
		    	event.target.setStyle("textDecoration", "underline");
		 	}
		 	event.stopImmediatePropagation();
			event = null;
	    }
	    
	    private function onHoverOutUnderline(event:MouseEvent):void 
	    {
	    	if (event.target is LinkButton) {
		    	event.target.setStyle("textDecoration", "none"); 
		 	}
	    	event.stopImmediatePropagation();
			event = null;
	    }
	}
}