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
	import mx.core.UIComponent;
	import flash.events.ErrorEvent;
	import mx.managers.PopUpManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import eu.ecb.core.event.ProgressEventMessage;
	
	/**
	 * Manages the popup window that displays error and progress information.
	 * 
	 * @author Xavier Sosnovsky
	 */  
	public class PopUpMediator extends EventDispatcher
	{
		/*==============================Fields================================*/
		
		private var _view:UIComponent;
		
		private var _messageBox:MessageBox;
		
		/*===========================Constructor==============================*/
		
		public function PopUpMediator(view:UIComponent) 
		{
			super();
			_view = view;
		}
		
		/*==========================Public methods============================*/

		/**
		 * Displays a window showing progress information.
		 * 
		 * @param event The event containing the progress information
		 */
		public function showWait(event:ProgressEventMessage = null):void 
		{
			createBox((null == event) ? "Please wait. Loading data." : 
				event.message);
			if (null != event) {	
				event.stopImmediatePropagation();
				event = null;	
			}
		}

		/**
		 * Removes the window currently showing progress information. 
		 */
		public function clearWait():void 
		{
			clearBox();
		}
		
		/**
		 * Displays a window showing error information.
		 * 
		 * @param error The event containing information about the error.
		 */
		public function showError(error:ErrorEvent):void 
		{
			createBox(error.text, true);	
			error.stopImmediatePropagation();
			error = null;	
		}
		
		/*=========================Private methods============================*/
		
		private function clearBox():void 
		{
			if (_messageBox != null) {
                PopUpManager.removePopUp(_messageBox);
                _messageBox = null;
			}
		}
		
		private function createBox(message:String, isError:Boolean = false):void 
		{
			clearBox();
			_messageBox = new MessageBox();
			_messageBox.maxHeight = _view.height;
			_messageBox.maxWidth  = _view.width;
			_messageBox.isError = isError;
			_messageBox.message = message;						
			PopUpManager.addPopUp(_messageBox, _view, false);	
            PopUpManager.centerPopUp(_messageBox);
		}
	}
}