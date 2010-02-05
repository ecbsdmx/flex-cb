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
package eu.ecb.core.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.structure.category.CategorieSchemesCollection;
	import org.sdmx.model.v2.structure.category.CategoryScheme;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeScheme;
	import org.sdmx.model.v2.structure.hierarchy.HierarchicalCodeSchemesCollection;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;

	/**
	 * Event dispatched when category schemes have been added to the model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.CATEGORY_SCHEMES_UPDATED
	 */
	[Event(name="categorySchemesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when dataflow definitions have been added to the model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.DATAFLOWS_UPDATED
	 */
	[Event(name="dataflowsUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when hierarchical code schemes have been added to the 
	 * 	model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.HIERARCHICAL_CODE_SCHEMES_UPDATED
	 */
	[Event(name="hierarchicalCodeSchemesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when key families have been added to the model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.KEY_FAMILIES_UPDATED
	 */
	[Event(name="keyFamiliesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when a data set has been added to the model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.DATA_SET_UPDATED
	 */
	[Event(name="dataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when all data sets has been modified in the model.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXServiceModel.ALL_DATA_SETS_UPDATED
	 */
	[Event(name="allDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Base implementation of the ISDMXServiceModel. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class BaseSDMXServiceModel extends EventDispatcher 
		implements ISDMXServiceModel
	{
		/*=============================Constants==============================*/
		
		/**
		 * The BaseSDMXServiceModel.CATEGORY_SCHEMES_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>categorySchemesUpdated</code> event.
		 * 
		 * @eventType categorySchemesUpdated
		 */
		public static const CATEGORY_SCHEMES_UPDATED:String = 
			"categorySchemesUpdated";
			
		/**
		 * The BaseSDMXServiceModel.DATAFLOWS_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>dataflowsUpdated</code> event.
		 * 
		 * @eventType dataflowsUpdated
		 */
		public static const DATAFLOWS_UPDATED:String = "dataflowsUpdated";	
		
		/**
		 * The BaseSDMXServiceModel.HIERARCHICAL_CODE_SCHEMES_UPDATED constant 
		 * defines the value of the <code>type</code> property of the event 
		 * object for a <code>hierarchicalCodeSchemesUpdated</code> event.
		 * 
		 * @eventType hierarchicalCodeSchemesUpdated
		 */
		public static const HIERARCHICAL_CODE_SCHEMES_UPDATED:String = 
			"hierarchicalCodeSchemesUpdated";	
		
		/**
		 * The BaseSDMXServiceModel.KEY_FAMILIES_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>keyFamiliesUpdated</code> event.
		 * 
		 * @eventType dataflowsUpdated
		 */
		public static const KEY_FAMILIES_UPDATED:String = "keyFamiliesUpdated";
		
		/**
		 * The BaseSDMXServiceModel.DATA_SET_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>dataSetUpdated</code> event.
		 * 
		 * @eventType dataSetUpdated
		 */
		public static const DATA_SET_UPDATED:String = "dataSetUpdated";
		
		/**
		 * The BaseSDMXServiceModel.ALL_DATA_SETS_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>allDataSetsUpdated</code> event.
		 * 
		 * @eventType allDataSetsUpdated
		 */
		public static const ALL_DATA_SETS_UPDATED:String = "allDataSetsUpdated";
		
		/*==============================Fields================================*/
		
		/**
		 * The last category schemes that have been added to the model 
		 */
		protected var _categorySchemes:CategorieSchemesCollection;
		
		/**
		 * All category schemes available in the model
		 */ 
		protected var _allCategorySchemes:CategorieSchemesCollection;
		
		/**
		 * The last dataflow definitions that have been added to the model 
		 */
		protected var _dataflowDefinitions:DataflowsCollection;
		
		/**
		 * All dataflow definitions available in the model 
		 */
		protected var _allDataflowDefinitions:DataflowsCollection;
		
		/**
		 * The last hierarchical code schemes that have been added to the model 
		 */
		protected var 
			_hierarchicalCodeSchemes:HierarchicalCodeSchemesCollection;
		
		/**
		 * All hierarchical code schemes available in the model
		 */ 
		protected var 
			_allHierarchicalCodeSchemes:HierarchicalCodeSchemesCollection;
		
		/**
		 * The last key families that have been added to the model 
		 */
		protected var _keyFamilies:KeyFamilies;
		
		/**
		 * All key families available in the model 
		 */
		protected var _allKeyFamilies:KeyFamilies;
		
		/**
		 * The last data set that has been added to the model 
		 */
		protected var _dataSet:DataSet;
		
		/**
		 * The data set containing all series and groups stored in the model. 
		 */
		protected var _allDataSets:DataSet;
		
		/**
		 * The sort algorithm that will be used to sort observations within
		 * time series.
		 */
		protected var _sort:Sort;
		
		/*===========================Constructor==============================*/
		
		public function BaseSDMXServiceModel()
		{
			super();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		[Bindable("categorySchemesUpdated")]
		public function get categorySchemes():CategorieSchemesCollection 
		{
			return _categorySchemes;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set categorySchemes(cs:CategorieSchemesCollection):void 
		{
			_categorySchemes = cs;
			
			if (null == _allCategorySchemes) {
				_allCategorySchemes = _categorySchemes;
			} else {
				for each (var currentCS:CategoryScheme in _categorySchemes) {
					if (!(_allCategorySchemes.contains(currentCS))) {
						_allCategorySchemes.addItem(currentCS);
					}
				}
			}
			dispatchEvent(new Event(CATEGORY_SCHEMES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allCategorySchemes():CategorieSchemesCollection
		{
			return _allCategorySchemes;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("dataflowsUpdated")]
		public function get dataflowDefinitions():DataflowsCollection 
		{
			return _dataflowDefinitions;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataflowDefinitions(dd:DataflowsCollection):void 
		{
			_dataflowDefinitions = dd;
			
			if (null == _allDataflowDefinitions) {
				_allDataflowDefinitions = dd;
			} else {
				for each (var currentDD:DataflowDefinition in 
					_dataflowDefinitions) {
					if (null == _allDataflowDefinitions.getDataflowById(
						currentDD.id, currentDD.maintainer.id, 
						currentDD.version)) {	
						_allDataflowDefinitions.addItem(currentDD);
					}
				}
			}
			dispatchEvent(new Event(DATAFLOWS_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allDataflowDefinitions():DataflowsCollection
		{
			return _allDataflowDefinitions;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("hierarchicalCodeSchemesUpdated")]
		public function get hierarchicalCodeSchemes():
			HierarchicalCodeSchemesCollection
		{
			return _hierarchicalCodeSchemes;
		}	 
		
		/**
		 * @inheritDoc
		 */ 
		public function set hierarchicalCodeSchemes(
			hcs:HierarchicalCodeSchemesCollection):void
		{
			_hierarchicalCodeSchemes = hcs;
			
			if (null == _allHierarchicalCodeSchemes) {
				_allHierarchicalCodeSchemes = hcs;
			} else {
				for each (var currentHCS:HierarchicalCodeScheme in 
					_hierarchicalCodeSchemes) {
					if (null == _allHierarchicalCodeSchemes.getSchemeByID(
						currentHCS.id, currentHCS.maintainer.id, 
						currentHCS.version)) {	
						_allHierarchicalCodeSchemes.addItem(currentHCS);
					}
				}
			}
			dispatchEvent(new Event(HIERARCHICAL_CODE_SCHEMES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allHierarchicalCodeSchemes():
			HierarchicalCodeSchemesCollection
		{
			return _allHierarchicalCodeSchemes;
		}	
		
		/**
		 * @inheritDoc
		 */
		[Bindable("keyFamiliesUpdated")]
		public function get keyFamilies():KeyFamilies
		{
			return _keyFamilies;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set keyFamilies(kf:KeyFamilies):void 
		{
			_keyFamilies = kf;
			
			if (null == _allKeyFamilies) {
				_allKeyFamilies = kf;
			} else {
				for each (var currentKF:KeyFamily in _keyFamilies) {
					if (null == _allKeyFamilies.getKeyFamilyByID(currentKF.id,
						currentKF.maintainer.id)) {	
						_allKeyFamilies.addItem(currentKF);
					}
				}
			}
			dispatchEvent(new Event(KEY_FAMILIES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allKeyFamilies():KeyFamilies
		{
			return _allKeyFamilies;
		}
		
		/**
		 * @inheritDoc
		 */ 
		[Bindable("dataSetUpdated")]
		public function get dataSet():DataSet
		{
			return _dataSet;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataSet(ds:DataSet):void
		{
			_dataSet = ds;
			if (null!= ds && null != ds.timeseriesKeys) { 
				addDataSet(ds);
			}
			dispatchEvent(new Event(DATA_SET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */ 
		[Bindable("allDataSetsUpdated")]
		public function get allDataSets():DataSet
		{
			return _allDataSets;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function getDataSetWithSeries(seriesKeys:ArrayCollection):DataSet
		{
			var matchingDataSet:DataSet = new DataSet();
			matchingDataSet.attributeValues = _allDataSets.attributeValues;
			matchingDataSet.describedBy = _allDataSets.describedBy;
			var matchingSeries:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			var matchingGroup:GroupKeysCollection = new GroupKeysCollection();	
			for each (var seriesKey:String in seriesKeys) {
				var s:TimeseriesKey = 
					_allDataSets.timeseriesKeys.getTimeseriesKey(seriesKey);
				if (null != s) {	
					matchingSeries.addItem(s);
					var groups:GroupKeysCollection = _allDataSets.groupKeys.
						getGroupsForTimeseries(s);
					if (null != groups) {
						for each (var group:GroupKey in groups) { 
							matchingGroup.addItem(group);
						}
					}	
				}
			}
			matchingDataSet.timeseriesKeys = matchingSeries;
			matchingDataSet.groupKeys = matchingGroup;
			return matchingDataSet;
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * Adds a dataset to the collection containing all data available in the
		 * model.
		 * 
		 * @param ds The data set to be added
		 */
		protected function addDataSet(ds:DataSet):void
		{
			if (null == _allDataSets) {
				_allDataSets = new DataSet();
			}
			
			for each (var series:TimeseriesKey in ds.timeseriesKeys){
				var s:TimeseriesKey = _allDataSets.timeseriesKeys.
					getTimeseriesKey(series.seriesKey);
				if (null == s) {
					sortSeries(series);
					_allDataSets.timeseriesKeys.addItem(series);
				}
			}
			
			for each (var group:GroupKey in ds.groupKeys) {
				if (!(_allDataSets.groupKeys.contains(group))) {
					_allDataSets.groupKeys.addItem(group);
				}
			}
			dispatchEvent(new Event(ALL_DATA_SETS_UPDATED));
		}
		
		/**
		 * This method sorts the observations of a time series by periods, in 
		 * ascending order.
		 *  
		 * @param series The series to be sorted
		 */
		protected function sortSeries(series:TimeseriesKey):void
		{
			if (null == _sort) {
				_sort = new Sort();
		        _sort.fields = [new SortField("periodComparator")];
		  	}
		  	series.timePeriods.sort = _sort;
			series.timePeriods.refresh();
		}
	}
}