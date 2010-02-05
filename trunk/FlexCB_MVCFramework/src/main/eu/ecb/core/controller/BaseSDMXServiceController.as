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
package eu.ecb.core.controller
{
	import eu.ecb.core.event.ProgressEventMessage;
	import eu.ecb.core.model.BaseSDMXServiceModel;
	import eu.ecb.core.model.ISDMXServiceModel;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.stores.api.BaseSDMXDaoFactory;
	import org.sdmx.stores.api.IDataProvider;
	import org.sdmx.stores.api.IMaintainableArtefactProvider;
	import org.sdmx.stores.api.ISDMXDaoFactory;
	import org.sdmx.stores.api.SDMXQueryParameters;
	import org.sdmx.stores.xml.v2.SDMXDataFormats;
	import org.sdmx.stores.xml.v2.SDMXMLDaoFactory;

	/**
	 * Base implementation of the ISDMXServiceController interface. 
	 * 
	 * The class will talk to the SDMX data provider (a component responsible 
	 * for communicating with an SDMX data source), and populate the model 
	 * accordingly when data is returned by the SDMX data provider.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class BaseSDMXServiceController extends BaseController implements 
		ISDMXServiceController
	{		
		/*==============================Fields================================*/
		
		//The SDMX DAO factories
		/**
		 * @private 
		 */ 
		protected var _dataProvidersFactory:ISDMXDaoFactory;
		
		/**
		 * @private 
		 */ 
		protected var _structureProvidersFactory:ISDMXDaoFactory
		
		//The SDMX data and metadata providers
		/**
         * The specialized metadata provider that will retrieve category schemes 
         */
        protected var _categorySchemeProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized metadata provider that will retrieve dataflow 
         * definitions 
         */
        protected var _dataflowProvider:IMaintainableArtefactProvider;
        
         /**
         * The specialized metadata provider that will retrieve hierarchical 
         * code schemes 
         */
        protected var _hierarchicalCodeSchemeProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized metadata provider that will retrieve key families
         */
        protected var _keyFamilyProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized data provider that will retrieve statitical data; 
         */
        protected var _dataProvider:IDataProvider;
        
        //The SDMX sources
        /**
		 * The source of the provider responsible for fetching metadata 
		 */
		protected var _structureURL:URLRequest;
		
		/**
		 * Whether or not the source of the provider responsible for fetching 
		 * metadata has been changed 
		 */ 
		protected var _structureToFetch:Boolean;
		
		/**
		 * The source of the provider responsible for fetching data 
		 */
		protected var _dataURL:URLRequest;
		
		/**
		 * Whether or not the source of the provider responsible for fetching 
		 * data has been changed 
		 */ 
		protected var _dataToFetch:Boolean;
		
        //Handling of dataflows        
        /**
         * The list of dataflows for which a key family needs to be fetched 
         */
        protected var _dataflowsWithNoKeyFamily:DataflowsCollection;
        
        /**
         * The list of all dataflows fetched 
         */
        protected var _fetchedDataflows:DataflowsCollection; 
        
        /**
		 * The object containing the parameters for dataflows queries. 
		 */
		protected var _dataflowsParams:Object;
        
		//Handling of category schemes		
		/**
		 * The object containing the parameters for category schemes queries. 
		 */
		protected var _categorySchemeParams:Object;
		
		//Handling of hierarchical code schemes		
		/**
		 * The object containing the parameters for hierarchical code schemes 
		 * queries. 
		 */
		protected var _hierarchicalCodeSchemeParams:Object;
		
		//Handling of key families
		/**
		 * The object containing the parameters for key family queries. 
		 */
		protected var _keyFamilyParams:Object;
		
		//Handling of data
		/**
		 * The object containing the parameters for dataflows queries. 
		 */
		protected var _dataParams:SDMXQueryParameters;
		
		/**
		 * The format of the supplied SDMX-ML data file. 
		 */
		protected var _dataFormat:String;
		
		/**
		 * @private 
		 */
		protected var _nrOfFilesToFetch:uint;
		
		/**
		 * @private 
		 */
		protected var _filesToFetch:ArrayCollection;
		
		/**
		 * @private
		 */ 
		protected var _totalNrOfFiles:uint;
		
		/**
		 * @private 
		 */
		protected var _tmpDataSet:DataSet;
		
		/**
		 * @private 
		 */
		protected var _pendingRequests:ArrayCollection; 
		
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a new instance of a base SDMX service controller.
		 *  
		 * @param model The model that will be populated with data returned by
		 * the SDMX data providers.
		 * @param dataFactory The factory that will manage access to the 
		 * specialized SDMX data providers responsible for fetching SDMX-ML data
		 * @param structureFactory The factory that will manage access to the 
		 * specialized SDMX data providers responsible for fetching SDMX-ML 
		 * structural metadata. 
		 */
		public function BaseSDMXServiceController(
			model:ISDMXServiceModel, 
			dataFactory:ISDMXDaoFactory = null, 
			structureFactory:ISDMXDaoFactory = null)
		{
			super(model);
			dataProvidersFactory = dataFactory;
			structureProvidersFactory = structureFactory;	
			_nrOfFilesToFetch = 0;
			_pendingRequests = new ArrayCollection();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataProvidersFactory(factory:ISDMXDaoFactory):void
		{
			_dataProvidersFactory = 
				(null == factory) ? new SDMXMLDaoFactory() : factory;
			_dataProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.DAO_ERROR_EVENT, handleError);	
		}
		
		/**
		 * @inheritDoc
		 */
		public function get dataProvidersFactory():ISDMXDaoFactory
		{
			return _dataProvidersFactory;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set structureProvidersFactory(
			factory:ISDMXDaoFactory):void
		{
			if (null != factory) {
				_structureProvidersFactory = factory;
			} else {
				_structureProvidersFactory = dataProvidersFactory;
			}
			_structureProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.DAO_ERROR_EVENT, handleError);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get structureProvidersFactory():ISDMXDaoFactory
		{
			return _structureProvidersFactory;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataSource(dataSource:URLRequest):void
		{
			_dataToFetch = true;
			_dataURL = dataSource;
			_dataProvider = null;
		}
		
		/**
		 * @inheritDoc
		 */  
		public function get dataSource():URLRequest
		{
			return _dataURL;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set structureSource(structureSource:URLRequest):void
		{
			_structureToFetch = true;
			_structureURL = structureSource;
			_categorySchemeProvider = null;
			_dataflowProvider = null;
			_keyFamilyProvider = null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get structureSource():URLRequest
		{
			return _structureURL;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataSet(ds:DataSet):void
		{
			(model as ISDMXServiceModel).dataSet = ds;		
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchCategoryScheme(categorySchemeID:String = null, 
			agencyID:String = null, version:String = null):void
		{
			_categorySchemeParams = 
				{id: categorySchemeID, agency: agencyID, version: version};
			var request:Object = new Object();
			request["type"] = "categorySchemeQuery";
			if (_structureToFetch) {
				request["method"] = prepareStructureProvider;
			} else {
				request["method"] = performCategorySchemeRequest;
			}
			_pendingRequests.addItem(request);
			if (_pendingRequests.length == 1) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchDataflowDefinition(dataflowID:String = null, 
			agencyID:String = null, version:String = null):void
		{
			_dataflowsParams = 
				{id: dataflowID, agency: agencyID, version: version};
			
			var request:Object = new Object();
			request["type"] = "dataflowQuery";
			if (_structureToFetch) {
				request["method"] = prepareStructureProvider;
			} else if (null != dataflowID && null != (_model as 
				ISDMXServiceModel).allDataflowDefinitions && null != (_model as 
				ISDMXServiceModel).allDataflowDefinitions.getDataflowById(
				dataflowID, agencyID, version)) {
				//If we have it and we do not need to load another structure 
				//file, we set it as the last dataflow for the model, so as to 
				//trigger updates of the view
				var collection:DataflowsCollection = new DataflowsCollection();
				collection.addItem((_model as 
					ISDMXServiceModel).allDataflowDefinitions.getDataflowById(
					dataflowID, agencyID, version));
				(_model as ISDMXServiceModel).dataflowDefinitions = collection;
			} else {
				request["method"] = performDataflowRequest;
			}
			_pendingRequests.addItem(request);
			if (_pendingRequests.length == 1) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchHierarchicalCodeScheme(schemeID:String = null, 
			agencyID:String = null, version:String = null):void
		{
			_hierarchicalCodeSchemeParams = 
				{id: schemeID, agency: agencyID, version: version};
			var request:Object = new Object();
			request["type"] = "hierarchicalCodeSchemeQuery";
			if (_structureToFetch) {
				request["method"] = prepareStructureProvider;
			} else {
				request["method"] = performHierarchicalCodeSchemeRequest;
			}
			_pendingRequests.addItem(request);
			if (_pendingRequests.length == 1) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}
		}	 
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchKeyFamily(keyFamilyID:String = null, 
			agencyID:String = null, version:String = null):void
		{
			_keyFamilyParams = 
				{id: keyFamilyID, agency: agencyID, version: version};
			var request:Object = new Object();
			request["type"] = "keyFamilyQuery";
			if (_structureToFetch) {
				request["method"] = prepareStructureProvider;
			} else {
				request["method"] = performKeyFamilyRequest;
			}
			_pendingRequests.addItem(request);
			if (_pendingRequests.length == 1) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchData(criteria:SDMXQueryParameters = null, 
			format:String = null):void
		{
			_dataParams = criteria;
			_dataFormat = format;
			
			var request:Object = new Object();
			request["type"] = "dataQuery";
			var dataRequest:Object;
			if (_structureToFetch == true) {
				_keyFamilyParams = {id: null, agency: null, version: null};
				request["type"] = "keyFamilyQuery";
				request["method"] = prepareStructureProvider;
				
				dataRequest = new Object();
				dataRequest["type"] = "dataQuery";
				dataRequest["method"] = prepareDataProvider;
			} else if (_dataToFetch) {
				request["method"] = prepareDataProvider;
			} else {
				if (null != _tmpDataSet && (null == _filesToFetch || 
					_filesToFetch.length == 0)) {
					_tmpDataSet.timeseriesKeys = null;
					_tmpDataSet.groupKeys = null;
					_tmpDataSet.attributeValues = null;
				}
				request["method"] = performDataRequest;
			}
			_pendingRequests.addItem(request);
			if (null != dataRequest) {
				_pendingRequests.addItem(dataRequest);
			}
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fetchDataFiles(files:ArrayCollection):void
		{
			dispatchEvent(new Event(TASK_STARTED));
			var isFetching:Boolean = false;
			if (null != _filesToFetch && _filesToFetch.length > 0) {
				isFetching = true;
				for each (var file:URLRequest in files) {
					_filesToFetch.addItem(file);
				}
				_nrOfFilesToFetch = _filesToFetch.length + 1;
				_totalNrOfFiles = _filesToFetch.length + 1;
			} else {
				_filesToFetch = files;
				_nrOfFilesToFetch = _filesToFetch.length;
				_totalNrOfFiles = _filesToFetch.length;
			}
			if (null != _tmpDataSet && !isFetching) {
				_tmpDataSet.timeseriesKeys = null;
				_tmpDataSet.groupKeys = null;
				_tmpDataSet.attributeValues = null;
			}
			
			if (!isFetching) {
				this.dataSource = _filesToFetch.removeItemAt(0) as URLRequest;
				dispatchEvent(new ProgressEventMessage(TASK_PROGRESS, false, 
					false, 0, 0, "Please wait: Loading data (" + 
					Math.round( (1 /_totalNrOfFiles) * 100) + "%)"));
				fetchData();
			}	
		}
		
		/*==========================Protected methods=========================*/
		
		/**
		 * Handles the reception of the category scheme returned by the data
		 * provider, following a request to fetch a category scheme.
		 *  
		 * @param event The event containing the category scheme
		 */
		protected function handleCategoryScheme(event:SDMXDataEvent):void 
		{
			(_model as BaseSDMXServiceModel).categorySchemes = 
				event.data as CategorieSchemesCollection;
			_pendingRequests.removeItemAt(0);
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}	
			event.stopImmediatePropagation();
			event = null;
		}
		
		/**
		 * Handles the reception of the dataflow definition returned by the data
		 * provider, following a request to fetch a dataflow definition.
		 *  
		 * @param event The event containing the dataflow definition
		 */
		protected function handleDataflowDefinition(event:SDMXDataEvent):void
		{
			//Upon reception of the dataflows, we first need to check whether
			//we have a full key family, or just a reference to a key family in 
			//each one of them.
			var dataflowsWithKF:DataflowsCollection = new DataflowsCollection();
			for each (var dataflow:DataflowDefinition in event.data) {
				if (null == (dataflow.structure as KeyFamily).keyDescriptor) {
					if (null == _dataflowsWithNoKeyFamily) {
						_dataflowsWithNoKeyFamily = new DataflowsCollection();
					}
					_dataflowsWithNoKeyFamily.addItem(dataflow);
				} else {
					dataflowsWithKF.addItem(dataflow);
				}
			}
			
			if (dataflowsWithKF.length > 0) {
				(_model as BaseSDMXServiceModel).dataflowDefinitions = 
					dataflowsWithKF;
			}
			_pendingRequests.removeItemAt(0);
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}	
			
			//If there as some dataflows with only reference to a key family, we
			//need to fetch the full key family definition.
			for each (var refDataflow:DataflowDefinition in 
				_dataflowsWithNoKeyFamily) {
				fetchKeyFamily(refDataflow.structure.id, refDataflow.structure.
					maintainer.id, refDataflow.structure.version);	
			}
		}
		
		/**
		 * Handles the reception of the hierarchical code schemes returned by 
		 * the data provider, following a request to fetch a hierarchical code 
		 * scheme.
		 *  
		 * @param event The event containing the hierarchical code scheme
		 */
		protected function handleHierarchicalCodeScheme(
			event:SDMXDataEvent):void 
		{
			(_model as BaseSDMXServiceModel).hierarchicalCodeSchemes = 
				event.data as HierarchicalCodeSchemesCollection;
			_pendingRequests.removeItemAt(0);
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}		
			event.stopImmediatePropagation();
			event = null;
		}
		
		/**
		 * Handles the reception of the key family returned by the data
		 * provider, following a request to fetch a key family.
		 * 
		 * @param event The event containing the key family
		 */
		protected function handleKeyFamily(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			(_model as BaseSDMXServiceModel).keyFamilies = 
				event.data as KeyFamilies;
			
			var foundDataflows:DataflowsCollection = new DataflowsCollection();
			if (null != _dataflowsWithNoKeyFamily) {
				var tmpColl:ArrayCollection = new ArrayCollection(
					_dataflowsWithNoKeyFamily.toArray().concat());
				for each (var refDataflow:DataflowDefinition in 
					tmpColl) {
					var kf:KeyFamily = (event.data as KeyFamilies).
						getKeyFamilyByID(refDataflow.structure.id, refDataflow.
						structure.maintainer.id, refDataflow.structure.version);	
					if (null != kf)	{ 
						refDataflow.structure = kf;
						foundDataflows.addItem(refDataflow);
						_dataflowsWithNoKeyFamily.removeItemAt(
							_dataflowsWithNoKeyFamily.getItemIndex(refDataflow));
					}
				}
			}
			(_model as BaseSDMXServiceModel).dataflowDefinitions = 
				foundDataflows;
			event = null;			
			
			//It might be that the call to fetch key families was triggered
			//by the fetchData method. In which case, we now need to execute 
			//that method.  
			_pendingRequests.removeItemAt(0);
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}	
		}
		
		/**
		 * Handles the reception of statistical data.
		 * 
		 * @param event The event containing the statistical data
		 */
		protected function handleData(event:SDMXDataEvent):void
		{
			if (_nrOfFilesToFetch > 0) {
				_nrOfFilesToFetch--;
			}
			if (null == _tmpDataSet) {
				_tmpDataSet = event.data as DataSet;
			} else {
				if (null == _tmpDataSet.timeseriesKeys) {
					_tmpDataSet.timeseriesKeys = new TimeseriesKeysCollection();
				}
				for each (var s:TimeseriesKey in (event.data as 
					DataSet).timeseriesKeys) {		            
					_tmpDataSet.timeseriesKeys.addItem(s);
				}
			
				if (null == _tmpDataSet.groupKeys) {
					_tmpDataSet.groupKeys = new GroupKeysCollection();
				}
				for each (var group:GroupKey in (event.data as 
					DataSet).groupKeys) {
					_tmpDataSet.groupKeys.addItem(group);
				}
			}
			if (0 == _nrOfFilesToFetch) {
				dispatchEvent(new Event(TASK_COMPLETED));
				this.dataSet = _tmpDataSet;
			} else {
				dispatchEvent(new ProgressEventMessage(TASK_PROGRESS, false, 
					false, _totalNrOfFiles - _filesToFetch.length + 1, 
					_totalNrOfFiles, "Please wait: Loading data (" + 
					Math.round(((_totalNrOfFiles -	_filesToFetch.length + 1) /
						_totalNrOfFiles) * 100) + "%)"));
				this.dataSource = _filesToFetch.removeItemAt(0) as URLRequest;
				fetchData();
			}
			event.stopImmediatePropagation();
			event = null;
			_pendingRequests.removeItemAt(0);
			if (_pendingRequests.length > 0) {
				(_pendingRequests.getItemAt(0)["method"] 
					as Function).call(this);
			}	
		}
		
		/**
		 * Handles the notification from the SDMX DAO factory that the SDMX
		 * provider for structural metadata is ready to be used.
		 *  
		 * @param event
		 */
		protected function handleStructureFactoryReady(event:Event):void
		{
			event.stopImmediatePropagation();
			event = null;
			_structureProvidersFactory.removeEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleStructureFactoryReady);
			_structureToFetch = false;	
			if (_pendingRequests.length > 0) { 
				var type:String = _pendingRequests.getItemAt(0)["type"];
				switch (type) {
					case "categorySchemeQuery":
						_categorySchemeProvider = createStructureProvider(
							"CategoryScheme", 
							BaseSDMXDaoFactory.CATEGORY_SCHEMES_EVENT, 
							handleCategoryScheme); 
						performCategorySchemeRequest();
						break;
					case "dataflowQuery":
						_dataflowProvider = createStructureProvider("Dataflow", 
							BaseSDMXDaoFactory.DATAFLOWS_EVENT,	
							handleDataflowDefinition);
						performDataflowRequest();
						break;
					case "keyFamilyQuery":
						_keyFamilyProvider = createStructureProvider(
							"KeyFamily", BaseSDMXDaoFactory.KEY_FAMILIES_EVENT, 
							handleKeyFamily);
						performKeyFamilyRequest();
						break;		
					case "hierarchicalCodeSchemeQuery":
						_hierarchicalCodeSchemeProvider = 
							createStructureProvider("HierarchicalCodeScheme", 
							BaseSDMXDaoFactory.HIERARCHICAL_CODE_SCHEMES_EVENT, 
							handleHierarchicalCodeScheme);
						performHierarchicalCodeSchemeRequest();
						break;
				}
			}
		}
		
		/**
		 * Prepares the SDMX provider for structural metadata to be used by the 
		 * controller.  
		 */
		protected function prepareStructureProvider():void
		{
			_structureProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleStructureFactoryReady);
			_structureProvidersFactory.sourceURL = _structureURL;	
		}
		
		/**
		 * Instructs the SDMX provider for structural metadata to retrieve 
		 * category schemes from the SDMX source. 
		 */
		protected function performCategorySchemeRequest():void {
			if (null == _categorySchemeProvider) {
				_categorySchemeProvider = createStructureProvider(
					"CategoryScheme", BaseSDMXDaoFactory.CATEGORY_SCHEMES_EVENT, 
					handleCategoryScheme); 
			}
			_categorySchemeProvider.getMaintainableArtefact(
				_categorySchemeParams["id"], _categorySchemeParams["agency"], 
				_categorySchemeParams["version"]);	
		}
		
		/**
		 * Instructs the SDMX provider for structural metadata to retrieve 
		 * dataflow definitions from the SDMX source. 
		 */
		protected function performDataflowRequest():void {
			if (null == _dataflowProvider) {
				_dataflowProvider = createStructureProvider("Dataflow", 
					BaseSDMXDaoFactory.DATAFLOWS_EVENT,	
					handleDataflowDefinition);
			}
			_dataflowProvider.getMaintainableArtefact(
				_dataflowsParams["id"], _dataflowsParams["agency"], 
				_dataflowsParams["version"]);	
		}
		
		/**
		 * Instructs the SDMX provider for structural metadata to retrieve 
		 * hierarchical code schemes from the SDMX source. 
		 */
		protected function performHierarchicalCodeSchemeRequest():void {
			if (null == _hierarchicalCodeSchemeProvider) {
				_hierarchicalCodeSchemeProvider = 
					createStructureProvider("HierarchicalCodeScheme", 
						BaseSDMXDaoFactory.HIERARCHICAL_CODE_SCHEMES_EVENT,	
						handleHierarchicalCodeScheme);
			}
			_hierarchicalCodeSchemeProvider.getMaintainableArtefact(
				_hierarchicalCodeSchemeParams["id"], 
				_hierarchicalCodeSchemeParams["agency"], 
				_hierarchicalCodeSchemeParams["version"]);	
		}
		
		/**
		 * Instructs the SDMX provider for structural metadata to retrieve 
		 * data structure definitions from the SDMX source. 
		 */
		protected function performKeyFamilyRequest():void {
			if (null == _keyFamilyProvider) {
				_keyFamilyProvider = createStructureProvider("KeyFamily", 
					BaseSDMXDaoFactory.KEY_FAMILIES_EVENT, handleKeyFamily);
			}
			_keyFamilyProvider.getMaintainableArtefact(
				_keyFamilyParams["id"], _keyFamilyParams["agency"], 
				_keyFamilyParams["version"]);	
		}
		
		/**
		 * Handles the notification from the SDMX DAO factory that the SDMX
		 * provider for data is ready to be used.
		 *  
		 * @param event
		 */
		protected function handleDataFactoryReady(event:Event):void
		{
			event.stopImmediatePropagation();
			event = null;
			_dataToFetch = false;
			performDataRequest();				
		}
		
		/**
		 * Prepares the SDMX provider for data to be used by the controller.  
		 */
		protected function prepareDataProvider():void
		{
			_dataProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleDataFactoryReady);
			_dataProvidersFactory.sourceURL = _dataURL;	
		}
		
		/**
		 * Instructs the SDMX provider for data to retrieve data from the SDMX 
		 * source. 
		 */
		protected function performDataRequest():void {
			if (null == _dataProvider) {
				_dataProvider = createDataProvider();
			}
			if (null != _dataParams) {
				var dataflow:DataflowDefinition = (_model as ISDMXServiceModel).
					allDataflowDefinitions.getDataflowById(
					_dataParams.dataflow.id, null, null);
				if (null == dataflow) {
					throw new Error("Could not find dataflow with id: " + 
						_dataParams.dataflow.id);
				}	
				var collection:KeyFamilies = new KeyFamilies();
				collection.addItem(dataflow.structure);	
				_dataProvider.keyFamilies = collection;
			} else {		
				_dataProvider.keyFamilies = 
					(_model as ISDMXServiceModel).allKeyFamilies;
			}
			_dataProvider.addEventListener(BaseSDMXDaoFactory.DATA_EVENT, 
				handleData);
			_dataProvider.addEventListener(BaseSDMXDaoFactory.DAO_ERROR_EVENT, 
				handleError);
			_dataProvider.getData(_dataParams);
		}
		
		/*==========================Private methods===========================*/
		
		private function createStructureProvider(type:String, event:String, 
			method:Function):IMaintainableArtefactProvider
		{
			var provider:IMaintainableArtefactProvider;
			if ("KeyFamily" == type) {
				provider = _structureProvidersFactory.getKeyFamilyDAO();
			} else if ("Dataflow" == type) {
				provider = _structureProvidersFactory.getDataflowDAO();
			} else if ("CategoryScheme" == type) {
				provider = _structureProvidersFactory.getCategorySchemeDAO();
			} else if ("HierarchicalCodeScheme" == type) {
				provider = 
					_structureProvidersFactory.getHierarchicalCodeSchemeDAO();
			}
			if (null == provider) {
				throw new Error("Not implemented");
			}
			provider.addEventListener(event, method);
			provider.addEventListener(BaseSDMXDaoFactory.DAO_ERROR_EVENT, 
				handleError);
			return provider;
		}	 
		
		private function createDataProvider():IDataProvider
		{
			var provider:IDataProvider;
			if (null != _dataFormat) {
				switch (_dataFormat) {
					case SDMXDataFormats.SDMX_ML_COMPACT: 
						provider = _dataProvidersFactory.getCompactDataDAO();
						break;
					case SDMXDataFormats.SDMX_ML_GENERIC:
						provider = _dataProvidersFactory.getGenericDataDAO()
						break;
					case SDMXDataFormats.SDMX_ML_UTILITY: 
						provider = _dataProvidersFactory.getUtilityDataDAO();
						break;
					default: 
						throw new Error("Unknown format: " + _dataFormat);
						break;										
				}
			} else {
				provider = _dataProvidersFactory.getDataDAO();
			}
			return provider;
		}
	}
}