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
	import eu.ecb.core.event.ProgressEventMessage;
	
	import mx.containers.VBox;
	import mx.controls.ProgressBar;
	import mx.skins.halo.ProgressIndeterminateSkin;
	import flash.utils.getDefinitionByName;

	/**
	 * A box containing a progress bar.
	 *  
	 * @author Xavier Sosnovsky
	 * @author Steven Bagshaw
	 */
	public class ProgressBox extends VBox
	{
		
		/*==============================Fields================================*/
		
		private var _progressBar:ProgressBar;
		
		/*===========================Constructor==============================*/
		
		public function ProgressBox()
		{
			super();
			width = 230;
			height = 50;
			styleName = "progressBox";
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Displays loading information in the progress bar.
		 *  
		 * @param event The event containing the loading information
		 * 
		 */
		public function showWait(event:ProgressEventMessage):void
		{
			if (null != _progressBar) {
				_progressBar.label = event.message;
				_progressBar.setProgress(event.bytesLoaded, event.bytesTotal);
			}
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _progressBar) {
				_progressBar = new ProgressBar();
				
				//next 4 lines added, because in certain contexts (i.e. one of my projects)
				//the default styles are not getting registered, which causes a crash
				//see http://tech.groups.yahoo.com/group/flexcoders/message/158663 - SBa 20110720
				_progressBar.setStyle("maskSkin", getDefinitionByName("mx.skins.halo.ProgressMaskSkin") as Class);
				_progressBar.setStyle("barSkin", getDefinitionByName("mx.skins.halo.ProgressBarSkin") as Class);
				_progressBar.setStyle("trackSkin", getDefinitionByName("mx.skins.halo.ProgressTrackSkin") as Class);
				_progressBar.setStyle("indeterminateSkin", getDefinitionByName("mx.skins.halo.ProgressIndeterminateSkin") as Class);
				
				_progressBar.mode = "manual";
				_progressBar.label = "0% Complete";
				addChild(_progressBar);
			}
		}		
	}
}