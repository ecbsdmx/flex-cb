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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.reporting.dataset.AttachableArtefact;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.AttributeValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedObservation;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.Observation;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;
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
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.Measure;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.util.date.SDMXDate;

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
	 * @author Rok Povse
	 *
	 * @todo
	 * 		o Data provider info
	 * 		o DataFlow info
	 * 		o Action
	 * 		o Validity
	 * 		o Publication
	 * 		o Handling of multiple data sets. This will also have an impact on
	 * 		  the handling of key families
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
		protected var _dataSet:DataSet;
		
		/**
		 * The code for the time dimension (e.g.: TIME_PERIOD) 
		 */
		protected var _timeDimensionCode:String;
		
		/**
		 * The code for the primary measure (e.g.: OBS_VALUE) 
		 */
		protected var _primaryMeasureCode:String;
		
		/**
		 * @private 
		 */
		protected var _optimisationLevel:uint;
		
		private var _disableObservationAttribute:Boolean;
		private var _disableAllAttributes:Boolean;
		private var _data:XML;
		private var _keyFamily:KeyFamily;
		private var _sdmxDate:SDMXDate;
		private var _groups:GroupKeyDescriptorsCollection;	
		private var _dimensions:KeyDescriptor;
		private var _measures:MeasureDescriptor;	
		private var _attributes:AttributeDescriptor;		
		private var _dataSetAttributes:AttributeDescriptor;
		private var _groupAttributes:AttributeDescriptor;
		private var _seriesAttributes:AttributeDescriptor;
		private var _obsAttributes:AttributeDescriptor;		
		private var _timeDimension:Dimension;
		private var _primaryMeasure:Measure;
		private var _disableGroups:Boolean;
		private var _disableObservationsCreation:Boolean;
		private var _keyValues:Array;
		private var _attributeValues:Array; 
		private var _sort:Sort;
		
		/*============================Namespaces==============================*/
		
		/**
		 * The SDMX message namespace 
		 */
		protected var messageNS:Namespace;
		
		/**
		 * The DataSet namespace 
		 */
		protected var dataSetNS:Namespace;
		
		private static var extractedQName:QName = new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message", 
				"Extracted")
		
		/*===========================Constructor==============================*/
		
		public function DataReaderAdapter(kf:KeyFamily, 
			target:IEventDispatcher = null)
		{
			super(target);
			messageNS = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
			_sdmxDate = new SDMXDate();
			_optimisationLevel = 0;
			_sort = new Sort();
		    _sort.fields = [new SortField("periodComparator")];	
			this.keyFamily = kf;	
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
		public function set disableAllAttributes(flag:Boolean):void
		{
			_disableAllAttributes = flag;
			if (flag) {
				_disableObservationAttribute = flag;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disableGroups(flag:Boolean):void
		{
			_disableGroups = flag;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disableObservationsCreation(flag:Boolean):void
		{
			_disableObservationsCreation = flag;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function set dataFile(dataFile:XML):void
		{
			_data = dataFile;
			if (dataFile.children().length() < 2 || 
				(dataFile.children()[1] as XML).localName() != "DataSet") {
				throw new Error("No data set is available in the XML datafile");
			} else if (dataFile.children().length() > 2) {
				throw new Error("Cannot handle multiple data sets in the " + 
						"same SDMX-ML data file");
			} else {
				_data.addNamespace(messageNS);
				dataSetNS = new Namespace("dataSetNS", 
					(dataFile.children()[1] as XML).namespace());
				_data.addNamespace(dataSetNS);
			}
			prepareDataSet();
		}
				
		/**
		 * @inheritDoc
		 */ 
		public function set keyFamily(kf:KeyFamily):void
		{
			if (null == kf) {
				throw new ArgumentError("Key family cannot be null");
			}
			if (kf != _keyFamily) {
				_keyValues = new Array();
				_attributeValues = new Array();
				_keyFamily = kf;
				
				_dimensions = _keyFamily.keyDescriptor;		
				if (null == _dimensions) {
					throw new Error("No dimensions found for key family: " 
						+ _keyFamily.id);
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
				
				_measures   = _keyFamily.measureDescriptor;
				if (null == _measures) {
					throw new Error("No measures found for key family: " 
						+ _keyFamily.id);				
				}
				for each (var measure:Measure in _measures) {
					if (measure.conceptRole == ConceptRole.PRIMARY_MEASURE) {
						_primaryMeasure = measure;
						_primaryMeasureCode = 
							_primaryMeasure.conceptIdentity.id;
						break;
					}
				}
				if (_primaryMeasure == null) {
					throw new Error("Could not find primary measure");
				}
				
				if (!_disableAllAttributes) {
					_attributes = _keyFamily.attributeDescriptor;
					_dataSetAttributes = new AttributeDescriptor();
					_groupAttributes = new AttributeDescriptor();
					_seriesAttributes = new AttributeDescriptor();
					_obsAttributes = new AttributeDescriptor();
					for each (var attr:DataAttribute in _attributes) {
						switch (attr.attachmentLevel) {
							case (AttachmentLevel.DATASET):
								_dataSetAttributes.addItem(attr);
								break;
							case (AttachmentLevel.GROUP):
								_groupAttributes.addItem(attr);
								break;
							case (AttachmentLevel.SERIES):
								_seriesAttributes.addItem(attr);
								break;
							case (AttachmentLevel.OBSERVATION):
								_obsAttributes.addItem(attr);
								break;
							default:
								throw new ArgumentError(
									"Unknown attachment level");					
						}
					
					}
				}
				if (!_disableGroups) {
					_groups = _keyFamily.groupDescriptors;
				}
			}
		}
				
		/**
		 * @inheritDoc
		 */
		public function set optimisationLevel(level:uint):void
		{
			_optimisationLevel = level;
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
			var seriesCollection:XMLList = _data.dataSetNS::DataSet..*::Series;
			var groupCollection:XMLList  = _data.dataSetNS::DataSet..*::Group;	
				
			if (query != null) {
				for (var seriesDimension:Object in query) {
					seriesCollection = seriesCollection.(
						attribute(seriesDimension) == query[seriesDimension]);
					if ((_groups.getItemAt(0) as GroupKeyDescriptor).
						containsDimension(seriesDimension as String)) {	
						groupCollection = groupCollection.(
							attribute(seriesDimension) == 
								query[seriesDimension]);	
					}	
				}
			}
			
			var tmpSeriesCol:Array = new Array();
			for each (var series:XML in seriesCollection) {
				tmpSeriesCol.push(extractSeries(series));
			}
			_dataSet.timeseriesKeys = 
				new TimeseriesKeysCollection(tmpSeriesCol);
			
			if (!_disableGroups) {
				var i:uint = 0;
				var tmpGrpCol:Array = new Array();
				for each (var group:XML in groupCollection) {
					tmpGrpCol.push(extractGroup(group, i));
					i++;
				}
				_dataSet.groupKeys = new GroupKeysCollection(tmpGrpCol);
			}
			dispatchEvent(new SDMXDataEvent(_dataSet, DATASET_EVENT));
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * This method finds the series that belong to the supplied group 
		 * 
		 * @param group The group to which the series must belong
		 * @param position Position of the group, if known. This is used for
		 * performance optimisation
		 */
		protected function getMatchingSeries(group:GroupKey, 
			position:uint):void
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns an XMLList of the XML snippets representing the observations.
		 * 
		 * @param xml The XML snippet with all observations 
		 * @return XMLList of the XML snippets representing the observations.
		 */
		protected function getObservations(xml:XML):XMLList
		{
			throw new Error("This method must be implemented by subclasses");
		}
				
		/**
		 * Returns an object with the time period and the value extracted from
		 * the supplied XML. The time period will be available in a property 
		 * called "period", while the observation value will be available in a
		 * property called "value".
		 * 
		 * @param xml The XML snippet with an observation 
		 * @return An object with the time period and the value extracted from
		 * the supplied XML.
		 */
		protected function getObservation(xml:XML):Object
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns the value for the dimension identified by the supplied id.
		 * 
		 * @param xml The XML snippet with the Series/Group element.
		 * @param dimensionId The id for the dimension (e.g: FREQ or REF_AREA).
		 * 
		 * @return The value for the dimension identified by the supplied id.
		 */
		protected function getDimensionValue(xml:XML, 
			dimensionId:String):String
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns the value for the attribute identified by the supplied id.
		 * 
		 * @param xml The XML snippet with the Series/Group element.
		 * @param dimensionId The id for the attribute (e.g: FREQ or REF_AREA).
		 * 
		 * @return The value for the attribute identified by the supplied id.
		 */
		protected function getAttributeValue(xml:XML, 
			attributeId:String):String
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns the name of the group to be retrieved
		 * 
		 * @param xml The XML snippet with the Group element
		 *  
		 * @return The name of the group to be retrieved
		 */
		protected function getGroupName(xml:XML):String
		{
			return xml.localName();
		}
		
		/*==========================Private methods===========================*/
		
		private function prepareDataSet():void 
		{
			_dataSet = new DataSet();			
			
			if (_data.dataSetNS::DataSet.hasOwnProperty("@reportingBeginDate")){
				_dataSet.reportingBeginDate = 
					_sdmxDate.getDate(
						_data.dataSetNS::DataSet.@reportingBeginDate);
			}
			if (_data.dataSetNS::DataSet.hasOwnProperty("@reportingEndDate")) {
				_dataSet.reportingEndDate = 
					_sdmxDate.getDate(
						_data.dataSetNS::DataSet.@reportingEndDate);
			}
			if (_data.messageNS::Header.child(extractedQName).length() > 0) {
				_dataSet.dataExtractionDate =
					_sdmxDate.getDate(
						String(_data.messageNS::Header.messageNS::Extracted));
			}
			dispatchEvent(new Event(INIT_READY));	
		}
		
		private function extractSeries(xml:XML):TimeseriesKey 
		{
			var series:TimeseriesKey = new TimeseriesKey(_dimensions);
			series.keyValues         = handleDimensions(xml);
			if (!_disableAllAttributes) {
				series.attributeValues   = handleAttributes(xml, series, 
					AttachmentLevel.SERIES);
			}
			series.timePeriods = (_disableObservationsCreation ?
				extractObservations(xml, extractLightObservation) :
				extractObservations(xml, extractFullObservation));
		  	series.timePeriods.sort = _sort;
			series.timePeriods.refresh();
			return series;
		}
		
		private function extractGroup(xml:XML, position:uint):GroupKey 
		{			
			var targetGroup:GroupKeyDescriptor = 
				_groups.getGroup(getGroupName(xml));
			if (null == targetGroup) {
				throw new Error("Could not find group with key: " + 
					groupDimensions.seriesKey);
			}
			
			var groupDimensions:KeyValuesCollection = 
				handleDimensions(xml, targetGroup);			
			var group:GroupKey = new GroupKey(targetGroup);
			group.keyValues = groupDimensions;
			if (!_disableAllAttributes) {
				group.attributeValues = handleAttributes(xml, group, 
					AttachmentLevel.GROUP);
			}
			getMatchingSeries(group, position);	
			return group;
		}
		
		private function extractObservations(xml:XML, 
			method:Function):TimePeriodsCollection 
		{
			var tmpCol:Array = new Array();
			for each (var observation:XML in getObservations(xml)) {
				var obs:TimePeriod = method(observation);
				if (null != obs) {
					tmpCol.push(obs);
				}
			}
			return new TimePeriodsCollection(tmpCol);
		}
		
		private function handleDimensions(xml:XML, 
			groupDimensions:GroupKeyDescriptor = null):KeyValuesCollection 
		{
			var values:Array = new Array();
			var keys:ArrayCollection = 
				(null == groupDimensions ? _dimensions : groupDimensions);
			var code:Code;	
			var value:String;
			var dimensionId:String;
			for each (var dimension:Dimension in keys) {
				if (dimension.conceptRole != ConceptRole.TIME) {
					dimensionId = dimension.id;
					value = getDimensionValue(xml, dimensionId);
					if (_keyValues[dimensionId] != null &&
						_keyValues[dimensionId][value] != null ) {
						values.push(_keyValues[dimensionId][value]);
					} else {
						if (_keyValues[dimensionId] == null ) {
							_keyValues[dimensionId] = new Array();
						}
						code = (dimension.localRepresentation as CodeList).
							codes.getCode(value);
						if (null == code) {
							throw new Error("Could not find value for " + 
								dimensionId);
						}
						_keyValues[dimensionId][value] = 
							new KeyValue((dimension.localRepresentation as 
							CodeList).codes.getCode(value), dimension);
						values.push(_keyValues[dimensionId][value]);	
					}
				}
			} 
			return new KeyValuesCollection(values);
		}
		
		private function handleAttributes(xml:XML, 
			target:AttachableArtefact, 
			attachmentLevel:String):AttributeValuesCollection 
		{
			var attributes:Array = new Array();
			var descriptor:AttributeDescriptor;
			switch (attachmentLevel) {
				case (AttachmentLevel.DATASET):
					descriptor = _dataSetAttributes;
					break;
				case (AttachmentLevel.GROUP):
					descriptor = _groupAttributes;
					break;
				case (AttachmentLevel.SERIES):
					descriptor = _seriesAttributes;
					break;
				case (AttachmentLevel.OBSERVATION):
					descriptor = _obsAttributes;
					break;
				default:
					throw new ArgumentError("Unknown attachment level");					
			}	
			var attributeValue:AttributeValue;
			var value:String;
			for each (var attribute:DataAttribute in descriptor) {
				value = getAttributeValue(xml, attribute.id);
				if ("" != value) {
					if (_attributeValues[attribute.id] != null &&
						_attributeValues[attribute.id][value] != null) {
						attributes.push(
						_attributeValues[attribute.id][value]);
					} else {
						if (_attributeValues[attribute.id] == null) {
							_attributeValues[attribute.id] = new Array();
						}
						if (attribute is CodedDataAttribute) {
							attributeValue = new CodedAttributeValue(target, 
								(attribute.localRepresentation as CodeList).codes.
								getCode(value), 
								attribute as CodedDataAttribute);
						} else if (attribute is UncodedDataAttribute) {
							attributeValue = new UncodedAttributeValue(target, 
								value, attribute as UncodedDataAttribute);
						}
						_attributeValues[attribute.id][value] = attributeValue;
						attributes.push(attributeValue);
					}					
				}
			}
			return new AttributeValuesCollection(attributes);
		}
		
		private function extractFullObservation(xml:XML):TimePeriod
		{
			var observation:Observation;
			var result:Object = getObservation(xml);
			if (result["value"] != "NaN") {
				if (_primaryMeasure is UncodedMeasure) {
					observation = new UncodedObservation(result["value"], 
						_primaryMeasure as UncodedMeasure);
				} else {
					var codeList:CodeList = 
						_primaryMeasure.localRepresentation as CodeList;
					var code:Code = codeList.codes.getCode(result["value"]);
					if (null == code) {
						throw new Error("Could not find code with value '" 
							+ result["value"] + "' in codelist '" 
							+ codeList.id + "'");
					}
					observation = new CodedObservation(code, 
						_primaryMeasure as CodedMeasure);
				}
				if (!_disableObservationAttribute) {
					observation.attributeValues = 
						handleAttributes(xml, observation, 
							AttachmentLevel.OBSERVATION);
				}
				return new TimePeriod(result["period"], observation, _sdmxDate);
			}
			return null;
		}
		
		private function extractLightObservation(xml:XML):TimePeriod
		{
			var result:Object = getObservation(xml);
			if (result["value"] != "NaN") {
				return new TimePeriod(result["period"], result["value"], 
					_sdmxDate);			
			} else {
				return null;
			}
		}
	}
}