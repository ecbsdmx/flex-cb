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
package org.sdmx.stores.xml.v2.compact
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.reporting.dataset.AttachableArtefact;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.AttributeValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedObservation;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.Observation;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.UncodedObservation;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.keyfamily.AttributeDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.CodedDataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.CodedMeasure;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptorsCollection;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.Measure;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.stores.xml.v2.DataReaderAdapter;
	import org.sdmx.util.date.SDMXDate;
	
	/**
	 * Reads an SDMX-ML Compact data file and returns a dataset containing the
	 * matching series.
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
	public class CompactReader extends DataReaderAdapter {
		
		/*==============================Fields================================*/
		
		private var _dimensions:KeyDescriptor;
		
		private var _groups:GroupKeyDescriptorsCollection;
		
		private var _measures:MeasureDescriptor;
		
		private var _timeDimension:Dimension;
		
		private var _timeDimensionCode:String;
		
		private var _primaryMeasure:Measure;
		
		private var _primaryMeasureCode:String;
		
		private var _attributes:AttributeDescriptor;
		
		private var _sdmxDate:SDMXDate;		
		
		/*============================Namespaces==============================*/
		
		private var compactNS:Namespace;
		
		/*===========================Constructor==============================*/
		
		public function CompactReader(keyFamilies:KeyFamilies, 
			target:IEventDispatcher = null) 
		{		
			super(target);
			this.keyFamilies = keyFamilies;
			_sdmxDate = new SDMXDate();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function set dataFile(dataFile:XML):void
		{
			super.dataFile = dataFile;
			_data.addNamespace(messageNS);
			var namespaces:Array = 
				(_data.children()[1] as XML).inScopeNamespaces();
			for (var i:uint = 0; i < namespaces.length; i++) {
				if (namespaces[i].prefix == "") {
					compactNS = 
						new Namespace("compact", String(namespaces[i].uri));
					_data.addNamespace(compactNS);
					break;
				}
			}
			prepareDataSet();
		}
				
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		override public function query(query:Object = null):void 
		{
			var seriesCollection:XMLList = 
				_data.compactNS::DataSet.compactNS::Series;
			var groupCollection:XMLList = 
				_data.compactNS::DataSet.compactNS::Group;	
				
			if (query != null) {
				for (var seriesDimension:Object in query) {
					seriesCollection = seriesCollection.(
						attribute(seriesDimension) == query[seriesDimension]);
					if ((_groups.getItemAt(0) as GroupKeyDescriptor).
						containsDimension(seriesDimension as String))	{	
						groupCollection = groupCollection.(
							attribute(seriesDimension) == 
								query[seriesDimension]);	
					}	
				}
			}
			
			for each (var series:XML in seriesCollection) {
				_dataSet.timeseriesKeys.addItem(
					extractSeries(series, _dataSet));
			}
			
			for each (var group:XML in groupCollection) {
				_dataSet.groupKeys.addItem(extractGroup(group, _dataSet));
			}

			dispatchEvent(new SDMXDataEvent(_dataSet, DATASET_EVENT));
		}
		
		/*==========================Private methods===========================*/
		
		private function prepareDataSet():void
		{
			_dataSet = new DataSet();
			var keyFamily:KeyFamily;
			if (!_data.compactNS::DataSet.hasOwnProperty("@keyFamilyURI")) {
				if (_keyFamilies.length > 1) {
					throw new Error("The dataset does not contain the URI of" + 
						" the key family");
				} else {
					keyFamily = _keyFamilies.getItemAt(0) as KeyFamily;
				}
			} else {
				keyFamily = 
					_keyFamilies.getKeyFamilyByURI(
						_data.compactNS::DataSet.@keyFamilyURI);
			}
			
			_dimensions = keyFamily.keyDescriptor;
			_measures   = keyFamily.measureDescriptor;
			_attributes = keyFamily.attributeDescriptor;
			_groups     = keyFamily.groupDescriptors;
			if (null == _dimensions) {
				throw new Error("No dimensions found for key family: " 
					+ _data.compactNS::DataSet.@keyFamilyURI);
			}
			if (null == _measures) {
				throw new Error("No measures found for key family: " 
					+ _data.compactNS::DataSet.@keyFamilyURI);				
			}
			
			for each (var dimension:Dimension in _dimensions) {
				if (dimension.conceptRole == ConceptRole.TIME) {
					_timeDimension = dimension;
					_timeDimensionCode = _timeDimension.conceptIdentity.id;
					break;
				}
      		}
			if (_timeDimension == null) {
				throw new Error("Could not find time dimension");
			}
			
			for each (var measure:Measure in _measures) {
				if (measure.conceptRole == ConceptRole.PRIMARY_MEASURE) {
					_primaryMeasure = measure;
					_primaryMeasureCode = _primaryMeasure.conceptIdentity.id;
					break;
				}
			}
			if (_primaryMeasure == null) {
				throw new Error("Could not find primary measure");
			}
			
			if (_data.compactNS::DataSet.hasOwnProperty("@reportingBeginDate")){
				_dataSet.reportingBeginDate = 
					_sdmxDate.getDate(
						_data.compactNS::DataSet.@reportingBeginDate);
			}
			if (_data.compactNS::DataSet.hasOwnProperty("@reportingEndDate")) {
				_dataSet.reportingEndDate = 
					_sdmxDate.getDate(
						_data.compactNS::DataSet.@reportingEndDate);
			}
			if (_data.messageNS::Header.child(new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message", 
				"Extracted")).length() > 0) {
				_dataSet.dataExtractionDate =
					_sdmxDate.getDate(
						String(_data.messageNS::Header.messageNS::Extracted));
			}
			dispatchEvent(new Event(INIT_READY));	
		}
		
		private function extractGroup(group:XML, dataSet:DataSet):GroupKey 
		{
			var groupKey:String = "";
			var keyValues:KeyValuesCollection = new KeyValuesCollection();
			for each (var attribute:XML in group.attributes()) {
				var dimension:Dimension = 
					_dimensions.getDimension(attribute.name());
				if (null != dimension) {
					groupKey = groupKey + attribute.name() + ".";
					var code:Code = 
						(dimension.localRepresentation as CodeList).codes.
						getCode(attribute);
					if (null == code) {
						throw new Error("Could not find value '" + attribute);
					}
					keyValues.addItem(new KeyValue(code, dimension));
				}
			}
			groupKey = groupKey.substr(0, groupKey.length - 1);
			var targetGroup:GroupKeyDescriptor = _groups.getGroup(groupKey);
			if (null == targetGroup) {
				throw new Error("Could not find group with key: " + groupKey);
			}
			var targetGroupKey:GroupKey = new GroupKey(targetGroup);
			targetGroupKey.keyValues = keyValues;
			extractAttributes(group, targetGroupKey);
			for each (var series:TimeseriesKey in dataSet.timeseriesKeys) {
				if (series.belongsToGroup(keyValues)) {
					targetGroupKey.timeseriesKeys.addItem(series);
				}
			}
			return targetGroupKey;
		}
		
		private function extractSeries(series:XML, 
			dataSet:DataSet):TimeseriesKey 
		{
			var seriesKey:TimeseriesKey = new TimeseriesKey(_dimensions);
			for each (var seriesAttribute:XML in series.attributes()) {
				var dimension:Dimension = 
					_dimensions.getDimension(seriesAttribute.name());
				if (null != dimension) {
					var code:Code = 
						(dimension.localRepresentation as CodeList).codes.
							getCode(seriesAttribute);
					if (null == code) {
						throw new Error("Could not find value '" + 
							seriesAttribute);
					}
					seriesKey.keyValues.addItem(new KeyValue(code, dimension));
				}
			}
			extractAttributes(series, seriesKey);
			var observations:TimePeriodsCollection = seriesKey.timePeriods;
			for each (var observation:XML in series.compactNS::Obs) {
				var obs:TimePeriod = 
					extractObservation(observation, dataSet);
				if (null != obs) {
					observations.addItem(obs);
				}
			}
			return seriesKey;
		}
		
		private function extractObservation(obs:XML, dataSet:DataSet):TimePeriod 
		{
			var observation:Observation;
			var obsValue:String = obs.attribute(_primaryMeasureCode);
			if (_primaryMeasure is UncodedMeasure) {
				observation = new UncodedObservation(obsValue, 
					_primaryMeasure as UncodedMeasure);
			} else {
				var codeList:CodeList = 
					_primaryMeasure.localRepresentation as CodeList;
				var code:Code = codeList.codes.getCode(obsValue);
				if (null == code) {
					throw new Error("Could not find code with value '" 
						+ obsValue + "' in codelist '" + codeList.id + "'");
				}
				observation = 
					new CodedObservation(code, _primaryMeasure as CodedMeasure);
			}
			if (!_disableObservationAttribute) {
				extractAttributes(obs, observation);
			}
			return (obsValue != "NaN") ? new TimePeriod(obs.attribute(
				_timeDimensionCode), observation, _sdmxDate) : null;
		}
		
		private function extractAttributes(element:XML, 
			target:AttachableArtefact):void 
		{
			var attributes:AttributeValuesCollection = 
				new AttributeValuesCollection();
			for each (var attribute:XML in element.attributes()) {
				var attributeReference:DataAttribute = 
					_attributes.getAttribute(attribute.name());
				if (null != attributeReference) {
					var attributeValue:AttributeValue;
					if (attributeReference is CodedDataAttribute) {
						attributeValue = 
							new CodedAttributeValue(target, 
								(attributeReference.localRepresentation as 
									CodeList).codes.getCode(attribute), 
								attributeReference as CodedDataAttribute);
					} else if (attributeReference is UncodedDataAttribute) {
						attributeValue = new UncodedAttributeValue(target, 
							attribute, attributeReference as 
								UncodedDataAttribute);
					}
					attributes.addItem(attributeValue);
				}
			}
			if (attributes.length > 0) {
				target.attributeValues = attributes;
			}
		}
	}
}