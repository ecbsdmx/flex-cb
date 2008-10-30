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
	import mx.controls.Text;
	import mx.containers.TitleWindow;

	/**
	 * Class for displaying a message box. Style will be applied depending on
	 * the type of box being displayed (error or information). 
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	internal class MessageBox extends TitleWindow 
	{
		/*==============================Fields================================*/
		
		protected var _message:String;
		
		protected var _isError:Boolean;
		
		protected var _messageChanged:Boolean;
		
		protected var _isErrorChanged:Boolean;
		
		protected var _textArea:Text;
		
		/*===========================Constructor==============================*/
		
		public function MessageBox()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set message(message:String):void 
		{
			if (_message != message) {
				_message = message;
				_messageChanged = true;
				invalidateProperties();
				invalidateSize();
			}
		}
		
		/**
		 * The message displayed in the window
		 */ 
		public function get message():String 
		{
			return _message;
		}
		
		/**
		 * @private
		 */ 
		public function set isError(isError:Boolean):void 
		{
			if (_isError != isError) {
				_isError = isError;
				_isErrorChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * Whether or not the window is containing an error message
		 */ 
		public function get isError():Boolean 
		{
			return _isError;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void {
			super.createChildren();
			if (null == _textArea) {
				_textArea = new Text();
				_textArea.percentHeight = 100;
				_textArea.percentWidth = 100;
				addChild(_textArea);
				styleName = "informationBox";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void {
			super.commitProperties();
			if (_messageChanged) {
				_textArea.text = _message;
			}
			if (_isErrorChanged) {
				styleName = (_isError ? "errorBox" : "informationBox");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void {
			super.measure();
			if (null != _message) {
				var stringLength:uint = _message.length;
				if (_message.length * 6 > maxWidth) {
					width = maxWidth;
					var lines:Number = 
						Math.ceil((_message.length * 6) / maxWidth);
					height = (lines * 20) + 10;
				}
			}
		}
	}
}