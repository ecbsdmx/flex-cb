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
package org.sdmx.util.net
{
	import org.sdmx.event.XMLDataEvent;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	/**
	 * Event dispatched when the XML data has been successfully loaded.
	 */	
	[Event(name="dataLoaded", type="eu.ecb.event.XMLDataEvent")]
	
	/**
	 * Loads an XML file, either in compressed or uncompressed format.
	 * 
	 * The class will dispatches an eu.ecb.event.XMLDataEvent when the data
	 * has been loaded. It can also dispatches error and progress information.
	 * 
	 * The main differences with the LoaderAdapter class is that 1) this class 
	 * will try to load the data in uncompressed format in case an error occurs
	 * when uncompressing the data and 2) the data will be treated as XML.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class XMLLoader extends LoaderAdapter
	{
		/*==============================Fields================================*/

		/**
		 * Whether the system has encountered an error and is now attempting to
		 * load the data again, in uncompressed format. This is used so as to 
		 * not dispatch progress information a second time.
		 */ 
		private var _secondAttempt:Boolean;		
		
		/*===========================Constructor==============================*/
		
		public function XMLLoader() 
		{
			super();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function handleData(event:Event):void 
		{
			event.stopImmediatePropagation();
			event = null;
			try {
				var xmlData:XML;
				if (_compressed) {
					var data:ByteArray = _urlLoader.data;
					data.uncompress();
					data.position = 0;
					xmlData = XML(data.readUTFBytes(data.bytesAvailable));
				} else {
					xmlData = XML(_urlLoader.data);
				}
				dispatchEvent(new XMLDataEvent(xmlData, 
					LoaderAdapter.DATA_LOADED));
			} catch (error:Error) {
				_secondAttempt = true;
				compressed = false;
				execute();
			}			
        }
		
		/*=========================Protected methods==========================*/
		
		/**
		 * @private
		 */ 
		override protected function handleProgress(event:ProgressEvent):void 
		{
			event.stopImmediatePropagation();
        	if (!_secondAttempt) {
	        	super.handleProgress(event);
	        }
		}
	}
}