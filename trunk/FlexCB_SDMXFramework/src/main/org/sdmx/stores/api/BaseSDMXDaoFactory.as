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
package org.sdmx.stores.api
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
 	 * Event triggered when category schemes have been retrieved from the data
 	 * source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.CATEGORY_SCHEMES_EVENT
 	 */
	[Event(name="categorySchemesEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when dataflows have been retrieved from the data source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.DATAFLOWS_EVENT
 	 */
	[Event(name="dataflowsEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when concept schemes have been retrieved from the data 
 	 * source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.CONCEPT_SCHEMES_EVENT
 	 */
	[Event(name="conceptSchemesEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when code lists have been retrieved from the data source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.CODE_LISTS_EVENT
 	 */
	[Event(name="codeListsEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when organisation schemes have been retrieved from the 
 	 * data source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.ORGANISATION_SCHEMES_EVENT
 	 */
	[Event(name="organisationSchemesEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when key families have been retrieved from the data 
 	 * source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.KEY_FAMILIES_EVENT
 	 */
	[Event(name="keyFamiliesEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when data have been retrieved from the data source.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.DATA_EVENT
 	 */
	[Event(name="dataEvent", type="org.sdmx.event.SDMXDataEvent")]
	
	/**
 	 * Event triggered when the factory is ready to be used
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.INIT_READY
 	 */
	[Event(name="initReady", type="flash.events.Event")]
	
	/**
 	 * Event triggered when an error is thrown by a data provider.
 	 * 
 	 * @eventType org.sdmx.stores.api.BaseSDMXDaoFactory.DAO_ERROR_EVENT
 	 */
	[Event(name="daoErrorEvent", type="flash.events.ErrorEvent")]
	
	/**
	 * Base implementation of the ISDMXDaoFactory interface. It's just supplied
	 * so that events can be defined, which will be shared by all subclasses. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class BaseSDMXDaoFactory extends EventDispatcher 
		implements ISDMXDaoFactory
	{
		
		/*=============================Constants==============================*/
		
		/**
		 * The BaseSDMXDaoFactory.CATEGORY_SCHEMES_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>categorySchemesEvent</code> event.
		 * 
		 * @eventType categorySchemesEvent
		 */
		public static const CATEGORY_SCHEMES_EVENT:String = 
			"categorySchemesEvent";
			
		/**
		 * The BaseSDMXDaoFactory.DATAFLOWS_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataflowsEvent</code> event.
		 * 
		 * @eventType dataflowsEvent
		 */
		public static const DATAFLOWS_EVENT:String = 
			"dataflowsEvent";
			
		/**
		 * The BaseSDMXDaoFactory.CONCEPT_SCHEMES_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>conceptSchemesEvent</code> event.
		 * 
		 * @eventType conceptSchemesEvent
		 */
		public static const CONCEPT_SCHEMES_EVENT:String = 
			"conceptSchemesEvent";
			
		/**
		 * The BaseSDMXDaoFactory.CODE_LISTS_EVENT constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>codeListsEvent</code> event.
		 * 
		 * @eventType codeListsEvent
		 */
		public static const CODE_LISTS_EVENT:String = 
			"codeListsEvent";
			
		/**
		 * The BaseSDMXDaoFactory.ORGANISATION_SCHEMES_EVENT constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>organisationSchemesEvent</code> event.
		 * 
		 * @eventType organisationSchemesEvent
		 */
		public static const ORGANISATION_SCHEMES_EVENT:String = 
			"organisationSchemesEvent";			
			
		/**
		 * The BaseSDMXDaoFactory.KEY_FAMILIES_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>keyFamiliesEvent</code> event.
		 * 
		 * @eventType keyFamiliesEvent
		 */
		public static const KEY_FAMILIES_EVENT:String = 
			"keyFamiliesEvent";	
			
		/**
		 * The BaseSDMXDaoFactory.DATA_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>dataEvent</code> event.
		 * 
		 * @eventType dataEvent
		 */
		public static const DATA_EVENT:String = 
			"dataEvent";	
			
		/**
		 * The BaseSDMXDaoFactory.INIT_READY constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>initReady</code> event.
		 * 
		 * @eventType initReady
		 */	
		public static const INIT_READY:String = "initReady";	
		
		/**
		 * The BaseSDMXDaoFactory.DAO_ERROR_EVENT constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>daoErrorEvent</code> event.
		 * 
		 * @eventType daoErrorEvent
		 */	
		public static const DAO_ERROR_EVENT:String = "daoErrorEvent";
		
		/*==============================Fields================================*/
		
		protected var _sourceURL:URLRequest;
		
		/*===========================Constructor==============================*/
		
		public function BaseSDMXDaoFactory()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		public function set sourceURL(url:URLRequest):void
		{
			_sourceURL = url;
		}

		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function getCategorySchemeDAO():IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getDataflowDAO():IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getConceptSchemeDAO():IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCodeListDAO():IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getOrganisationSchemeDAO():
			IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getKeyFamilyDAO():IMaintainableArtefactProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getDataDAO():IDataProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getCompactDataDAO():IDataProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getGenericDataDAO():IDataProvider
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getUtilityDataDAO():IDataProvider
		{
			return null;
		}
	}
}