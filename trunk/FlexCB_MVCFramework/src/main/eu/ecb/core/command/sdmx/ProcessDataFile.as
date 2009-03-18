// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.command.sdmx
{
	import eu.ecb.core.command.CommandAdapter;
	import eu.ecb.core.command.ICommand;
	import eu.ecb.core.event.XMLDataEvent;
	import eu.ecb.core.util.net.LoaderAdapter;
	import eu.ecb.core.util.net.XMLLoader;
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.stores.xml.v2.IDataReader;
	import org.sdmx.stores.xml.v2.compact.CompactReader;
	import org.sdmx.stores.xml.v2.utility.UtilityReader;

	/**
	 * Event dispatched when the XML file has been successfully fetched. It will 
	 * return the XML file.
	 * 
	 * @eventType eu.ecb.core.command.ProcessDataFile.DATA_FETCHED
	 */
	[Event(name="dataFetched", type="eu.ecb.core.event.XMLDataEvent")]
	
	/**
	 * Event dispatched when the data file has been successfully parsed
	 * and interpreted. It will return the data set.
	 * 
	 * @eventType eu.ecb.core.command.ProcessDataFile.DATA_PROCESSED
	 */
	[Event(name="dataProcessed", type="org.sdmx.event.SDMXDataEvent")]

	/**
	 * This command is responsible for fetching and interpreting SDMX-ML
	 * Data files.
	 *   
	 * @author Xavier Sosnovsky
	 */
	public class ProcessDataFile extends CommandAdapter
	{
		/*=============================Constants==============================*/
		
		/**
		 * The ProcessDataFile.DATA_FETCHED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>dataFetched</code> event.
		 * 
		 * @eventType dataFetched
		 */  
		public static const DATA_FETCHED:String = "dataFetched";
		
		/**
		 * The ProcessDataFile.DATA_PROCESSED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>dataProcessed</code> event.
		 * 
		 * @eventType dataProcessed
		 */  
		public static const DATA_PROCESSED:String = "dataProcessed";
		
		/*==============================Fields================================*/
		
		private var _url:URLRequest;
		
		private var _xml:XML;
		
		private var _loader:XMLLoader;
		
		private var _reader:IDataReader;
		
		private var _fetchData:Boolean;
		
		private var _newKeyFamily:Boolean; 
		
		private var _keyFamily:KeyFamily;
		
		private var _dataFormat:String;
		
		private var _disableObservationAttribute:Boolean;
		
		private var _optimisationLevel:uint;
		
		/*===========================Constructor==============================*/
		
		public function ProcessDataFile()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The data file to be fetched and interpreted.
		 *  
		 * @param dataFile
		 */
		public function set dataFile(dataFile:URLRequest):void
		{
			_fetchData = true;
			_url = dataFile;
		}
		
		/**
		 * The key family defining the structure of the data available in the
		 * data file.
		 *   
		 * @param kf
		 */
		public function set keyFamily(kf:KeyFamily):void
		{
			_newKeyFamily = true;
			_keyFamily = kf;
		}
		
		/**
		 * Whether or not observation-level attributes should be fetched. This
		 * can be set to false for performance reasons.
		 *  
		 * @param flag
		 */
		public function set disableObservationAttribute(flag:Boolean):void
		{
			_disableObservationAttribute = flag;
		}
		
		/**
		 * The optimisation level defines which optimisation settings will be 
		 * applied when reading data.
		 * 
		 * @param level
		 */
		public function set optimisationLevel(level:uint):void
		{
			_optimisationLevel = level;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			if (_fetchData) {
				fetchXML();
			} else if (_newKeyFamily && null != _keyFamily) {
				interpretData();
			} else {
				dispatchEvent(new Event(COMMAND_COMPLETED));
			}
		} 
		
		/*==========================Private methods===========================*/
		
		private function fetchXML():void
		{
			if (null == _loader) {
				_loader = new XMLLoader();
				addCommand("loadData", _loader, LoaderAdapter.DATA_LOADED, 
					handleDataLoaded);
			}
			_loader.file = _url;
			_loader.execute();
		}
		
		private function interpretData():void
		{
			_newKeyFamily = false;
			addCommand("guessDataFormat", new GuessDataType(_xml), 
				GuessDataType.TYPE_GUESSED, handleFormatGuessed);
			(_commands["guessDataFormat"] as ICommand).execute();
		}

		private function handleDataLoaded(event:XMLDataEvent):void
		{
			event.stopImmediatePropagation();
			_fetchData = false;
			_xml = event.data as XML;
			if (null != _keyFamily) {
				interpretData();
			} else {
				dispatchEvent(new Event(COMMAND_COMPLETED));
			}
			dispatchEvent(new XMLDataEvent(_xml, DATA_FETCHED));			
			event = null;
		}
		
		private function handleFormatGuessed(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			_dataFormat = event.data;
			if (_dataFormat == GuessDataType.SDMX_ML_Compact) {
				_reader = new CompactReader(_keyFamily);
			} else if (_dataFormat == GuessDataType.SDMX_ML_Utility) {
				_reader = new UtilityReader(_keyFamily);
			} else {
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, _dataFormat + " is currently not supported"));
			}
			_reader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			_reader.addEventListener(DataReaderAdapter.DATASET_EVENT, 
				handleDataSet);	
			_reader.disableObservationAttribute = _disableObservationAttribute;
			_reader.optimisationLevel = _optimisationLevel;	
			_reader.dataFile = _xml;
			event = null;
		}
		
		private function handleInitReady(event:Event):void 
		{
			event.stopImmediatePropagation();
			event = null;
			_reader.query(null);
		}
		
		private function handleDataSet(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(new SDMXDataEvent(event.data, DATA_PROCESSED));
			dispatchEvent(new Event(COMMAND_COMPLETED));
			event = null;
		}	
	}
}