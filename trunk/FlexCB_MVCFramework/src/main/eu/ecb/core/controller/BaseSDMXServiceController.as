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
	import eu.ecb.core.model.BaseSDMXServiceModel;
	import eu.ecb.core.model.ISDMXServiceModel;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
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
	public class BaseSDMXServiceController extends ControllerAdapter implements 
		ISDMXServiceController
	{		
		/*==============================Fields================================*/
		
		/**
		 * The factory that will return the SDMX data providers to be used by 
		 * the controller when fetching SDMX-ML data.
		 */ 
		protected var _dataProvidersFactory:ISDMXDaoFactory;
		
		/**
		 * The factory that will return the SDMX data providers to be used by 
		 * the controller when fetching SDMX-ML structural metadata. It can be
		 * the same as the dataProvidersFactory, if the factory is able to 
		 * handle both SDMX-ML data and SDMX-ML structure queries.
		 */ 
		protected var _structureProvidersFactory:ISDMXDaoFactory
		
		/**
         * The specialized data provider that will retrieve category schemes 
         */
        protected var _categorySchemeProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized data provider that will retrieve dataflow definitions 
         */
        protected var _dataflowProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized data provider that will retrieve key families
         */
        protected var _keyFamilyProvider:IMaintainableArtefactProvider;
        
        /**
         * The specialized data provider that will retrieve statitical data; 
         */
        protected var _dataProvider:IDataProvider;
        
        /**
         * The list of dataflows for which a key family needs to be fetched 
         */
        protected var _dataflowsWithNoKeyFamily:DataflowsCollection;
        
        /**
         * The list of all dataflows fetched 
         */
        protected var _fetchedDataflows:DataflowsCollection; 
        
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
		
		/**
		 * Whether or not observation-level attributes should be fetched. This
		 * can be set to false for performance reasons.
		 */ 		
		protected var _disableObservationAttribute:Boolean;
		
		/**
		 * The optimisation level defines which optimisation settings will be 
		 * applied when reading data.
		 */
		protected var _optimisationLevel:uint;
		
		/**
		 * The object containing the parameters for category schemes queries. 
		 */
		protected var _categorySchemeParams:Object;
		
		/**
		 * Whether or not the current query to be peformed is a category scheme
		 * query. 
		 */
		protected var _isCategorySchemeQuery:Boolean;
		
		/**
		 * The object containing the parameters for dataflows queries. 
		 */
		protected var _dataflowsParams:Object;
		
		/**
		 * Whether or not the current query to be peformed is a dataflow query. 
		 */
		protected var _isDataflowQuery:Boolean;
		
		/**
		 * The object containing the parameters for key family queries. 
		 */
		protected var _keyFamilyParams:Object;
		
		/**
		 * Whether or not the current query to be peformed is a dataflow query. 
		 */
		protected var _isKeyFamilyQuery:Boolean;
		
		/**
		 * The object containing the parameters for dataflows queries. 
		 */
		protected var _dataParams:SDMXQueryParameters;
		
		/**
		 * Whether or not the current query to be peformed is a dataflow query. 
		 */
		protected var _isDataQuery:Boolean;
		
		/**
		 * The format of the supplied SDMX-ML data file. 
		 */
		protected var _dataFormat:String;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates a new instance of the SDMX service controller.
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
			_dataProvidersFactory = (null == dataFactory) ? 
				new SDMXMLDaoFactory() : dataFactory;
			_dataProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.DAO_ERROR_EVENT, handleError);	
			if (null != structureFactory) {
				_structureProvidersFactory = structureFactory;
			} else if (null != dataFactory) {
				_structureProvidersFactory = dataFactory;
			} else {
				_structureProvidersFactory = new SDMXMLDaoFactory();
			}
			_structureProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.DAO_ERROR_EVENT, handleError);		
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The source to be used for the provider of data.
		 *  
		 * @param dataFile
		 */
		public function set dataFile(dataFile:URLRequest):void
		{
			_dataToFetch = true;
			_dataURL = dataFile;
			_dataProvider = null;
		}
		
		/**
		 * @private
		 */ 
		public function get dataFile():URLRequest
		{
			return _dataURL;
		}
		
		/**
		 * The source to be used for the provider of structural metadata.
		 *  
		 * @param structureFile
		 */
		public function set structureFile(structureFile:URLRequest):void
		{
			_structureToFetch = true;
			_structureURL = structureFile;
			_categorySchemeProvider = null;
			_dataflowProvider = null;
			_keyFamilyProvider = null;
		}
		
		/**
		 * @private
		 */
		public function get structureFile():URLRequest
		{
			return _structureURL;
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
		 * @private
		 */
		public function get disableObservationAttribute():Boolean
		{
			return _disableObservationAttribute;
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
		
		/**
		 * @private
		 */
		public function get optimisationLevel():uint
		{
			return _optimisationLevel;
		}
		
		/**
		 * When a data set is already available and there is no need to ask
		 * the controller to fetch it, it can be assigned using this method.
		 * 
		 * @param ds The data set assigned to this controller 
		 */
		public function set dataSet(ds:DataSet):void
		{
			(model as ISDMXServiceModel).allDataSets = ds;		
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
			_isCategorySchemeQuery = true;	
			if (_structureToFetch) {
				prepareStructureProvider();
			} else {
				performCategorySchemeRequest();
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
			_isDataflowQuery = true;
			
			if (_structureToFetch) {
				prepareStructureProvider();
			} else if (null != dataflowID && null != (_model as 
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
				performDataflowRequest();
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
			_isKeyFamilyQuery = true;	
			if (_structureToFetch) {
				prepareStructureProvider();
			} else {
				performKeyFamilyRequest();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function fetchData(criteria:SDMXQueryParameters = null, 
			format:String = null):void
		{
			_dataParams = criteria;
			_isDataQuery = true;
			_dataFormat = format;
			if (_structureToFetch == true) {
				_keyFamilyParams = {id: null, agency: null, version: null};
				_isKeyFamilyQuery = true;
				prepareStructureProvider();
			} else if (_dataToFetch) {
				prepareDataProvider();
			} else {
				performDataRequest();
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
			event.stopImmediatePropagation();
			event = null;
			_isCategorySchemeQuery = false;
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
			_isDataflowQuery = false;
			
			//If there as some dataflows with only reference to a key family, we
			//need to fetch the full key family definition.
			for each (var refDataflow:DataflowDefinition in 
				_dataflowsWithNoKeyFamily) {
				fetchKeyFamily(refDataflow.structure.id, refDataflow.structure.
					maintainer.id, refDataflow.structure.version);	
			}
		}
		
		protected function handleKeyFamily(event:SDMXDataEvent):void
		{
			event.stopImmediatePropagation();
			(_model as BaseSDMXServiceModel).keyFamilies = 
				event.data as KeyFamilies;
			_isKeyFamilyQuery = false;
			
			var foundDataflows:DataflowsCollection = new DataflowsCollection();
			for each (var refDataflow:DataflowDefinition in 
				_dataflowsWithNoKeyFamily) {
				var kf:KeyFamily = (event.data as KeyFamilies).
					getKeyFamilyByID(refDataflow.structure.id, refDataflow.
					structure.maintainer.id, refDataflow.structure.version);	
				if (null != kf)	{ 
					refDataflow.structure = kf;
					foundDataflows.addItem(refDataflow);
				}
			}
			(_model as BaseSDMXServiceModel).dataflowDefinitions = 
				foundDataflows;
			event = null;			
			
			//It might be that the call to fetch key families was triggered
			//by the fetchData method. In which case, we now need to execute 
			//that method.  
			if (_isDataQuery) {
				if (_dataToFetch) {
					prepareDataProvider();
				} else {
					performDataRequest();
				}
			}
		}
		
		/**
		 * Handles the reception of statistical data.
		 * 
		 * @param event The event containing the statistical data
		 */
		protected function handleData(event:SDMXDataEvent):void
		{
			(_model as BaseSDMXServiceModel).dataSet = event.data as DataSet;
			event.stopImmediatePropagation();
			event = null;
			_isDataQuery = false;
		}
		
		protected function handleStructureFactoryReady(event:Event):void
		{
			event.stopImmediatePropagation();
			event = null;
			_structureProvidersFactory.removeEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleStructureFactoryReady);
			_structureToFetch = false;	
			if (_isCategorySchemeQuery) {	
				_categorySchemeProvider = createStructureProvider(
					"CategoryScheme", BaseSDMXDaoFactory.CATEGORY_SCHEMES_EVENT, 
					handleCategoryScheme); 
				performCategorySchemeRequest();
			} else if (_isDataflowQuery) {
				_dataflowProvider = createStructureProvider("Dataflow", 
					BaseSDMXDaoFactory.DATAFLOWS_EVENT,	
					handleDataflowDefinition);
				performDataflowRequest();
			} else if (_isKeyFamilyQuery) {
				_keyFamilyProvider = createStructureProvider("KeyFamily", 
					BaseSDMXDaoFactory.KEY_FAMILIES_EVENT, handleKeyFamily);
				performKeyFamilyRequest();
			}
		}
		
		protected function prepareStructureProvider():void
		{
			_structureProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleStructureFactoryReady);
			_structureProvidersFactory.sourceURL = _structureURL;	
		}
		
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
		
		protected function performKeyFamilyRequest():void {
			if (null == _keyFamilyProvider) {
				_keyFamilyProvider = createStructureProvider("KeyFamily", 
					BaseSDMXDaoFactory.KEY_FAMILIES_EVENT, handleKeyFamily);
			}
			_keyFamilyProvider.getMaintainableArtefact(
				_keyFamilyParams["id"], _keyFamilyParams["agency"], 
				_keyFamilyParams["version"]);	
		}
		
		protected function handleDataFactoryReady(event:Event):void
		{
			event.stopImmediatePropagation();
			event = null;
			_dataToFetch = false;
			performDataRequest();				
		}
		
		protected function prepareDataProvider():void
		{
			_dataProvidersFactory.addEventListener(
				BaseSDMXDaoFactory.INIT_READY, handleDataFactoryReady);
			_dataProvidersFactory.sourceURL = _dataURL;	
		}
		
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
			_dataProvider.optimisationLevel = _optimisationLevel;
			_dataProvider.disableObservationAttribute = 
				_disableObservationAttribute;
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