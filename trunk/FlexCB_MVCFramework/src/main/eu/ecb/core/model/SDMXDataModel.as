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
package eu.ecb.core.model
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.formatters.DateFormatter;
	
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	
	/**
	 * Event dispatched when the data set containing all series has been 
	 * processed
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.FULL_DATASET_UPDATED
	 */
	[Event(name="fullDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the data set with the selected set of series
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.DATASET_UPDATED
	 */
	[Event(name="dataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the filtered data set has been processed
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.FILTERED_DATASET_UPDATED
	 */
	[Event(name="filteredDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the reference series has been processed
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.REFERENCE_SERIES_UPDATED
	 */
	[Event(name="referenceSeriesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the filtered reference series has been processed
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.FILTERED_REFERENCE_SERIES_UPDATED
	 */
	[Event(name="filteredReferenceSeriesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the reference series frequency has been updated
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.REFERENCE_SERIES_FREQUENCY_UPDATED
	 */
	[Event(name="referenceSeriesFrequencyUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the list of periods has been updated
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.PERIODS_UPDATED
	 */
	[Event(name="periodsUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the flag showing whether the reference series is
	 * a percentage has been updated
	 * 
	 * @eventType eu.ecb.core.model.SDMXDataModel.IS_PERCENTAGE_UPDATED
	 */
	[Event(name="isPercentageUpdated", type="flash.events.Event")]

	/**
	 * Holds SDMX IM artefacts such as datasets, time series, observations, etc. 
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */
	public class SDMXDataModel extends EventDispatcher implements ISDMXDataModel
	{
		/*=============================Constants==============================*/
		/**
		 * The SDMXDataModel.FULL_DATASET_UPDATED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>fullDataSetUpdated</code> event.
		 * 
		 * @eventType fullDataSetUpdated
		 */
		public static const FULL_DATASET_UPDATED:String = "fullDataSetUpdated";
		
		/**
		 * The SDMXDataModel.DATASET_UPDATED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>dataSetUpdated</code> event.
		 * 
		 * @eventType dataSetUpdated
		 */
		public static const DATASET_UPDATED:String = "dataSetUpdated";
		
		/**
		 * The SDMXDataModel.FILTERED_DATASET_UPDATED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>filteredDataSetUpdated</code> event.
		 * 
		 * @eventType filteredDataSetUpdated
		 */
		public static const FILTERED_DATASET_UPDATED:String = 
			"filteredDataSetUpdated";
			
		/**
		 * The SDMXDataModel.REFERENCE_SERIES_UPDATED constant defines the value  
		 * of the <code>type</code> property of the event object for a 
		 * <code>referenceSeriesUpdated</code> event.
		 * 
		 * @eventType referenceSeriesUpdated
		 */	
		public static const REFERENCE_SERIES_UPDATED:String = 
			"referenceSeriesUpdated";

		/**
		 * The SDMXDataModel.FILTERED_REFERENCE_SERIES_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>filteredReferenceSeriesUpdated</code> event.
		 * 
		 * @eventType filteredReferenceSeriesUpdated
		 */
		public static const FILTERED_REFERENCE_SERIES_UPDATED:String = 
			"filteredReferenceSeriesUpdated"
		
		/**
		 * The SDMXDataModel.REFERENCE_SERIES_FREQUENCY_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>referenceSeriesFrequencyUpdated</code> event.
		 * 
		 * @eventType referenceSeriesFrequencyUpdated
		 */
		public static const REFERENCE_SERIES_FREQUENCY_UPDATED:String = 
			"referenceSeriesFrequencyUpdated"
		
		/**
		 * The SDMXDataModel.PERIODS_UPDATED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>periodsUpdated</code> event.
		 * 
		 * @eventType periodsUpdated
		 */ 
		public static const PERIODS_UPDATED:String = "periodsUpdated";
		
		/**
		 * The SDMXDataModel.IS_PERCENTAGE_UPDATED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>isPercentageUpdated</code> event.
		 * 
		 * @eventType isPercentageUpdated
		 */
		public static const IS_PERCENTAGE_UPDATED:String = 
			"isPercentageUpdated";
		
		/*==============================Fields================================*/
		
		protected var _fullDataSet:DataSet;
		
		/**
		 * @private
		 */ 
		protected var _dataSet:DataSet;
		
		/**
		 * @private
		 */ 
		protected var _filteredDataSet:DataSet;
		
		/**
		 * @private
		 */ 
		protected var _referenceSeries:TimeseriesKey;
		
		/**
		 * @private
		 */
		protected var _filteredReferenceSeries:TimeseriesKey;
		
		/**
		 * @private
		 */
		protected var _referenceSeriesFrequency:String;
		
		/**
		 * @private
		 */
		protected var _periods:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _hasDefaultPeriod:Boolean;
		
		/**
		 * @private
		 */
		protected var _isPercentage:Boolean;
		
		/**
		 * @private
		 */
		private var _referenceSeriesIndex:uint;
		
		/**
		 * @private
		 */
		private var _allPeriods:Array;
		
		/**
		 * @private
		 */
		private var _selectedPeriod:Object;
		
		/**
		 * @private
		 */
		protected var _startDate:Date;
		
		/**
		 * @private
		 */
		protected var _endDate:Date;
		
		/**
		 * @private
		 */
		protected var _sort:Sort;
		
		/**
		 * @private
		 */
		private var _dateFormatter:DateFormatter;
		
		/**
		 * @private
		 */
		private var _leftIndex:int;
		
		/**
		 * @private
		 */
		private var _rightIndex:int;
		
		/*===========================Constructor==============================*/
		
		public function SDMXDataModel()
		{
			super();
			_dateFormatter = new DateFormatter();
			_hasDefaultPeriod = true;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */
		[Bindable("fullDataSetUpdated")]
		public function get fullDataSet():DataSet 
		{
			return _fullDataSet;
		}
		
		/**
		 * @private
		 */ 
		public function set fullDataSet(ds:DataSet):void 
		{
			if (null == ds) {
				throw new ArgumentError("The data set cannot be null");
			} else if (null == ds.timeseriesKeys || 
				0 == ds.timeseriesKeys.length) {
				throw new ArgumentError("There should be some time series in " + 
						"the data set");
			} else {
				_fullDataSet = ds;	
				if (null == _sort) {
					_sort = new Sort();
		            _sort.fields = [new SortField("periodComparator")];
		  		}
				for each (var series:TimeseriesKey in 
					_fullDataSet.timeseriesKeys) {
					series.timePeriods.sort = _sort;
					series.timePeriods.refresh();
				}
				dataSet = _fullDataSet;
			}
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
		 * @private
		 */ 
		public function set dataSet(ds:DataSet):void 
		{
			_dataSet = ds;
			createReferenceSeries();
			createReferenceSeriesFrequency();
			createSelectedPeriods();
			createFilteredDataSet();
			dispatchEvent(new Event(DATASET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("filteredDataSetUpdated")]
		public function get filteredDataSet():DataSet
		{
			return _filteredDataSet; 
		}
		
		/**
		 * @private
		 */
		public function set filteredDataSet(dataSet:DataSet):void
		{
			_filteredDataSet = dataSet;
			dispatchEvent(new Event(FILTERED_DATASET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("referenceSeriesUpdated")]
		public function get referenceSeries():TimeseriesKey 
		{
			return _referenceSeries;
		}
		
		/**
		 * @private
		 */
		public function set referenceSeries(referenceSeries:TimeseriesKey):void
		{
			_referenceSeries = referenceSeries;
			var tmpIndex:uint = 
				_dataSet.timeseriesKeys.getItemIndex(referenceSeries);
			_referenceSeriesIndex = (tmpIndex > -1) ? tmpIndex : 0;
			dispatchEvent(new Event(REFERENCE_SERIES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("filteredReferenceSeriesUpdated")]
		public function get filteredReferenceSeries():TimeseriesKey 
		{
			return _filteredReferenceSeries;
		}
		
		/**
		 * @private
		 */
		public function set filteredReferenceSeries(filteredReferenceSeries:
			TimeseriesKey):void
		{
			_filteredReferenceSeries = filteredReferenceSeries;
			dispatchEvent(new Event(FILTERED_REFERENCE_SERIES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("referenceSeriesFrequencyUpdated")]
		public function get referenceSeriesFrequency():String
		{	
			return _referenceSeriesFrequency;
		}
		
		/**
		 * @private
		 */
		public function set referenceSeriesFrequency(freq:String):void
		{
			_referenceSeriesFrequency = freq;
			if (_referenceSeriesFrequency == "B" || 
	    		_referenceSeriesFrequency == "D") {
	    		_dateFormatter.formatString = "YYYY-MM-DD";
	    	} else if (_referenceSeriesFrequency == "M" || 
	    		_referenceSeriesFrequency == "Q") {
	    		_dateFormatter.formatString = "YYYY-MM";	    			
	    	} else if (_referenceSeriesFrequency == "A") {
	    		_dateFormatter.formatString = "YYYY";
	    	} else if (null == _referenceSeriesFrequency) {
	    		throw new ArgumentError("The frequency could not be found in" + 
						" the dimensions of the selected series");
	    	}
			dispatchEvent(new Event(REFERENCE_SERIES_FREQUENCY_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("periodsUpdated")]
		public function get periods():ArrayCollection
		{
			return _periods;
		}
		
		/**
		 * @private
		 */
		public function set periods(periods:ArrayCollection):void 
		{
			_periods = periods;
			dispatchEvent(new Event(PERIODS_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("isPercentageUpdated")]
		public function get isPercentage():Boolean
		{
			return _isPercentage;
		}
		
		/**
		 * @private
		 */
		public function set isPercentage(flag:Boolean):void
		{
			_isPercentage = flag;
			dispatchEvent(new Event(IS_PERCENTAGE_UPDATED));
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function handlePeriodChange(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			_hasDefaultPeriod = true;
			_selectedPeriod = null;
			for each (var period:Object in periods) {
				if (period.label == event.data) {
					period.selected = true;
				} else {
					period.selected = false;
				}
			}
			if (event.data == "All") {
				_endDate = (referenceSeries.timePeriods.getItemAt(
					referenceSeries.timePeriods.length - 1) as TimePeriod).
					timeValue;
				_rightIndex = referenceSeries.timePeriods.length - 1;	
			}
			event = null;
			updatedFilteredCollection(getPreviousDate(
				(filteredReferenceSeries.timePeriods.
				getItemAt(filteredReferenceSeries.timePeriods.length - 1) as 
				TimePeriod).timeValue, referenceSeries));	
			dispatchEvent(new Event(PERIODS_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleChartDragged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			_leftIndex = (_leftIndex + Number(event.data) > 0) ? 
				_leftIndex + Number(event.data) : 0;
			_rightIndex = (_rightIndex + Number(event.data) < 
				_referenceSeries.timePeriods.length - 1) ? 
				_rightIndex + Number(event.data) : 
				_referenceSeries.timePeriods.length - 1;
			event = null;	
			_endDate = 
				(referenceSeries.timePeriods.getItemAt(_rightIndex) as
				TimePeriod).timeValue;
			updatedFilteredCollection(
				_referenceSeries.timePeriods.getItemAt(_leftIndex) as
					TimePeriod);
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleDividerDragged(event:DataEvent, 
			dividerPosition:String):void
		{
			event.stopImmediatePropagation();
			_hasDefaultPeriod = false;
			if ("left" == dividerPosition) {
				_leftIndex = (_leftIndex + int(event.data) > 0) ? 
					_leftIndex + int(event.data) : 0;
				if (!(_leftIndex < _rightIndex)) {
					_leftIndex = _rightIndex - 2;	
				}	
				_startDate = 
					(_referenceSeries.timePeriods.getItemAt(_leftIndex) 
						as TimePeriod).timeValue;		
			} else if ("right" == dividerPosition) {
				_rightIndex = (_rightIndex + int(event.data) < 
					_referenceSeries.timePeriods.length - 1) ? 
						_rightIndex + int(event.data) : 
						_referenceSeries.timePeriods.length - 1;
				if (!(_rightIndex > _leftIndex)) {
					_rightIndex = _leftIndex + 2;
				}
				_endDate = 
					(referenceSeries.timePeriods.getItemAt(_rightIndex) as
					TimePeriod).timeValue;
			}
			event = null;
			triggerDataFiltering();
		}
		
		// "Creational" methods
		/**
		 * @private
		 */
		protected function createReferenceSeries():void
	    {
			var tmpSeries:TimeseriesKey = dataSet.timeseriesKeys.getItemAt(
				_referenceSeriesIndex) as TimeseriesKey;
			if ((dataSet.groupKeys.getGroupsForTimeseries(tmpSeries) 
				as GroupKeysCollection).length != 0) {
				var group:GroupKey = (dataSet.groupKeys.
					getGroupsForTimeseries(tmpSeries) as 
					GroupKeysCollection).getItemAt(0) as GroupKey;	
				if (null != group) {	
					for each (var attribute:AttributeValue in 
						group.attributeValues) {	
						if (attribute is CodedAttributeValue && (attribute 
							as CodedAttributeValue).valueFor.conceptIdentity
							.id == "UNIT") {
							var codeID:String = (attribute as 
								CodedAttributeValue).value.id;
							isPercentage = (codeID == "PC" || codeID == 
								"PCT" || codeID == "PCCH" || codeID == 
								"PCPA");
							break;	
						}
					}
				}	
			}
			referenceSeries = tmpSeries;
	    }
	    
	    /**
		 * @private
		 */
	    protected function createFilteredDataSet():void
	    {
			var tmpDataSet:DataSet = new DataSet();
			tmpDataSet.attributeValues = dataSet.attributeValues;
			tmpDataSet.dataExtractionDate = dataSet.dataExtractionDate;
			tmpDataSet.describedBy = dataSet.describedBy;
			tmpDataSet.groupKeys = dataSet.groupKeys;
			tmpDataSet.reportingBeginDate = dataSet.reportingBeginDate;
			tmpDataSet.reportingEndDate = dataSet.reportingEndDate;
			var seriesCollection:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			for each (var series:TimeseriesKey in dataSet.timeseriesKeys) {
				seriesCollection.addItem(createFilteredSeries(series));					
			}
			tmpDataSet.timeseriesKeys = seriesCollection;
			filteredDataSet = tmpDataSet;
			filteredReferenceSeries = filteredDataSet.timeseriesKeys.
				getItemAt(_referenceSeriesIndex) as TimeseriesKey;
			if (_rightIndex == 0 && referenceSeries.timePeriods.length > 0) {	
				updatedFilteredCollection(getPreviousDate(
           			(referenceSeries.timePeriods.getItemAt(
           				referenceSeries.timePeriods.length - 1) 
           				as TimePeriod).timeValue, referenceSeries));	
			} else if (referenceSeries.timePeriods.length > 0) {
				triggerDataFiltering();
			}
	    }
	    
	    /**
		 * @private
		 */
	    protected function createFilteredSeries(
	    	series:TimeseriesKey):TimeseriesKey 
		{	
			var filteredSeries:TimeseriesKey = 
				new TimeseriesKey(series.valueFor);
            filteredSeries.keyValues = series.keyValues;
            filteredSeries.attributeValues = series.attributeValues;
            filteredSeries.timePeriods = 
            	new TimePeriodsCollection(
            		series.timePeriods.toArray().concat());
           	filteredSeries.timePeriods.sort = series.timePeriods.sort;
           	filteredSeries.timePeriods.refresh();
           	filteredSeries.timePeriods.filterFunction = filterData;
           	return filteredSeries;			
		}
	    
	    /**
		 * @private
		 */
	    protected function createReferenceSeriesFrequency():void
	    {
	    	_referenceSeriesFrequency = null;
			for each (var keyValue:KeyValue in referenceSeries.keyValues) {
				if (keyValue.valueFor.conceptRole == ConceptRole.FREQUENCY){
					referenceSeriesFrequency = keyValue.value.id;
					break;
				}
			}
			if (null == referenceSeriesFrequency) {
				throw new ArgumentError("Frequency could not be found");
			}
	    }
	    
	    /**
		 * @private
		 */
		protected function createSelectedPeriods():void {
			var selectedPeriods:Array = new Array();
			if (null == _allPeriods) {
				_allPeriods = new Array();
				_allPeriods.push({label: "1m", 
					tooltip: "Display data for the last month"});						
				_allPeriods.push({label: "3m", 
					tooltip: "Display data for the last 3 months"});						
				_allPeriods.push({label: "6m", 
					tooltip: "Display data for the last 6 months"});						
				_allPeriods.push({label: "1y", 
					tooltip: "Display data for the last year"});						
				_allPeriods.push({label: "2y", 
					tooltip: "Display data for the last 2 years"});						
				_allPeriods.push({label: "5y", 
					tooltip: "Display data for the last 5 years"});						
				_allPeriods.push({label: "10y", 
					tooltip: "Display data for the last 10 years"});						
				_allPeriods.push({label: "All", 
					tooltip: "Display all available data"});	
			}

			if (referenceSeries.timePeriods.length >0) {
				var firstObsDate:Date = 
					(referenceSeries.timePeriods.getItemAt(0) as 
						TimePeriod).timeValue;
				var lastObsDate:Date = 	
					(referenceSeries.timePeriods.getItemAt(referenceSeries.
						timePeriods.length - 1) as TimePeriod).timeValue;
				var difference:Number = lastObsDate.getTime() - 
					firstObsDate.getTime();
				var numberOfYears:Number = difference / 31536000000;
	
				if (referenceSeriesFrequency == "B" || 
					referenceSeriesFrequency == "D") {
					if (numberOfYears > 10) {
						_allPeriods[3]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 7);
					} else if (numberOfYears > 5) {
						_allPeriods[3]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 6);
					} else if (numberOfYears > 2) {
						_allPeriods[3]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 5);
					} else if (numberOfYears > 1) {
						_allPeriods[3]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 4);
					} else if (numberOfYears > 0.5) {
						_allPeriods[2]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 3);	
					} else if (numberOfYears > 0.25) {
						_allPeriods[1]["selected"] = true;
						selectedPeriods = _allPeriods.slice(0, 2);	
					} else if (numberOfYears > 0.085) {
						_allPeriods[0]["selected"] = true;					
						selectedPeriods.push(_allPeriods[0]);	
					}
				} else if (referenceSeriesFrequency == "M" || 
					referenceSeriesFrequency == "Q") {
					if (numberOfYears > 10) {
						_allPeriods[5]["selected"] = true;					
						selectedPeriods = _allPeriods.slice(3, 7);
					} else if (numberOfYears > 5) {
						_allPeriods[5]["selected"] = true;					
						selectedPeriods = _allPeriods.slice(3, 6);
					} else if (numberOfYears > 2) {
						_allPeriods[4]["selected"] = true;					
						selectedPeriods = _allPeriods.slice(3, 5);				
					} else if (numberOfYears > 1) {
						_allPeriods[3]["selected"] = true;					
						selectedPeriods.push(_allPeriods[3]);
					}
				} else if (referenceSeriesFrequency == "A") {
					_allPeriods[5]["selected"] = true;
					if (numberOfYears > 10) {		
						_allPeriods[5]["selected"] = true;	
						selectedPeriods = _allPeriods.slice(5, 7);
					} else if (numberOfYears > 5) {
						_allPeriods[5]["selected"] = true;
						selectedPeriods.push(_allPeriods[5]);
					}
				}
				selectedPeriods.push(_allPeriods[7]);
				periods = new ArrayCollection(selectedPeriods);
				_hasDefaultPeriod = true;
			}
		}
		
		// Data filtering methods
		/**
		 * @private
		 */
		protected function filterData(item:Object):Boolean {
            return item.timeValue >= _startDate && item.timeValue <= _endDate;
        }
        
		/**
		 * @private
		 * This method finds the closest observation in the collection, based
		 * on the default period zoom.
		 */ 
		protected function getPreviousDate(date:Date, 
			series:TimeseriesKey):TimePeriod 
		{
			var tmpDate:Date = new Date(date.fullYear, date.month, date.date);
			if (null == _selectedPeriod) {
				for each (var period:Object in periods) {
					if (period.selected == true) {
						_selectedPeriod = period;
						break;
					}
				}
				if (null == _selectedPeriod) {
					throw new ArgumentError("Could not find the default " + 
						"period");
				}
			}	
	    	switch(_selectedPeriod.label) {
	    		case "All":
	    			tmpDate = 
	    				(series.timePeriods.getItemAt(0) 
	    					as TimePeriod).timeValue;
	    			break;
	    		case "10y":
	    			tmpDate.fullYear = tmpDate.fullYear - 10;
	    			break;
	    		case "5y":
	    			tmpDate.fullYear = tmpDate.fullYear - 5;
	    			break;
	    		case "2y":
	        		tmpDate.fullYear = tmpDate.fullYear - 2;
	    			break;
	    		case "1y":
	        		tmpDate.fullYear = tmpDate.fullYear - 1;
	    			break;
	    		case "6m":
	        		tmpDate.month = tmpDate.month - 6;
	    			break;
	    		case "3m":
	        		tmpDate.month = tmpDate.month - 3;
	    			break;
	    		case "1m":
	        		tmpDate.month = tmpDate.month - 1;
	    			break;        			        			        			        			        			
				default:
					throw new ArgumentError("Unknown period: " + 
						_selectedPeriod.label);        			
	    	}
	    	var obs:TimePeriod = findExistingObservation(tmpDate, series);
	    	_leftIndex = referenceSeries.timePeriods.getItemIndex(obs);
	    	return obs;
	    }        
    
	    /**
	    * @private
	    * Goes backward in the collection until the closest observation to the
	    * supplied date is found. If no date is found, returns the 1st one in 
	    * the collection.
	    */ 
	    protected function findExistingObservation(date:Date, 
	    	series:TimeseriesKey):TimePeriod {
	    	var cursor:IViewCursor = series.timePeriods.createCursor();
	    	var result:TimePeriod = findRateByDate(cursor, date);
	    	while(null == result && 
	    		date > (series.timePeriods.getItemAt(0) 
	    			as TimePeriod).timeValue) {
	    		if (referenceSeriesFrequency == "B" || 
	    			referenceSeriesFrequency == "D") {
	        		date.date = date.date - 1;
	    		} else if (referenceSeriesFrequency == "M" || 
	    			referenceSeriesFrequency == "Q") {
	    			date.month = date.month - 1;
	    		} else if (referenceSeriesFrequency == "A") {
					date.fullYear = date.fullYear - 1;
				}
	    		result = findRateByDate(cursor, date);
	    	}
	    	return (null == result) ? 
	    		series.timePeriods.getItemAt(0) as TimePeriod : result;
	    }
    
	    /**
	    * @private
	    * Finds the observation in the collection corresponding to the supplied
	    * date.
	    */ 
	    protected function findRateByDate(seriesCursor:IViewCursor, 
	    	date:Date):TimePeriod {
			return (seriesCursor.findFirst(
				{periodComparator:_dateFormatter.format(date)})) ? 
				seriesCursor.current as TimePeriod : null ;
	    }
	    
	    /**
	    * @private
	    * Sets the first date for the filtered collection and filters it.
	    */ 
	    protected function updatedFilteredCollection(date:TimePeriod):void {
	    	_startDate = date.timeValue;
	    	if (null == _endDate && _referenceSeries.timePeriods.length > 1) {	
				_endDate = (referenceSeries.timePeriods.getItemAt(
					referenceSeries.timePeriods.length - 1) 
					as TimePeriod).timeValue;
			}
			if (0 == _rightIndex) {
				_rightIndex = referenceSeries.timePeriods.length - 1;
			}
			triggerDataFiltering();		
	    }
	    
	    /**
	     * @private
	     * Triggers the data filtering
	     */ 
	    protected function triggerDataFiltering():void {
	    	for each (var series:TimeseriesKey in 
	    		filteredDataSet.timeseriesKeys) {
		    	if (null != series.timePeriods) {
			        series.timePeriods.refresh();
		    	}
	    	}
	    	dispatchEvent(new Event(FILTERED_DATASET_UPDATED));	
	    	dispatchEvent(new Event(FILTERED_REFERENCE_SERIES_UPDATED));	
	    } 
	}
}