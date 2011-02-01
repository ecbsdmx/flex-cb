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
package org.sdmx.stores.xml.v2
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.api.BaseDataProvider;
	import org.sdmx.stores.api.BaseSDMXDaoFactory;
	import org.sdmx.stores.api.SDMXQueryParameters;
	import org.sdmx.stores.xml.v2.compact.CompactReader;
	import org.sdmx.stores.xml.v2.generic.GenericReader;
	import org.sdmx.stores.xml.v2.utility.UtilityReader;

	/**
	 * Provides access to the data sets available in the supplied SDMX-ML
	 * Data file. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SDMXMLDataDao extends BaseDataProvider
	{		
		/*==============================Fields================================*/
		
		private var _dataXML:XML;
		private var _dataChanged:Boolean;
		private var _kf:KeyFamily;
		private var _format:String;
		private var _reader:IDataReader;
		private var _dataSet:DataSet;
		
		/*============================Constructor=============================*/
		
		public function SDMXMLDataDao(format:String = null)
		{
			super();
			_format = format;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The data file to be parsed and interpreted.
		 *  
		 * @param file The data file to be parsed and interpreted.
		 */
		public function set dataFile(file:XML):void
		{
			_dataXML = file;
			_dataChanged = true;
		}
		
		/*==========================Public methods============================*/

		override public function getData(params:SDMXQueryParameters=null):void
		{
			super.getData(params);
			if (_dataChanged) {
				var kf:KeyFamily = FindKeyFamily.find(_dataXML, _keyFamilies);
				if (null == kf) {
					dispatchEvent(new ErrorEvent(
						BaseSDMXDaoFactory.DAO_ERROR_EVENT, false, false, 
						"Could not find any suitable key family to interpret" + 
						" the supplied data"));
				}
				
				if (_format == null) {
					_format = GuessDataType.guessFormat(_dataXML);
					if (_format == null) {
						var element:XML = _dataXML.children()[1];
						if (element != null && 
							element.elements().length() > 0) {	
							dispatchEvent(new ErrorEvent(
								BaseSDMXDaoFactory.DAO_ERROR_EVENT, false, 
								false, _format + " is currently not " + 
										"supported"));
						} else {
							dispatchEvent(new SDMXDataEvent(null, 
								BaseSDMXDaoFactory.DATA_EVENT));
						}
					}
				}
				
				if (_format == SDMXDataFormats.SDMX_ML_COMPACT) {
					if (null == _reader || !(_reader is CompactReader) || 
						 kf != _kf) {
						_reader = new CompactReader(kf);
						setListeners();
					}
				} else if (_format == SDMXDataFormats.SDMX_ML_UTILITY) {
					if (null == _reader || !(_reader is UtilityReader) || 
						 kf != _kf) {
						_reader = new UtilityReader(kf);
						setListeners();
					}
				} else if (_format == SDMXDataFormats.SDMX_ML_GENERIC) {
					if (null == _reader || !(_reader is GenericReader) || 
						 kf != _kf) {
						_reader = new GenericReader(kf);
						setListeners();
					}
				}
				_kf = kf;
				_reader.disableObservationAttribute = 
					_disableObservationAttribute;
				_reader.disableAllAttributes = _disableAllAttributes;
				_reader.disableGroups = _extractGroups;
				_reader.optimisationLevel = _optimisationLevel;	
				_reader.disableObservationsCreation = 
					_disableObservationsCreation;
				_reader.dataFile = _dataXML;
			} else {
				dispatchResults();
			}
		}
		
		/*==========================Private methods===========================*/
		
		private function handleInitReady(event:Event):void 
		{
			event.stopImmediatePropagation();
			_reader.query(null);
			event = null;
		}
		
		private function handleDataSet(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			_dataSet = event.data as DataSet;
			dispatchResults();
			event = null;
		}	
		
		private function dispatchResults():void
		{
			if (null != _params) {
				throw new Error("Filtering data available in an SDMX-ML data" + 
					" file using parameters is currently not supported");
			} else {
				dispatchEvent(new SDMXDataEvent(_dataSet, 
					BaseSDMXDaoFactory.DATA_EVENT));
			}
		}
		
		private function setListeners():void
		{
			_reader.addEventListener(DataReaderAdapter.INIT_READY, 
				handleInitReady);
			_reader.addEventListener(DataReaderAdapter.DATASET_EVENT, 
				handleDataSet);	
		}
	}
}