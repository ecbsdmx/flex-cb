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
package eu.ecb.core.util.net
{
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Event dispatched when the data has been successfully loaded.
	 * 
	 * @eventType eu.ecb.core.util.net.LoaderAdapter.DATA_LOADED
	 */
	[Event(name="dataLoaded", type="flash.events.DataEvent")]
	
	/**
	 * Event dispatched when an error has been encountered when downloading 
	 * data.
	 * 
	 * @eventType eu.ecb.core.util.net.LoaderAdapter.DATA_LOADING_ERROR
	 */
	[Event(name="dataDownloadError", type="flash.events.ErrorEvent")]
	
	/**
	 * Event dispatched when the data is being downloaded.
	 * 
	 * @eventType eu.ecb.core.util.net.LoaderAdapter.DATA_LOADING_PROGRESS
	 */
	[Event(name="dataDownloadProgress", type="flash.events.ProgressEvent")]
	
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
	public class LoaderAdapter extends EventDispatcher implements ILoader
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
		
		/**
		 * The LoaderAdapter.DATA_LOADING_ERROR constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataLoadingError</code> event.
		 * 
		 * @eventType dataLoadingError
		 */   
		public static const DATA_LOADING_ERROR:String = "dataLoadingError";
		
		/**
		 * The LoaderAdapter.DATA_LOADING_PROGRESS constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataLoadingProgress</code> event.
		 * 
		 * @eventType dataLoadingProgress
		 */   
		public static const DATA_LOADING_PROGRESS:String = 
			"dataLoadingProgress";
			
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 			
		protected var _urlLoader:URLLoader;
		
		/**
		 * @private
		 */	
		protected var _filename:URLRequest;
		
		/**
		 * @private
		 */
		protected var _compressed:Boolean;
		
		/*===========================Constructor==============================*/	
			
		public function LoaderAdapter(target:IEventDispatcher = null)
		{
			super(target);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, handleData);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
				handleError);
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function load(filename:URLRequest, compressed:Boolean=true):void
		{
			_filename = filename;
			_compressed = compressed;
			_urlLoader.dataFormat = (compressed) ? URLLoaderDataFormat.BINARY: 
				URLLoaderDataFormat.TEXT;
			
			
			if (filename.data is URLRequest) {
				var fileVariables:URLVariables = filename.data as URLVariables;
				fileVariables.fid = Math.random() * 1000;
			}
			
			_urlLoader.load(filename);
			
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
		}
		
		/*=========================Protected methods==========================*/
		
		/**
         * @private
         */
		protected function handleError(event:ErrorEvent):void {
			event.stopImmediatePropagation();
        	dispatchEvent(new ErrorEvent(LoaderAdapter.DATA_LOADING_ERROR, 
        		false, false, "Problem fetching data file " + _filename + ": "
        		+ event.text));
        	event = null;	
        }
        
        /**
         * @private
         */ 
        protected function handleProgress(event:ProgressEvent):void {
        	event.stopImmediatePropagation();
        	dispatchEvent(new ProgressEvent(LoaderAdapter.DATA_LOADING_PROGRESS, 
        		false, false, event.bytesLoaded, event.bytesTotal));
        	event = null;	
        }
	}
}