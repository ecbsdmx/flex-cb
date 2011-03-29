// Copyright (C) 2011 European Central Bank. All rights reserved.
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
	import eu.ecb.core.view.BaseSDMXView;
	
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	
	import mx.controls.LinkButton;
	import mx.core.Application;
	
	/**
	 * A button that enables/disables full screen mode.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class FullScreen extends BaseSDMXView
	{
		/*==============================Fields================================*/
		
		private var _fullScreen:LinkButton;
		private var _fullScreenClicked:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function FullScreen()
		{
			super();
			styleName = "textBox";
		}
		
		/*========================Protected methods===========================*/

		/**
		 * @inheritDoc
		 */ 		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _fullScreen) {
				_fullScreen = new LinkButton();
				_fullScreen.addEventListener(MouseEvent.CLICK, 
					handleFullScreenClick);
				_fullScreen.label = "Enable full screen";
				_fullScreen.percentWidth = 100;
				Application.application.stage.addEventListener(
					FullScreenEvent.FULL_SCREEN, handleFullScreenEsc);
				addChild(_fullScreen);	
			}
		}
		
		/*=========================Private methods============================*/
		
		private function handleFullScreenClick(event:Event):void
		{
			_fullScreenClicked = true;
			if (Application.application.stage.displayState == 
				StageDisplayState.FULL_SCREEN) {
				Application.application.stage.displayState = 
					StageDisplayState.NORMAL;
				_fullScreen.label = "Enable full screen";	
			} else {
				Application.application.stage.displayState = 
					StageDisplayState.FULL_SCREEN;
				_fullScreen.label = "Disable full screen";
			}
		}
		
		private function handleFullScreenEsc(event:FullScreenEvent):void
		{
			if (_fullScreenClicked) {
				_fullScreenClicked = false;
			} else if (event.fullScreen) {
				_fullScreen.label = "Disable full screen";	
			} else {
				_fullScreen.label = "Enable full screen";
			}
		}
	}
}