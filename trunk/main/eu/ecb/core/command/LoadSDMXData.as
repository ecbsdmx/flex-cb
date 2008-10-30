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
package eu.ecb.core.command
{
	import eu.ecb.core.event.ProgressEventMessage;
	import eu.ecb.core.event.XMLDataEvent;
	import eu.ecb.core.util.net.ILoader;
	import eu.ecb.core.util.net.LoaderAdapter;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.stores.xml.v2.compact.CompactReader;
	import org.sdmx.stores.xml.v2.structure.StructureReader;
	
	/**
	 * This command loads the data out of two SDMX-ML files: The Data Structure 
	 * Definition file (in SDMX-ML Structure format) and the data file 
	 * (in SDMX-ML Compact format).
	 * 
	 * @author Xavier Sosnovsky
	 * 
	 * @todo
	 * 		o Add possibility to handle other types of readers
	 * 		o Add possibility to supply different structure readers
	 */  
	public class LoadSDMXData extends CommandAdapter
	{
		/*==============================Fields================================*/
		
		/** The SDMX-ML v2.0 Compact format data file to be loaded */
		protected var _dataFile:String;
		
		/** The SDMX-ML v2.0 Structure file to be loaded */
		protected var _structureFile:String;
		
		/** The SDMX-ML data file being loaded */
		private var _loadedFile:String;
		
		/** The Reader for the SDMX-ML compact format */
		private var _compactReader:CompactReader;
		
		/** The key families extracted from the structure file */
		private var _keyFamilies:KeyFamilies;
		
		/** Whether or not observation-level attributes should be fetched */
		private var _disableObservationAttribute:Boolean;
		
		private var _seriesKeys:ArrayCollection;
		
		private var _fetchSelected:Boolean;
		
		private var _loadedStructureFiles:ArrayCollection;
		
		private var _loadedDataFile:ArrayCollection;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a command responsible for loading SDMX-ML data files.
		 *  
		 * @param dataFile The SDMX-ML data file to be loaded
		 * @param structureFile The SDMX-ML structure file to be loaded
		 * @param loader The SDMX loader responsible for loading the data file 
		 */
		public function LoadSDMXData(dataFile:String,
			structureFile:String, loader:ILoader) {
			super(loader);
			_dataFile = dataFile;
			_structureFile = structureFile;
			_loadedStructureFiles = new ArrayCollection();
			_loadedDataFile = new ArrayCollection();
			_receiver.addEventListener(LoaderAdapter.DATA_LOADED, 
				handleLoading);
			_receiver.addEventListener(LoaderAdapter.DATA_LOADING_ERROR, 
				handleLoadingError);
			_receiver.addEventListener(LoaderAdapter.DATA_LOADING_PROGRESS, 
				handleLoadingProgress);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The data file to be loaded. This is a convenience method so that the
		 * same command can load different SDMX data files whose data structure
		 * definitions are defined in the same SDMX structure file.
		 *  
		 * @param dataFile
		 */
		public function set dataFile(dataFile:String):void
		{
			_dataFile = dataFile;
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
		 * If an SDMX data file contains multiple series but only one or some 
		 * of them should be fetched, the list of series keys to be fetched can
		 * be set here.
		 *  
		 * @param seriesKeys
		 */
		public function set seriesKeys(seriesKeys:ArrayCollection):void
		{
			if (null != seriesKeys && seriesKeys.length > 0) {
				_seriesKeys = seriesKeys;
				_fetchSelected = true;
			} else {
				_fetchSelected =false;
			}
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function execute():void
		{
			if (_structureFile == _dataFile) {
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "The structure file and the data file are" + 
							"the same."));
			}
			
			if (_loadedStructureFiles.contains(_structureFile)) {
				if (_loadedDataFile.contains(_dataFile)) {
					_compactReader.cleanDataSet();
					if (_fetchSelected) {
						_compactReader.query(_seriesKeys.removeItemAt(0));	
					} else {
						_compactReader.query(null);
					}					
				} else {
					_loadedFile = _dataFile;
					(_receiver as ILoader).load(_dataFile, _loadedFile.
						indexOf(".zlib") > -1);
				}
			} else {
				_loadedFile = _structureFile;
				(_receiver as ILoader).load(_loadedFile, 
					_loadedFile.indexOf(".zlib") > -1);
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function handleLoading(event:XMLDataEvent):void {
			if (_loadedFile == _structureFile && !(_loadedStructureFiles.
				contains(_structureFile))) {
				prepareStructureFileLoading(event);
			} else if (_loadedFile == _dataFile) {	
				prepareDataFileLoading(event);
			}
		}
		
		private function prepareStructureFileLoading(event:XMLDataEvent):void {
			event.stopImmediatePropagation();
			var messageNS:Namespace = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
			var structureNS:Namespace = new Namespace("structure", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure");
				
			//Quick check to see that the XML data received is in an 
			//acceptable format (SDMX-ML Structure format).	
			var codeLists:XMLList = event.data.messageNS::CodeLists;
			if (!event.data.messageNS::CodeLists || 		
				!event.data.messageNS::CodeLists.structureNS::CodeList[0] ||
				((!event.data.messageNS::Concepts ||		
				!event.data.messageNS::Concepts.structureNS::Concept[0]) &&
				(!event.data.messageNS::ConceptSchemes || 		
				!event.data.messageNS::ConceptSchemes.structureNS::Concept[0])) 
				|| !event.data.messageNS::KeyFamilies || 		
				!event.data.messageNS::KeyFamilies.structureNS::KeyFamily[0]) {
					dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "The structure file '" + _loadedFile + 
					"' does not seem to be in a format that this application " + 
					"can handle"));
			} else {
				var reader:StructureReader 
					= new StructureReader();
				reader.addEventListener(StructureReader.KEY_FAMILIES_EVENT, 
					handleKeyFamilies);
				reader.dispatchKeyFamilies = true;
				reader.read(event.data);
			}
			event = null;
		}
		
		private function prepareDataFileLoading(event:XMLDataEvent):void {
			event.stopImmediatePropagation();
			var namespaces:Array = 
				(event.data.children()[1] as XML).inScopeNamespaces();
			var compactNS:Namespace;
			for (var i:uint = 0; i < namespaces.length; i++) {
				if (namespaces[i].prefix == "") {
					compactNS 
						= new Namespace("compact", String(namespaces[i].uri));
					event.data.addNamespace(compactNS);
					break;
				}
			}
			if (!event.data.compactNS::DataSet) {
				dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, "The data file '" + _loadedFile + "' " + 
					"does not seem to be in a format that this " +
					"application can handle"));
			} else {
				_loadedDataFile.addItem(_dataFile);
				_compactReader = new CompactReader(_keyFamilies);
				_compactReader.addEventListener(DataReaderAdapter.INIT_READY, 
					handleDataInitReady);
				_compactReader.disableObservationAttribute = 
					_disableObservationAttribute;
				_compactReader.dataFile = event.data;	
			}
			event = null;
		}
		
		private function handleKeyFamilies(event:SDMXDataEvent):void {
			event.stopImmediatePropagation();
			_keyFamilies = event.data as KeyFamilies;
			_loadedStructureFiles.addItem(_structureFile);
			_loadedFile = _dataFile;
			var compressed:Boolean = _loadedFile.indexOf(".zlib") > -1;
			(_receiver as ILoader).load(_dataFile, compressed);
			event = null;		
		}
		
		private function handleDataInitReady(event:Event):void {
			event.stopImmediatePropagation();
			event = null;
			_compactReader.addEventListener(DataReaderAdapter.DATASET_EVENT, 
				handleDataSet);
			if (_fetchSelected) {
				_compactReader.query(_seriesKeys.removeItemAt(0));	
			} else {
				_compactReader.query(null);
			}
		}		
		
		private function handleDataSet(event:SDMXDataEvent):void {
			event.stopImmediatePropagation();
			if (_fetchSelected && _seriesKeys.length > 0) {
				_compactReader.query(_seriesKeys.removeItemAt(0));
			} else {
				var dataSet:DataSet = event.data as DataSet;
				event = null;
				var containsData:Boolean = false;
				for each (var series:TimeseriesKey in dataSet.timeseriesKeys) {
					if (series.timePeriods.length > 0) {
						containsData = true;
						break;
					}
				}
				dispatchEvent(new SDMXDataEvent(dataSet, 
					CommandAdapter.COMMAND_COMPLETED));
			}	
		}
		
		private function handleLoadingError(event:ErrorEvent):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new ErrorEvent(CommandAdapter.COMMAND_ERROR, 
					false, false, event.text));
			event = null;		
		}
		
		private function handleLoadingProgress(event:ProgressEvent):void 
		{
			event.stopImmediatePropagation();
			var message:String = (_loadedFile == _structureFile) ? "Loading" + 
					" data structure definition" : "Loading data file";
			message = message + " (" + event.bytesLoaded + 
					" bytes out of " + event.bytesTotal + ")"; 
			dispatchEvent(new ProgressEventMessage(
				CommandAdapter.COMMAND_PROGRESS, false, false, 
				event.bytesLoaded, event.bytesTotal, message));
			event = null;	
		}
	}
}