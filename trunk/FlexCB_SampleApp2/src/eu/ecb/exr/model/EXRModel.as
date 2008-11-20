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
package eu.ecb.exr.model
{
	import eu.ecb.core.model.SDMXDataModel;
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	
	import flash.events.Event;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.UncodedObservation;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.util.date.SDMXDate;
	
	public class EXRModel extends SDMXDataModel
	{
		private var _initialBaseDataSet:DataSet;
		
		private var _reverseBaseDataSet:DataSet;
		
		private var _numberFormatter:ExtendedNumberFormatter;
		
		private var _sdmxDate:SDMXDate;
		
		public function EXRModel()
		{
			super();
		}
		
		override public function set fullDataSet(ds:DataSet):void 
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
				
				dispatchEvent(new Event(FULL_DATASET_UPDATED));
				
				var tmpDs:DataSet = new DataSet();
				tmpDs.attributeValues = _fullDataSet.attributeValues;
				tmpDs.groupKeys = _fullDataSet.groupKeys;
				tmpDs.dataExtractionDate = _fullDataSet.dataExtractionDate;
				tmpDs.describedBy = _fullDataSet.describedBy;
				tmpDs.reportingBeginDate = _fullDataSet.reportingBeginDate;
				tmpDs.reportingEndDate = _fullDataSet.reportingEndDate;
				var selectedSeries:TimeseriesKeysCollection = 
					new TimeseriesKeysCollection();
				selectedSeries.addItem(
					_fullDataSet.timeseriesKeys.getItemAt(0));
				tmpDs.timeseriesKeys = selectedSeries;
				_dataSet = tmpDs;
				
				// If this is an update of a dataset, we need to recreate
				// various information holders.
				createReferenceSeries();
				createReferenceSeriesFrequency();
				createSelectedPeriods();
				createFilteredDataSet();
				
				dispatchEvent(new Event(DATASET_UPDATED));
			}
		}
		
		public function handleCurrencySwitched():void
		{
		 	if (null != dataSet) {
				if (null == _initialBaseDataSet) {
					_initialBaseDataSet = dataSet;
				}
				
				if (null == _reverseBaseDataSet) {
					_sdmxDate = new SDMXDate();
					createReverseBaseDataSet();
				} 	
				
				if (dataSet == _initialBaseDataSet) {
					dataSet = _reverseBaseDataSet;
				} else if (dataSet == _reverseBaseDataSet) {
					dataSet = _initialBaseDataSet;
				}
			}
		}
		
		public function handleSeriesChanged(seriesKey:String):void
		{
			var selectedSeries:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			var series:TimeseriesKey = _fullDataSet.timeseriesKeys.
				getTimeseriesKey(seriesKey);
			selectedSeries.addItem(series);
			_dataSet.timeseriesKeys = selectedSeries;
			_dataSet.groupKeys = 
				_fullDataSet.groupKeys.getGroupsForTimeseries(series);
			_initialBaseDataSet = null;
			_reverseBaseDataSet = null;
			createReferenceSeries();
			createReferenceSeriesFrequency();
			createSelectedPeriods();
			createFilteredDataSet();
			dispatchEvent(new Event(DATASET_UPDATED));
		}
		
		private function createReverseBaseDataSet():void
		{
			_reverseBaseDataSet = new DataSet();
			_reverseBaseDataSet.attributeValues = 
				_initialBaseDataSet.attributeValues;
			_reverseBaseDataSet.dataExtractionDate = 
				_initialBaseDataSet.dataExtractionDate;	
			_reverseBaseDataSet.describedBy = 
				_initialBaseDataSet.describedBy;
			_reverseBaseDataSet.reportingBeginDate = 
				_initialBaseDataSet.reportingBeginDate;
			_reverseBaseDataSet.reportingEndDate = 
				_initialBaseDataSet.reportingEndDate;	
			var groupKeys:GroupKeysCollection = 
				new GroupKeysCollection();
			for each (var group:GroupKey in _initialBaseDataSet.groupKeys) {
				groupKeys.addItem(reverseGroupKey(group));
			}	
			_reverseBaseDataSet.groupKeys = groupKeys;		
			var seriesKeys:TimeseriesKeysCollection = 
				new TimeseriesKeysCollection();
			for each (var series:TimeseriesKey in 
				_initialBaseDataSet.timeseriesKeys) {
				var newSeries:TimeseriesKey = reverseSeriesKey(series);
				for each (var groupKey:GroupKey in 
					_reverseBaseDataSet.groupKeys) {
					if (groupKey.keyValues.seriesKey == 
						newSeries.seriesKey.substr(newSeries.seriesKey.indexOf(".") + 1)) {
						groupKey.timeseriesKeys.addItem(newSeries);
					}	
				}
				seriesKeys.addItem(newSeries);
			}
			_reverseBaseDataSet.timeseriesKeys = seriesKeys;		
		} 
		
		private function reverseGroupKey(key:GroupKey):GroupKey 
		{
			var groupKey:GroupKey = new GroupKey(key.valueFor);
			groupKey.attributeValues = key.attributeValues;
			var keyValues:KeyValuesCollection = new KeyValuesCollection();
			for each (var keyValue:KeyValue in key.keyValues) {
				keyValues.addItem(createKeyValue(keyValue));	
			}		
			(keyValues.getItemAt(0) as KeyValue).value = 
				(key.keyValues.getItemAt(1) as KeyValue).value;
			(keyValues.getItemAt(1) as KeyValue).value = 
				(key.keyValues.getItemAt(0) as KeyValue).value;
			groupKey.keyValues = keyValues;
			return groupKey;
		}
		
		private function reverseSeriesKey(key:TimeseriesKey):TimeseriesKey
		{
			var seriesKey:TimeseriesKey = new TimeseriesKey(key.valueFor);
			seriesKey.attributeValues = key.attributeValues;
			var keyValues:KeyValuesCollection = new KeyValuesCollection();
			for each (var keyValue:KeyValue in key.keyValues) {
				keyValues.addItem(createKeyValue(keyValue));	
			}		
			(keyValues.getItemAt(1) as KeyValue).value = 
				(key.keyValues.getItemAt(2) as KeyValue).value;
			(keyValues.getItemAt(2) as KeyValue).value = 
				(key.keyValues.getItemAt(1) as KeyValue).value;
			seriesKey.keyValues = keyValues;
			var observations:TimePeriodsCollection = 
				new TimePeriodsCollection();
			var firstObs:TimePeriod = 
				key.timePeriods.getItemAt(0) as TimePeriod;		
			if (null == _numberFormatter) {
				_numberFormatter = new ExtendedNumberFormatter();
			}			
			_numberFormatter.precision = 
				firstObs.observationValue.indexOf(".") > -1 ? 
		    		firstObs.observationValue.substring(0,
		    			firstObs.observationValue.indexOf(".")).length + 3 : 4;	
			for each (var obs:TimePeriod in key.timePeriods) {
				observations.addItem(createObservation(obs));
			}
			seriesKey.timePeriods = observations;
			seriesKey.timePeriods.sort = _sort;
			seriesKey.timePeriods.refresh();
			return seriesKey;
		}
		
		private function createKeyValue(keyValue:KeyValue):KeyValue
		{
			var code:Code = new Code(keyValue.value.id);
			code.annotations = keyValue.value.annotations;
			code.description = keyValue.value.description;
			code.name = keyValue.value.name;
			code.uri = keyValue.value.uri;
			code.urn = keyValue.value.urn;
			code.validFrom = keyValue.value.validFrom;
			code.validTo = keyValue.value.validTo;
			code.version = keyValue.value.version;
			return new KeyValue(code, 
				keyValue.valueFor);
		}
		
		private function createObservation(obs:TimePeriod):TimePeriod
		{
			var obsValue:UncodedObservation = new UncodedObservation(
				_numberFormatter.format(1 / 
				(Number((obs.observation as UncodedObservation).value))), 
				(obs.observation as UncodedObservation).valueFor)
			obsValue.attributeValues = obs.observation.attributeValues;	
			return new TimePeriod(obs.periodComparator, obsValue, _sdmxDate);
		}
	}
}