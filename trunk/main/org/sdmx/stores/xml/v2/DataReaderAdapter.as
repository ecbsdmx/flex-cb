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
package org.sdmx.stores.xml.v2
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;

	/**
	 * Event triggered after a data file has been supplied. It shows that 
	 * all needed information is now available to the reader and that the
	 * data file can now be queried.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.DataReaderAdapter.INIT_READY
	 */
	[Event(name="initReady", type="flash.events.Event")]
	  
	/**
	 * Event triggered when the data file has been queried and the extracted
	 * data is returned.
	 * 
	 * @eventType org.sdmx.stores.xml.v2.DataReaderAdapter.DATASET_EVENT
	 */
	[Event(name="dataSetEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
	 * Default implementation of the DataReader interface
	 * 
	 * @author Xavier Sosnovsky
	 *
	 * @todo
	 * 		o Input validation?
	 * 		o Data provider info
	 * 		o DataFlow info
	 * 		o Action
	 * 		o Validity
	 * 		o Publication
	 */
	public class DataReaderAdapter extends EventDispatcher 
		implements IDataReader
	{
		/*=============================Constants==============================*/
		
		/**
		 * The DataReaderAdapter.INIT_READY constant defines the value of the 
		 * <code>type</code> property of the event object for a 
		 * <code>initReady</code> event.
		 * 
		 * @see #query()
		 * 
		 * @eventType initReady
		 */
		public static const INIT_READY:String = "initReady";
		
		/**
		 * The DataReaderAdapter.DATASET_EVENT constant defines the value of the 
		 * <code>type</code> property of the event object for a 
		 * <code>dataSetEvent</code> event.
		 * 
		 * @eventType dataSetEvent
		 */
		public static const DATASET_EVENT:String = "dataSetEvent";
		
		/*==============================Fields================================*/
		
		/**
		 * @private 
		 */
		protected var _disableObservationAttribute:Boolean;
		
		/**
		 * @private 
		 */
		protected var _data:XML;
		
		/**
		 * @private 
		 */
		protected var _keyFamilies:KeyFamilies;
		
		/**
		 * @private 
		 */
		protected var _dataSet:DataSet;
		
		/*============================Namespaces==============================*/
		
		/**
		 * @private 
		 */
		protected var messageNS:Namespace;
		
		/*===========================Constructor==============================*/
		
		public function DataReaderAdapter(target:IEventDispatcher = null)
		{
			super(target);
			messageNS = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
		}

		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set disableObservationAttribute(flag:Boolean):void
		{
			_disableObservationAttribute = flag;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get disableObservationAttribute():Boolean
		{
			return _disableObservationAttribute;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set dataFile(dataFile:XML):void
		{
			_data = dataFile;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get dataFile():XML
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set keyFamilies(keyFamilies:KeyFamilies):void
		{
			if (null == keyFamilies || 0 == keyFamilies.length) {
				throw new ArgumentError("The key families cannot be empty");
			}
			_keyFamilies = keyFamilies;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get keyFamilies():KeyFamilies
		{
			return _keyFamilies;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function cleanDataSet():void
		{
			if (null != _dataSet) {
				_dataSet.timeseriesKeys = new TimeseriesKeysCollection();
				_dataSet.groupKeys		= new GroupKeysCollection();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function query(query:Object=null):void
		{
			throw new Error("This method must be implemented by sub-classes");
		}
	}
}