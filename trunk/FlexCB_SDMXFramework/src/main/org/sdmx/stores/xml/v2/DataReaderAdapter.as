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
	
	import org.sdmx.event.SDMXDataEvent;
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
		protected var _disableObservationAttribute:Boolean;
		
		/**
		 * @private 
		 */
		protected var _data:XML;
		
		/**
		 * @private 
		 */
		protected var _keyFamily:KeyFamily;
		
		/**
		 * @private 
		 */
		protected var _dataSet:DataSet;
		
		/**
		 * The class responsible for parsing ISO 8601 dates 
		 */
		protected var _sdmxDate:SDMXDate;
		
		/**
		 * The collection of groups defined in the key family 
		 */
		protected var _groups:GroupKeyDescriptorsCollection;	
		
		/**
		 * The list of dimensions defined in the key family 
		 */
		protected var _dimensions:KeyDescriptor;
		
		/**
		 * The list of measures defined in the key family 
		 */
		protected var _measures:MeasureDescriptor;	
		
		/**
		 * The list of attributes defined in the key family  
		 */
		protected var _attributes:AttributeDescriptor;
		
		/**
		 * The time dimension defined in the key family 
		 */
		protected var _timeDimension:Dimension;
		
		/**
		 * The code for the time dimension (e.g.: TIME_PERIOD) 
		 */
		protected var _timeDimensionCode:String;
		
		/**
		 * The primary measure defined in the key family 
		 */
		protected var _primaryMeasure:Measure;
		
		/**
		 * The code for the primary measure (e.g.: OBS_VALUE) 
		 */
		protected var _primaryMeasureCode:String;
		
		/**
		 * @private 
		 */
		protected var _optimisationLevel:uint;
		
		/*============================Namespaces==============================*/
		
		/**
		 * The SDMX message namespace 
		 */
		protected var messageNS:Namespace;
		
		/**
		 * The DataSet namespace 
		 */
		protected var dataSetNS:Namespace;
		
		/*===========================Constructor==============================*/
		
		public function DataReaderAdapter(kf:KeyFamily, 
			target:IEventDispatcher = null)
		{
			super(target);
			messageNS = new Namespace("message", 
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message");
			_sdmxDate = new SDMXDate();	
			this.keyFamily = kf;	
			_optimisationLevel = 0;
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
		public function get disableObservationAttribute():Boolean
		{
			return _disableObservationAttribute;
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
		public function get dataFile():XML
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set keyFamily(kf:KeyFamily):void
		{
			if (null == kf) {
				throw new ArgumentError("Key family is needed to interpret" + 
						" the data!");
			}
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
					_primaryMeasureCode = _primaryMeasure.conceptIdentity.id;
					break;
				}
			}
			if (_primaryMeasure == null) {
				throw new Error("Could not find primary measure");
			}
			
			_attributes = _keyFamily.attributeDescriptor;
			_groups     = _keyFamily.groupDescriptors;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get keyFamily():KeyFamily
		{
			return _keyFamily;
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
			
			for each (var series:XML in seriesCollection) {
				_dataSet.timeseriesKeys.addItem(extractSeries(series));
			}
			
			var i:uint = 0;
			for each (var group:XML in groupCollection) {
				_dataSet.groupKeys.addItem(extractGroup(group, i));
				i++;
			}

			dispatchEvent(new SDMXDataEvent(_dataSet, DATASET_EVENT));
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * This method makes sure all necessary information are available in
		 * the key family. It also extracts the data set level attributes.  
		 */
		protected function prepareDataSet():void 
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
			if (_data.messageNS::Header.child(new QName(
				"http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message", 
				"Extracted")).length() > 0) {
				_dataSet.dataExtractionDate =
					_sdmxDate.getDate(
						String(_data.messageNS::Header.messageNS::Extracted));
			}
			dispatchEvent(new Event(INIT_READY));	
		}
		
		/**
		 * This method extracts the group out of the supplied XML snippet.
		 * 
		 * @param xml The XML snippet from which the time series will be 
		 * extracted
		 * @param position Position of the group, if known. This is used for
		 * performance optimisation
		 * @return The extracted groups
		 */
		protected function extractGroup(xml:XML, position:uint):GroupKey 
		{			
			var targetGroup:GroupKeyDescriptor = 
				_groups.getGroup(xml.localName());
			if (null == targetGroup) {
				throw new Error("Could not find group with key: " + 
					groupDimensions.seriesKey);
			}
			
			var allDimensions:KeyValuesCollection = handleDimensions(xml);
			var groupDimensions:KeyValuesCollection = new KeyValuesCollection();
			for each (var dimension:KeyValue in allDimensions) {
				if (targetGroup.containsDimension(
					dimension.valueFor.conceptIdentity.id)) {
					groupDimensions.addItem(dimension);	
				}
			} 
			
			var group:GroupKey = new GroupKey(targetGroup);
			group.keyValues = groupDimensions;
			group.attributeValues = handleAttributes(xml, group);
			findMatchingSeries(group, position);	
			return group;
		}
		
		/**
		 * This method extracts the time series out of the supplied XML snippet.  
		 * 
		 * @param xml The XML snippet from which the time series will be 
		 * extracted 
		 * @return The extracted time series
		 */
		protected function extractSeries(xml:XML):TimeseriesKey 
		{
			var series:TimeseriesKey = new TimeseriesKey(_dimensions);
			series.keyValues         = handleDimensions(xml);
			series.attributeValues   = handleAttributes(xml, series);
			series.timePeriods       = handleObservations(xml);
			return series;
		}
		
		/**
		 * This method extracts the dimensions out of the supplied XML snippet.
		 * 
		 * @param xml The XML snippet from which the dimensions will be 
		 * extracted
		 * @return A collection with the extracted dimension values
		 */
		protected function handleDimensions(xml:XML):KeyValuesCollection 
		{
			var values:KeyValuesCollection = new KeyValuesCollection();
			for each (var element:XML in findDimensions(xml)) {
				var dimension:Dimension = 
					_dimensions.getDimension(element.localName());
				if (null != dimension) {
					var code:Code = (dimension.localRepresentation as 
						CodeList).codes.getCode(element);
					if (null == code) {
						throw new Error("Could not find value '" + element);
					}
					values.addItem(new KeyValue(code, dimension));
				}
			}
			return values;
		}
		
		/**
		 * This method extracts the series attributes out of the supplied XML 
		 * snippet.
		 * 
		 * @param xml The XML snippet from which the attributes will be 
		 * extracted 
		 * @param target The attachable target to which the attribute will be 
		 * attached
		 * @return A collection with the extracted attributes values
		 */
		protected function handleAttributes(xml:XML, 
			target:AttachableArtefact):AttributeValuesCollection 
		{
			var attributes:AttributeValuesCollection = 
				new AttributeValuesCollection();
			for each (var attribute:XML in findAttributes(xml)) {
				var attributeReference:DataAttribute = 
					_attributes.getAttribute(attribute.name());
				if (null != attributeReference) {
					var attributeValue:AttributeValue;
					if (attributeReference is CodedDataAttribute) {
						attributeValue = new CodedAttributeValue(target, 
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
			return attributes;
		}
		
		/**
		 * This method extracts the series observations out of the supplied XML 
		 * snippet.
		 * 
		 * @param xml The XML snippet from which the observations will be 
		 * extracted 
		 * @return The collection of extracted observations
		 */
		protected function handleObservations(xml:XML):TimePeriodsCollection 
		{
			var observations:TimePeriodsCollection = 
				new TimePeriodsCollection();
			for each (var observation:XML in findObservations(xml)) {
				var obs:TimePeriod = extractObservation(observation);
				if (null != obs) {
					observations.addItem(obs);
				}
			}
			return observations;
		}
		
		
		/**
		 * This method extracts an observation out of the supplied XML snippet.
		 * 
		 * @param xml The XML snippet from which the observation will be 
		 * extracted
		 * @return The SDMX observation
		 */
		protected function extractObservation(xml:XML):TimePeriod
		{
			var observation:Observation;
			var result:Object = findObservation(xml);
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
				observation = 
					new CodedObservation(code, _primaryMeasure as CodedMeasure);
			}
			if (!_disableObservationAttribute) {
				observation.attributeValues = 
					handleAttributes(xml, observation);
			}
			return (result["value"] != "NaN") ? new TimePeriod(result["period"], 
				observation, _sdmxDate) : null;
		}
		
		/**
		 * This method finds the series that belong to the supplied group 
		 * 
		 * @param group The group to which the series must belong
		 * @param position Position of the group, if known. This is used for
		 * performance optimisation
		 */
		protected function findMatchingSeries(group:GroupKey, 
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
		protected function findObservations(xml:XML):XMLList
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns an XMLList of the XML snippets representing the dimensions.
		 * 
		 * @param xml The XML snippet with all dimensions 
		 * @return XMLList of the XML snippets representing the dimensions.
		 */
		protected function findDimensions(xml:XML):XMLList
		{
			throw new Error("This method must be implemented by subclasses");
		}
		
		/**
		 * Returns an XMLList of the XML snippets representing the attributes.
		 * 
		 * @param xml The XML snippet with all attributes 
		 * @return XMLList of the XML snippets representing the attributes.
		 */
		protected function findAttributes(xml:XML):XMLList
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
		protected function findObservation(xml:XML):Object
		{
			throw new Error("This method must be implemented by subclasses");
		}
	}
}