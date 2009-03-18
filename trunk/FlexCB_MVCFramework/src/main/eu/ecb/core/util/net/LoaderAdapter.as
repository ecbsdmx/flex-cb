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
package eu.ecb.core.util.net
{
	import eu.ecb.core.command.CommandAdapter;
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	/**
	 * Event dispatched when the data has been successfully loaded.
	 * 
	 * @eventType eu.ecb.core.util.net.LoaderAdapter.DATA_LOADED
	 */
	[Event(name="dataLoaded", type="flash.events.DataEvent")]
		
	/**
	 * Default implementation of the ILoader interface.
	 * 
	 * By default, a loader will dispatch:
	 * 1. A flash DataEvent when the data has been loaded. 
	 * 2. An error event, if an error occurs when loading a file.
	 * 3. Progress information when the file is loading.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class LoaderAdapter extends CommandAdapter implements ILoader
	{
		/*=============================Constants==============================*/
		
		/**
		 * The LoaderAdapter.DATA_LOADED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataLoaded</code> event.
		 * 
		 * @eventType dataLoaded
		 */  
		public static const DATA_LOADED:String = "dataLoaded";
					
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 			
		protected var _urlLoader:URLLoader;
		
		/**
		 * @private
		 */	
		protected var _file:URLRequest;
		
		/**
		 * @private
		 */
		protected var _compressed:Boolean;
		
		/*===========================Constructor==============================*/	
			
		public function LoaderAdapter(target:IEventDispatcher = null)
		{
			super();
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, handleData);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
				handleError);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The data file to be loaded. 
		 *  
		 * @param dataFile
		 */
		public function set file(file:URLRequest):void
		{
			_file = file;
			compressed = _file.url.indexOf(".zlib") > -1;
		}
		
		/**
		 *	Whether or not the file is compressed 
		 */
		public function set compressed(flag:Boolean):void
		{
			_compressed = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			_urlLoader.dataFormat = (_compressed) ? URLLoaderDataFormat.BINARY: 
				URLLoaderDataFormat.TEXT;
			
			if (_file.data is URLRequest) {
				var fileVariables:URLVariables = _file.data as URLVariables;
				fileVariables.fid = Math.random() * 1000;
			}
			
			_urlLoader.load(_file);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleData(event:Event):void 
		{
			event.stopImmediatePropagation();
			event = null;
			var out:String;
			if (_compressed) {
				var data:ByteArray = _urlLoader.data;
				data.uncompress();
				data.position = 0;
				out = XML(data.readUTFBytes(data.bytesAvailable));
			} else {
				out = XML(_urlLoader.data);
			}
			dispatchEvent(new DataEvent(LoaderAdapter.DATA_LOADED, false, false, 
				out));
			dispatchEvent(new Event(COMMAND_COMPLETED));	
		}
		
		/*=========================Protected methods==========================*/
		
		/**
         * @private
         */
		override protected function handleError(event:ErrorEvent):void {
			event.stopImmediatePropagation();
        	dispatchEvent(new ErrorEvent(COMMAND_ERROR, false, 
        		"Problem fetching data file " + _file + ": " + event.text));
        	event = null;	
        }        
	}
}