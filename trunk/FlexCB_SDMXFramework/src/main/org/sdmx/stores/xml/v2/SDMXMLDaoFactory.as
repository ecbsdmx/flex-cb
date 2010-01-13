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
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.sdmx.event.XMLDataEvent;
	import org.sdmx.stores.api.BaseSDMXDaoFactory;
	import org.sdmx.stores.api.IDataProvider;
	import org.sdmx.stores.api.IMaintainableArtefactProvider;
	import org.sdmx.stores.xml.v2.structure.SDMXMLKeyFamilyDao;
	import org.sdmx.stores.xml.v2.structure.hierarchy.SDMXMLHierarchicalCodeSchemeDao;
	import org.sdmx.util.net.LoaderAdapter;
	import org.sdmx.util.net.XMLLoader;

	/**
	 * Manages access to the various specialized data providers that will 
	 * retrieve SDMX data and metadata from SDMX-ML data files.  
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SDMXMLDaoFactory extends BaseSDMXDaoFactory
	{
		/*==============================Fields================================*/
		
		private var _loader:XMLLoader;
		
		private var _sourceFile:XML;
		
		/*===========================Constructor==============================*/
		
		public function SDMXMLDaoFactory()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		override public function set sourceURL(url:URLRequest):void
		{
			_sourceURL = url;
			if (null == _loader) {
				_loader = new XMLLoader();
				_loader.addEventListener(LoaderAdapter.DATA_LOADED, 
					handleDataLoaded);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);	
			}
			_loader.file = _sourceURL;
			_loader.execute();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function getKeyFamilyDAO():IMaintainableArtefactProvider
		{
			var dao:SDMXMLKeyFamilyDao = new SDMXMLKeyFamilyDao();
			try {
				dao.structureFile = _sourceFile;
			} catch (error:ArgumentError){
				dispatchEvent(new ErrorEvent(BaseSDMXDaoFactory.DAO_ERROR_EVENT,
					false, false, error.message));
			}
			return dao;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getHierarchicalCodeSchemeDAO():
			IMaintainableArtefactProvider
		{
			var dao:SDMXMLHierarchicalCodeSchemeDao = 
				new SDMXMLHierarchicalCodeSchemeDao();
			try {
				dao.structureFile = _sourceFile;
			} catch (error:ArgumentError){
				dispatchEvent(new ErrorEvent(BaseSDMXDaoFactory.DAO_ERROR_EVENT,
					false, false, error.message));
			}
			return dao;
		}	
		
		/**
		 * @inheritDoc
		 */ 
		override public function getDataDAO():IDataProvider
		{
			return getDAO();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function getCompactDataDAO():IDataProvider
		{
			return getDAO();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function getGenericDataDAO():IDataProvider
		{
			return getDAO();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function getUtilityDataDAO():IDataProvider
		{
			return getDAO();
		}
		
		/*==========================Private methods===========================*/
		
		private function handleDataLoaded(event:XMLDataEvent):void
		{
			event.stopImmediatePropagation();
			_sourceFile = event.data as XML;
			event = null;
			dispatchEvent(new Event(BaseSDMXDaoFactory.INIT_READY));
		}
		
		private function handleError(event:IOErrorEvent):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new ErrorEvent(BaseSDMXDaoFactory.DAO_ERROR_EVENT, 
					false, false, event.text));
			event = null;		
		}
		
		private function getDAO():IDataProvider
		{
			var dao:SDMXMLDataDao = new SDMXMLDataDao();
			dao.dataFile = _sourceFile;
			dao.disableObservationAttribute = _disableObservationAttribute;
			dao.optimisationLevel = _optimisationLevel;
			return dao;
		}
	}
}