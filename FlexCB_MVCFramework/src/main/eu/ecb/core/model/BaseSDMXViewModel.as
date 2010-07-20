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
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
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
	import org.sdmx.model.v2.structure.keyfamily.XSMeasure;
	
	/**
	 * Event dispatched when the filtered data set has been processed
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.FILTERED_DATASET_UPDATED
	 */
	[Event(name="filteredDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the data set containing the selected series
	 * has been processed updated.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.SELECTED_DATASET_UPDATED
	 */
	[Event(name="selectedDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the data set containing the highlighted series
	 * has been processed updated.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.HIGHLIGHTED_DATASET_UPDATED
	 */
	[Event(name="highlightedDataSetUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the reference series has been processed
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.REFERENCE_SERIES_UPDATED
	 */
	[Event(name="referenceSeriesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the filtered reference series has been processed
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.FILTERED_REFERENCE_SERIES_UPDATED
	 */
	[Event(name="filteredReferenceSeriesUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the reference series frequency has been updated
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.REFERENCE_SERIES_FREQUENCY_UPDATED
	 */
	[Event(name="referenceSeriesFrequencyUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the key of the series to be used as reference 
	 * series has been updated
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.REFERENCE_SERIES_KEY_UPDATED
	 */
	[Event(name="referenceSeriesKeyUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the list of periods has been updated
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.PERIODS_UPDATED
	 */
	[Event(name="periodsUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the flag showing whether the reference series is
	 * a percentage has been updated
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.IS_PERCENTAGE_UPDATED
	 */
	[Event(name="isPercentageUpdated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when selected date has been updated.
	 * 
	 * @eventType eu.ecb.core.model.BaseSDMXViewModel.SELECTED_DATE_UPDATED
	 */
	[Event(name="selectedDateUpdated", type="flash.events.Event")]

	/**
	 * Holds SDMX IM artefacts such as datasets, time series, observations, etc. 
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 * @author Rok Povse
	 */
	[ResourceBundle("flex_cb_mvc_lang")]
	public class BaseSDMXViewModel extends BaseSDMXServiceModel 
		implements ISDMXViewModel
	{
				
		/*=============================Constants==============================*/
		
		/**
		 * The BaseSDMXViewModel.FILTERED_DATASET_UPDATED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>filteredDataSetUpdated</code> event.
		 * 
		 * @eventType filteredDataSetUpdated
		 */
		public static const FILTERED_DATASET_UPDATED:String = 
			"filteredDataSetUpdated";
			
		/**
		 * The BaseSDMXViewModel.SELECTED_DATASET_UPDATED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>selectedDataSetUpdated</code> event.
		 * 
		 * @eventType selectedDataSetUpdated
		 */
		public static const SELECTED_DATASET_UPDATED:String = 
			"selectedDataSetUpdated";	
			
		/**
		 * The BaseSDMXViewModel.HIGHLIGHTED_DATASET_UPDATED constant defines 
		 * the value of the <code>type</code> property of the event object for a 
		 * <code>highlightedDataSetUpdated</code> event.
		 * 
		 * @eventType highlightedDataSetUpdated
		 */
		public static const HIGHLIGHTED_DATASET_UPDATED:String = 
			"highlightedDataSetUpdated";	
			
		/**
		 * The BaseSDMXViewModel.REFERENCE_SERIES_UPDATED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>referenceSeriesUpdated</code> event.
		 * 
		 * @eventType referenceSeriesUpdated
		 */	
		public static const REFERENCE_SERIES_UPDATED:String = 
			"referenceSeriesUpdated";

		/**
		 * The BaseSDMXViewModel.FILTERED_REFERENCE_SERIES_UPDATED constant 
		 * defines the value of the <code>type</code> property of the event 
		 * object for a <code>filteredReferenceSeriesUpdated</code> event.
		 * 
		 * @eventType filteredReferenceSeriesUpdated
		 */
		public static const FILTERED_REFERENCE_SERIES_UPDATED:String = 
			"filteredReferenceSeriesUpdated"
		
		/**
		 * The BaseSDMXViewModel.REFERENCE_SERIES_FREQUENCY_UPDATED constant 
		 * defines the value of the <code>type</code> property of the event 
		 * object for a <code>referenceSeriesFrequencyUpdated</code> event.
		 * 
		 * @eventType referenceSeriesFrequencyUpdated
		 */
		public static const REFERENCE_SERIES_FREQUENCY_UPDATED:String = 
			"referenceSeriesFrequencyUpdated"
			
		/**
		 * The BaseSDMXViewModel.REFERENCE_SERIES_KEY_UPDATED constant 
		 * defines the value of the <code>type</code> property of the event 
		 * object for a <code>referenceSeriesKeyUpdated</code> event.
		 * 
		 * @eventType referenceSeriesKeyUpdated
		 */
		public static const REFERENCE_SERIES_KEY_UPDATED:String = 
			"referenceSeriesKeyUpdated"	
		
		/**
		 * The BaseSDMXViewModel.PERIODS_UPDATED constant defines the value of 
		 * the <code>type</code> property of the event object for a 
		 * <code>periodsUpdated</code> event.
		 * 
		 * @eventType periodsUpdated
		 */ 
		public static const PERIODS_UPDATED:String = "periodsUpdated";
		
		/**
		 * The BaseSDMXViewModel.IS_PERCENTAGE_UPDATED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>isPercentageUpdated</code> event.
		 * 
		 * @eventType isPercentageUpdated
		 */
		public static const IS_PERCENTAGE_UPDATED:String = 
			"isPercentageUpdated";
			
		/**
		 * The BaseSDMXViewModel.SELECTED_DATE_UPDATED constant defines the 
		 * value of the <code>type</code> property of the event object for a 
		 * <code>selectedDateUpdated</code> event.
		 * 
		 * @eventType selectedDateUpdated
		 */
		public static const SELECTED_DATE_UPDATED:String = 
			"selectedDateUpdated";	
		
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		private var _resourceManager:IResourceManager;
		
		/**
		 * @private
		 */ 
		protected var _filteredDataSet:DataSet;
		
		/**
		 * @private
		 */ 
		protected var _allFilteredDataSets:DataSet;
		
		/**
		 * @private
		 */
		protected var _selectedDataSet:DataSet;
		
		/**
		 * @private
		 */
		protected var _highlightedDataSet:DataSet;
		
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
		private var _referenceSeriesIndex:int;
		
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
		private var _dateFormatter:DateFormatter;
		
		/**
		 * @private
		 */
		private var _leftIndex:int;
		
		/**
		 * @private
		 */
		private var _rightIndex:int;
		
		/**
		 * @private
		 */ 
		private var _startDateSet:Boolean;
		
		/**
		 * @private
		 */ 
		private var _selectedDate:String;
		
		/**
		 * @private
		 */ 
		private var _referenceSeriesKey:String;
		
		/**
		 * @private
		 */ 
		private var _selectedMeasures:Object;
		
		/**
		 * @private
		 */ 
		private var _highlightedMeasure:XSMeasure;
		
		/**
		 * @private
		 */ 
		private var _deselectedMeasure:XSMeasure;
		
		/**
		 * @private
		 */ 
		protected var _moviePlayed:Boolean;
		
		private var _refSeriesLen:uint;
		
		/*===========================Constructor==============================*/
		
		public function BaseSDMXViewModel()
		{
			super();
			_dateFormatter = new DateFormatter();
			_hasDefaultPeriod = true;
			_resourceManager = ResourceManager.getInstance();
		}
		
		/*============================Accessors===============================*/
				
		/**
		 * @private
		 */ 
		override public function set dataSet(ds:DataSet):void 
		{
			if (null == ds || null == ds.timeseriesKeys || 
				0 == ds.timeseriesKeys.length) {
				throw new ArgumentError("The dataset cannot be null or empty");	
			}
			_dataSet = ds;
			_referenceSeries = createReferenceSeries();
			createSelectedPeriods();
			createFilteredDataSet();
			super.dataSet = ds;
			referenceSeries = _referenceSeries;
			if (null == _selectedDate && null != _referenceSeries && null !=
				_referenceSeries.timePeriods && 
				0 < _referenceSeries.timePeriods.length) {
				selectedDate = (_referenceSeries.timePeriods.getItemAt(
					_referenceSeries.timePeriods.length - 1) as TimePeriod).
					periodComparator;
			}
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
			if (null!= dataSet && null != dataSet.timeseriesKeys) { 
				addFilteredDataSet(dataSet);
			}
			dispatchEvent(new Event(FILTERED_DATASET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("allFilteredDataSetsUpdated")]
		public function get allFilteredDataSets():DataSet
		{
			return _allFilteredDataSets; 
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("selectedDataSetUpdated")]
		public function get selectedDataSet():DataSet
		{
			return _selectedDataSet; 
		}
		
		/**
		 * @private
		 */
		public function set selectedDataSet(dataSet:DataSet):void
		{
			_selectedDataSet = dataSet;
			dispatchEvent(new Event(SELECTED_DATASET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("highlightedDataSetUpdated")]
		public function get highlightedDataSet():DataSet
		{
			return _highlightedDataSet; 
		}
		
		/**
		 * @private
		 */
		public function set highlightedDataSet(dataSet:DataSet):void
		{
			_highlightedDataSet = dataSet;
			dispatchEvent(new Event(HIGHLIGHTED_DATASET_UPDATED));
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
			var tmpIndex:int = 
				_dataSet.timeseriesKeys.getItemIndex(_referenceSeries);
			_referenceSeriesIndex = (tmpIndex > -1) ? tmpIndex : 0;
			_refSeriesLen = _referenceSeries.timePeriods.length;
			dispatchEvent(new Event(REFERENCE_SERIES_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("referenceSeriesKeyUpdated")]
		public function get referenceSeriesKey():String 
		{
			return _referenceSeriesKey;
		}
		
		/**
		 * @private
		 */
		public function set referenceSeriesKey(seriesKey:String):void
		{
			_referenceSeriesKey = seriesKey;
			dispatchEvent(new Event(REFERENCE_SERIES_KEY_UPDATED));
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
		
		/**
		 * @inheritDoc
		 */
		[Bindable("selectedDateUpdated")]
		public function get selectedDate():String {
			return _selectedDate;
		}
		
		/**
		 * @inheritDoc
		 */
		 public function set selectedDate(date:String):void
		 {
		 	if (date != _selectedDate) {
		 		_selectedDate = date;
		 		dispatchEvent(new Event(SELECTED_DATE_UPDATED));
		 		if (_moviePlayed) {
		 			dispatchEvent(new Event(FILTERED_DATASET_UPDATED));
		 		}
		 	}
		 }
		
		/**
		 * @inheritDoc
		 */
		public function set startDate(date:Date):void
		{
			_startDate = date;
			_startDateSet = true;
			if (null != _filteredDataSet && null != _filteredDataSet.
				timeseriesKeys && _filteredDataSet.timeseriesKeys.length > 0) {
				triggerDataFiltering();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set endDate(date:Date):void
		{
			_endDate = date;
			if (null != _filteredDataSet && null != _filteredDataSet.
				timeseriesKeys && _filteredDataSet.timeseriesKeys.length > 0) {
				triggerDataFiltering();
			}
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Updates the language used by the application views. 
		 */
		public function updateLanguage():void {
			_allPeriods = null;
			createSelectedPeriods();
			dispatchEvent(new Event(PERIODS_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handlePeriodChange(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			_startDateSet = false;
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
			_startDateSet = false;		

			var percentage:Number = (Number(event.data)/100.0);
			var periodSize:uint = _rightIndex-_leftIndex;
			var tempEndDate:Date,tempStartDate:Date;
			
			tempEndDate=new Date((_referenceSeries.timePeriods.getItemAt(0) as
				 TimePeriod).timeValue);
			tempEndDate.time+=convertPercentageToDate(percentage);
			
			_rightIndex = findFirstTimePeriodByDate(tempEndDate);
			
			//hit right wall
			if (_rightIndex>=_refSeriesLen) {
				tempEndDate = new Date((_referenceSeries.timePeriods.getItemAt(
					_refSeriesLen-1) as TimePeriod).timeValue);
				_rightIndex = _refSeriesLen-1;
			}
			
			if (_hasDefaultPeriod) { 
				tempStartDate = getPreviousDate((_referenceSeries.timePeriods.
					getItemAt(_rightIndex) as TimePeriod).timeValue,
				_referenceSeries).timeValue;
			} else {
				 _leftIndex=_rightIndex-periodSize;
				_leftIndex=Math.max(0,_leftIndex);
				tempStartDate = new Date((_referenceSeries.timePeriods.
					getItemAt(_leftIndex) as TimePeriod).timeValue); 
			}
			
			//hit left wall
			if (_leftIndex<=0) {
				_leftIndex=0;
				tempStartDate = new Date((_referenceSeries.timePeriods.
					getItemAt(0) as TimePeriod).timeValue);
				tempEndDate = new Date(tempStartDate);
				
				if (_hasDefaultPeriod) {
					switch(_selectedPeriod.identifier) {
			    		case "All":
			    			tempEndDate = (_referenceSeries.timePeriods.
			    			getItemAt(_refSeriesLen-1) as TimePeriod).timeValue;
			    			break;
			    		case "10y":
			    			tempEndDate.fullYear = tempEndDate.fullYear + 10;
			    			break;
			    		case "5y":
			    			tempEndDate.fullYear = tempEndDate.fullYear + 5;
			    			break;
			    		case "2y":
			        		tempEndDate.fullYear = tempEndDate.fullYear + 2;
			    			break;
			    		case "1y":
			        		tempEndDate.fullYear = tempEndDate.fullYear + 1;
			    			break;
			    		case "6m":
			        		tempEndDate.month = tempEndDate.month + 6;
			    			break;
			    		case "3m":
			        		tempEndDate.month = tempEndDate.month + 3;
			    			break;
			    		case "1m":
			        		tempEndDate.month = tempEndDate.month + 1;
			    			break;        			        			        			        			        			
						default:
							throw new ArgumentError("Unknown period: " + 
								_selectedPeriod.label);        			
	    			}
	    			_rightIndex = findFirstTimePeriodByDate(tempEndDate);
				} else {
					_rightIndex = _leftIndex + periodSize;
					tempEndDate = (_referenceSeries.timePeriods.getItemAt(
						_rightIndex) as TimePeriod).timeValue; 
				}
			}
			_leftIndex=findFirstTimePeriodByDate(tempStartDate);
			
			if (_rightIndex>=_refSeriesLen) {
				tempEndDate = new Date((_referenceSeries.timePeriods.getItemAt(
					_refSeriesLen-1) as TimePeriod).timeValue);
				_rightIndex=_refSeriesLen-1;
			}
			
			_startDate = tempStartDate;
			_endDate = tempEndDate;
			
			triggerDataFiltering();
		}
		
		/**
		 * @inheritDoc
		 */
		public function handleDividerDragged(event:DataEvent, 
			dividerPosition:String):void
		{
			
			var percentage:Number = (Number(event.data)/100.0);
			
			var tempStartDate:Date = new Date((_referenceSeries.timePeriods.
				getItemAt(0)as TimePeriod).timeValue);
			//how many days from the beginning we need to add */
			tempStartDate.time += convertPercentageToDate(percentage); 
			
			var tmpIndex:uint = findFirstTimePeriodByDate(tempStartDate);
			
				
			event.stopImmediatePropagation();
			_startDateSet = false;
			_hasDefaultPeriod = false;
			if ("left" == dividerPosition) {
				  	 
				_leftIndex = tmpIndex; 
				
				if ((_rightIndex - _leftIndex) < 2 ) {
					_leftIndex = _rightIndex-2;
				}
				
			} else if ("right" == dividerPosition) {
				
				_rightIndex = tmpIndex; 
				
				if ((_rightIndex - _leftIndex) < 2 ) {
					_rightIndex = _leftIndex+2;
				}
				
				if (_rightIndex>=_refSeriesLen) { 
					_rightIndex=_refSeriesLen-1;
				}
			}
			
			_startDate = (_referenceSeries.timePeriods.getItemAt(_leftIndex) as 
				TimePeriod).timeValue;
			_endDate = (_referenceSeries.timePeriods.getItemAt(_rightIndex) as 
				TimePeriod).timeValue;			
			
			if ((_filteredReferenceSeries.timePeriods.getItemAt(0) as 
				TimePeriod).timeValue.time!=_startDate.time ||
			_endDate.time != (_filteredReferenceSeries.timePeriods.getItemAt(
				_filteredReferenceSeries.timePeriods.length-1) as TimePeriod).
				timeValue.time) {
				triggerDataFiltering();
			}
			event = null;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLegendItemSelected(event:DataEvent):void
		{
			if (null == _selectedDataSet) {
				_selectedDataSet = new DataSet();
			}
			if (null == _selectedDataSet.timeseriesKeys || 
				0 == _selectedDataSet.timeseriesKeys.length ||
				null == _selectedDataSet.timeseriesKeys.getTimeseriesKey(
					event.data)) {
				_selectedDataSet.timeseriesKeys.addItem(
					_allFilteredDataSets.timeseriesKeys.getTimeseriesKey(
						event.data));			
			} else {
				_selectedDataSet.timeseriesKeys.removeItemAt(
					_selectedDataSet.timeseriesKeys.getItemIndex(
					_selectedDataSet.timeseriesKeys.getTimeseriesKey(
						event.data)));
			}
			dispatchEvent(new Event(SELECTED_DATASET_UPDATED));
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLegendMeasureSelected(
			event:XSMeasureSelectionEvent):void 
		{
			if (null == _selectedMeasures) {
				_selectedMeasures = new Object();
			}
			if (!(_selectedMeasures.hasOwnProperty(event.measure.code.id)) || 
				_selectedMeasures[event.measure.code.id] == null) {
				_selectedMeasures[event.measure.code.id] = event.measure;
			} else {
				_selectedMeasures[event.measure.code.id] = null;
				_deselectedMeasure = event.measure;
			}
			_highlightedMeasure = null;
			dispatchEvent(new Event(SELECTED_DATASET_UPDATED));
		}	
		
		/**
		 * @inheritDoc
		 */ 
		public function handleLegendItemHighlighted(event:DataEvent):void
		{
			if (null == _highlightedDataSet) {
				_highlightedDataSet = new DataSet();
			}
			if (null == _highlightedDataSet.timeseriesKeys || 
				0 == _highlightedDataSet.timeseriesKeys.length ||
				null == _highlightedDataSet.timeseriesKeys.getTimeseriesKey(
					event.data)) {
				_highlightedDataSet.timeseriesKeys.addItem(
					_allFilteredDataSets.timeseriesKeys.getTimeseriesKey(
						event.data));			
			} else {
				_highlightedDataSet.timeseriesKeys.removeItemAt(
					_highlightedDataSet.timeseriesKeys.getItemIndex(
					_highlightedDataSet.timeseriesKeys.getTimeseriesKey(
						event.data)));
			}
			dispatchEvent(new Event(HIGHLIGHTED_DATASET_UPDATED));
		}	
		
		/**
		 * @inheritDoc
		 */
		public function handleLegendMeasureHighlighted(
			event:XSMeasureSelectionEvent):void
		{
			var hasSelectedData:Boolean = false;
			for each (var measure:XSMeasure in _selectedMeasures) {
				//We check that there is a measure stored in the object property	
				if (null != measure) {
					hasSelectedData = true;
					break;		
				}
			}	
			if (null == _deselectedMeasure || hasSelectedData ||
				(null != _deselectedMeasure && _deselectedMeasure.
				measureDimension == event.measure.measureDimension && 
				_deselectedMeasure.code.id != event.measure.code.id && 
				!hasSelectedData)) {
				if (null == _highlightedMeasure || 
					_highlightedMeasure.code.id != event.measure.code.id) {
					_highlightedMeasure = event.measure;
				} else {
					_highlightedMeasure = null;
				}		
				dispatchEvent(new Event(HIGHLIGHTED_DATASET_UPDATED));
			}
			if (null != _deselectedMeasure && _deselectedMeasure.
				measureDimension == event.measure.measureDimension && 
				_deselectedMeasure.code.id == event.measure.code.id && 
				!hasSelectedData) {
				_deselectedMeasure = null;	
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function handleSelectedDateChanged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			selectedDate = event.data;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getFilteredDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet
		{
			var matchingDataSet:DataSet = new DataSet();
			matchingDataSet.attributeValues = 
				_allFilteredDataSets.attributeValues;
			matchingDataSet.describedBy = _allFilteredDataSets.describedBy;
			var matchingSeries:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			var matchingGroup:GroupKeysCollection = new GroupKeysCollection();	
			for each (var seriesKey:String in seriesKeys) {
				var s:TimeseriesKey = 
					_allFilteredDataSets.timeseriesKeys.
						getTimeseriesKey(seriesKey);
				if (null != s) {	
					matchingSeries.addItem(s);
					if (_moviePlayed) {
						s.timePeriods.filterFunction = filterDataForMovie;
						s.timePeriods.refresh();
					}
					var groups:GroupKeysCollection = 
						_allFilteredDataSets.groupKeys.
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
		
		/**
		 * @inheritDoc
		 */ 
		public function getSelectedDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet
		{
			var matchingDataSet:DataSet = new DataSet();
			matchingDataSet.attributeValues = 
				_allFilteredDataSets.attributeValues;
			matchingDataSet.describedBy = _allFilteredDataSets.describedBy;
			var matchingSeries:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			var matchingGroup:GroupKeysCollection = new GroupKeysCollection();
			if (_allFilteredDataSets.timeseriesKeys.length > 0) {
				var refSeries:TimeseriesKey = _allFilteredDataSets.
					timeseriesKeys.getItemAt(0) as TimeseriesKey; 
				var hasSelectedMeasure:Boolean = false;	
				for each (var measure:XSMeasure in _selectedMeasures) {	
					if (null != measure) {
						hasSelectedMeasure = true;
						var pos:int = refSeries.valueFor.getItemIndex(
							refSeries.valueFor.getDimension(
							measure.measureDimension.conceptIdentity.id));
						for each (var seriesKey:String in seriesKeys) {
							var s:TimeseriesKey = _allFilteredDataSets.
								timeseriesKeys.getTimeseriesKey(seriesKey) as 
								TimeseriesKey;
							if (null != s && (s.keyValues.getItemAt(pos) as 
								KeyValue).value.id == measure.code.id) {	
								matchingSeries.addItem(s);
								var groups:GroupKeysCollection = 
									_allFilteredDataSets.groupKeys.
									getGroupsForTimeseries(s);
								if (null != groups) {
									for each (var group:GroupKey in groups) { 
										matchingGroup.addItem(group);
									}
								}	
							}
						}
					}
				}
			}
			matchingDataSet.timeseriesKeys = matchingSeries;
			matchingDataSet.groupKeys = matchingGroup;
			return matchingDataSet;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getHighlightedDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet
		{
			var matchingDataSet:DataSet = new DataSet();
			matchingDataSet.attributeValues = 
				_allFilteredDataSets.attributeValues;
			matchingDataSet.describedBy = _allFilteredDataSets.describedBy;
			var matchingSeries:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			var matchingGroup:GroupKeysCollection = new GroupKeysCollection();
			if (_allFilteredDataSets.timeseriesKeys.length > 0) {
				var refSeries:TimeseriesKey = _allFilteredDataSets.
					timeseriesKeys.getItemAt(0) as TimeseriesKey; 	
				if (null != _highlightedMeasure) {
					var pos:int = refSeries.valueFor.getItemIndex(
						refSeries.valueFor.getDimension(_highlightedMeasure.
						measureDimension.conceptIdentity.id));
					for each (var seriesKey:String in seriesKeys) {
						var s:TimeseriesKey = _allFilteredDataSets.
							timeseriesKeys.getTimeseriesKey(seriesKey) as 
							TimeseriesKey;
						if (null != s && (s.keyValues.getItemAt(pos) as 
							KeyValue).value.id == _highlightedMeasure.code.id) {	
							matchingSeries.addItem(s);
							var groups:GroupKeysCollection = 
								_allFilteredDataSets.groupKeys.
								getGroupsForTimeseries(s);
							if (null != groups) {
								for each (var group:GroupKey in groups) { 
									matchingGroup.addItem(group);
								}
							}	
						}
					}
				}
			}
			matchingDataSet.timeseriesKeys = matchingSeries;
			matchingDataSet.groupKeys = matchingGroup;
			return matchingDataSet;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getMinAndMaxValues(seriesKeys:ArrayCollection):Object 
		{
			var tmpSort:Sort = new Sort();
			tmpSort.fields = 
				[new SortField("observationValue", false, false, true)];
			var values:Object = {"minValue": NaN, "maxValue": NaN};	
			for each(var seriesKey:String in seriesKeys) {
				var series:TimeseriesKey = 
					_allFilteredDataSets.timeseriesKeys.
						getTimeseriesKey(seriesKey);
				if (null != series) {	
					series.timePeriods.filterFunction = filterData;
					series.timePeriods.sort = tmpSort;
					series.timePeriods.refresh();	
					var firstObs:TimePeriod =  
						series.timePeriods.getItemAt(0) as TimePeriod;
					var lastObs:TimePeriod = series.timePeriods.getItemAt(
						series.timePeriods.length - 1) as TimePeriod;	
					if (isNaN(values["minValue"]) || 
						values["minValue"] > Number(firstObs.observationValue)){
						values["minValue"] = Number(firstObs.observationValue);
					}
					if (isNaN(values["maxValue"]) || 
						values["maxValue"] < Number(lastObs.observationValue)) {
						values["maxValue"] = Number(lastObs.observationValue);
					}
					series.timePeriods.sort = _sort;
					series.timePeriods.refresh();
				}
			}
			values["minValue"] = Math.floor(values["minValue"]);
			values["maxValue"] = Math.ceil(values["maxValue"]);
			return values;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function startMovie():void
		{
			_moviePlayed = true;
		}		
		
		/**
		 * @inheritDoc
		 */ 	
		public function stopMovie():void
		{
			_moviePlayed = false;
			for each (var series:TimeseriesKey in 
				_allFilteredDataSets.timeseriesKeys) {
				series.timePeriods.filterFunction = filterData;
				series.timePeriods.refresh();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isPlayingMovie():Boolean
		{
			return _moviePlayed;
		}
		
		/*=========================Protected methods==========================*/
		
		// "Creational" methods
		/**
		 * @private
		 */
		protected function createReferenceSeries():TimeseriesKey
	    {
	    	var tmpSeries:TimeseriesKey;
	    	var targetDataSet:DataSet = 
	    		(null != _allDataSets) ? _allDataSets : _dataSet;
	    	if (null != _referenceSeriesKey) {
	    		tmpSeries = targetDataSet.timeseriesKeys.
	    			getTimeseriesKey(_referenceSeriesKey);
	    	}
	    	if (null == tmpSeries) {
				tmpSeries = targetDataSet.timeseriesKeys.getItemAt(
					_referenceSeriesIndex) as TimeseriesKey;
	    	}
	    	_referenceSeriesIndex = 
	    		targetDataSet.timeseriesKeys.getItemIndex(tmpSeries);
			if ((_dataSet.groupKeys.getGroupsForTimeseries(tmpSeries) 
				as GroupKeysCollection).length != 0) {
				var group:GroupKey = (_dataSet.groupKeys.
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
			_referenceSeriesFrequency = null;
			for each (var keyValue:KeyValue in tmpSeries.keyValues) {
				if (keyValue.valueFor.conceptRole == ConceptRole.FREQUENCY){
					referenceSeriesFrequency = keyValue.value.id;
					break;
				}
			}
			if (null == referenceSeriesFrequency) {
				throw new ArgumentError("Frequency could not be found");
			}
			_refSeriesLen = tmpSeries.timePeriods.length;
			sortSeries(tmpSeries);
			return tmpSeries;
	    }
	    
	    /**
		 * @private
		 */
	    protected function createFilteredDataSet():void
	    {
			var tmpDataSet:DataSet = new DataSet();
			tmpDataSet.attributeValues = _dataSet.attributeValues;
			tmpDataSet.dataExtractionDate = _dataSet.dataExtractionDate;
			tmpDataSet.describedBy = _dataSet.describedBy;
			tmpDataSet.groupKeys = _dataSet.groupKeys;
			tmpDataSet.reportingBeginDate = _dataSet.reportingBeginDate;
			tmpDataSet.reportingEndDate = _dataSet.reportingEndDate;
			var seriesCollection:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			for each (var series:TimeseriesKey in _dataSet.timeseriesKeys) {
				seriesCollection.addItem(createFilteredSeries(series));					
			}
			tmpDataSet.timeseriesKeys = seriesCollection;
			filteredDataSet = tmpDataSet;
			
			var targetDataSet:DataSet = (null != _allFilteredDataSets) ? 
				_allFilteredDataSets : _filteredDataSet;
	    				
			_filteredReferenceSeries = targetDataSet.timeseriesKeys.
				getItemAt(_referenceSeriesIndex) as TimeseriesKey;
			if (_startDateSet) {
				triggerDataFiltering();
			} else if (_rightIndex == 0 && 
				_refSeriesLen > 0) {	
				updatedFilteredCollection(getPreviousDate(
           			(_referenceSeries.timePeriods.getItemAt(
           				_refSeriesLen - 1) 
           				as TimePeriod).timeValue, _referenceSeries));	
			} else if (_refSeriesLen > 0) {
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
		protected function createSelectedPeriods():void {
			var selectedPeriods:Array = new Array();
			if (null == _allPeriods) {
				_allPeriods = new Array();
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_1m")
								, tooltip: "Display data for the last month"
								, identifier: "1m"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_3m")
								, tooltip: "Display data for the last 3 months"
								, identifier: "3m"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_6m")
								, tooltip: "Display data for the last 6 months"
								, identifier: "6m"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_1y")
								, tooltip: "Display data for the last year"
								, identifier: "1y"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_2y")
								, tooltip: "Display data for the last 2 years"
								, identifier: "2y"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_5y")
								, tooltip: "Display data for the last 5 years"
								, identifier: "5y"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_10y")
								, tooltip: "Display data for the last 10 years"
								, identifier: "10y"});						
				_allPeriods.push({label: _resourceManager.getString("flex_cb_mvc_lang", "data_range_all")
								, tooltip: "Display all available data"
								, identifier: "All"});	
			}

			sortSeries(_referenceSeries);
			if (_refSeriesLen >0) {
				var firstObsDate:Date = 
					(_referenceSeries.timePeriods.getItemAt(0) as 
						TimePeriod).timeValue;
				var lastObsDate:Date = 	
					(_referenceSeries.timePeriods.getItemAt(_referenceSeries.
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
            return item.timeValue >= _startDate && 
            	((null != _endDate) ? item.timeValue <= _endDate : true);
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
					if (periods.length > 1) {
						throw new ArgumentError("Could not find the default " + 
							"period");
					} else if (periods.length == 1) {
						_selectedPeriod = period;
						period.selected = true;
					}
				}
			}	
	    	switch(_selectedPeriod.identifier) {
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
	    	_leftIndex = _referenceSeries.timePeriods.getItemIndex(obs);
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
	    	if (null == _endDate && _refSeriesLen > 1) {	
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
	    protected function triggerDataFiltering():void{
	    	for each (var series:TimeseriesKey in 
	    		_allFilteredDataSets.timeseriesKeys) {
		    	if (null != series.timePeriods) {
			        series.timePeriods.refresh();
		    	}
	    	}
	    	dispatchEvent(new Event(FILTERED_DATASET_UPDATED));	
	    	dispatchEvent(new Event(FILTERED_REFERENCE_SERIES_UPDATED));	
	    } 
	    
	    /**
		 * Adds a dataset to the collection containing all data available in the
		 * model, after filtering has been applied.
		 * 
		 * @param ds The data set to be added
		 */
		protected function addFilteredDataSet(ds:DataSet):void
		{
			if (null == _allFilteredDataSets) {
				_allFilteredDataSets = new DataSet();
			}
			
			for each (var series:TimeseriesKey in ds.timeseriesKeys){
				if (!(_allFilteredDataSets.timeseriesKeys.contains(series))) {
					sortSeries(series);
					_allFilteredDataSets.timeseriesKeys.addItem(series);
				}
			}
			
			for each (var group:GroupKey in ds.groupKeys) {
				if (!(_allFilteredDataSets.groupKeys.contains(group))) {
					_allFilteredDataSets.groupKeys.addItem(group);
				}
			}
			dispatchEvent(new Event("allFilteredDataSetsUpdated"));
		}
		
		/**
		 * Filters a time series by observation dates
		 */ 
		protected function filterDataByDate(item:Object):Boolean 
		{
            return item.periodComparator == selectedDate;
        }
        
        /**
        * Returns the index of first starting TimePeriod in series by date
        */ 
        protected function findFirstTimePeriodByDate(date:Date):uint {
        	
			var tmpIndex:uint;
			var observations:TimePeriodsCollection = 
				_referenceSeries.timePeriods; 
        	for (tmpIndex = 0; tmpIndex < _refSeriesLen; tmpIndex++) {
				if ((observations.getItemAt(tmpIndex) as TimePeriod).timeValue.
					time>date.time) {
					tmpIndex-=(tmpIndex>0)?1:0;
					break;
				} else if ((observations.getItemAt(tmpIndex) as TimePeriod).
					timeValue.time == date.time) {
					break;
				}
			}
			return tmpIndex;
        }
        /**
        * Calculates number of days from percentage
        */ 
        protected function convertPercentageToDate(percentage:Number):Number {
        	var numOfMilis:Number = (_referenceSeries.timePeriods.getItemAt(
        		_refSeriesLen-1)as TimePeriod).timeValue.time -
				(_referenceSeries.timePeriods.getItemAt(0)as TimePeriod).timeValue.time;
			return percentage*numOfMilis; 
        }
        
        private function filterDataForMovie(item:Object):Boolean
        {
        	return item.timeValue >= _startDate && 
        		item.periodComparator <= selectedDate;
        }
	}
}