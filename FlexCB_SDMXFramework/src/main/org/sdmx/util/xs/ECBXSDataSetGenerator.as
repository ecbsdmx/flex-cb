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
package org.sdmx.util.xs
{
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.base.type.XSAttachmentLevel;
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.AttributeValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.SectionsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSGroupsCollection;
	import org.sdmx.model.v2.reporting.dataset.XSObservationsCollection;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.keyfamily.AttributeDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.DataAttribute;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureTypeDimension;
	import org.sdmx.model.v2.structure.keyfamily.UncodedXSMeasure;

	/**
	 * Converts a time-series data set into a cross-sectional data set,
	 * according to the conventions used at the ECB.
	 * 
	 * <p>This converter will only work under certain limited conditions, which 
	 * are the ones in use for ECB data flows. Among others, the following 
	 * limitations apply:</p>
	 * 
	 * <ul>
	 * <li>All attributes, regardless of the attachment level, are ignored and 
	 * will therefore not be available in the cross-sectional dataset.</li>
	 * <li>Dimensions attached at the XSDataSet and XSObservation levels are
	 * ignored.</li>
	 * <li>On the XSGroup level, only the dimensions that play the role of time
	 * and frequency will be available. All other dimensions are ignored.</li>
	 * <li>Mixing series with different frequencies will have unpredictable 
	 * results.</li>
	 * </ul>
	 *  
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */
	public class ECBXSDataSetGenerator implements IXSDataSetGenerator
	{
		/*===========================Constructor==============================*/
		
		public function ECBXSDataSetGenerator()
		{
			super();
		}
		
		/*==========================Public methods============================*/

		/**
		 * @inheritDoc
		 */ 
		public function convertToXSDataSet(dataSet:DataSet, dsd:KeyFamily, 
			date:String, measureDimension:MeasureTypeDimension):XSDataSet
		{
			//Process the key family information
			var groupKey:KeyDescriptor = new KeyDescriptor("groupKey");
			var sectionKey:KeyDescriptor = new KeyDescriptor("sectionKey");
		
			var dsAttrs:AttributeDescriptor = 
				new AttributeDescriptor("dsAttrs");
			var groupAttrs:AttributeDescriptor = 
				new AttributeDescriptor("groupAttrs");
			var sectionAttrs:AttributeDescriptor = 
				new AttributeDescriptor("sectionAttrs");
			var obsAttrs:AttributeDescriptor = 
				new AttributeDescriptor("obsAttrs");	 		
			
			for each (var dim:Dimension in dsd.keyDescriptor) {
				if (dim.xsAttachmentLevel == XSAttachmentLevel.GROUP) {
					groupKey.addItem(dim);
				} else if (dim.xsAttachmentLevel == XSAttachmentLevel.SECTION) {
					sectionKey.addItem(dim);
				}
			} 
			
			for each (var attr:DataAttribute in dsd.attributeDescriptor) {
				if (attr.xsAttachmentLevel == XSAttachmentLevel.XSDATASET) {
					dsAttrs.addItem(attr);
				} else if (attr.xsAttachmentLevel == XSAttachmentLevel.GROUP) {
					groupAttrs.addItem(attr);
				} else if (attr.xsAttachmentLevel == XSAttachmentLevel.SECTION){
					sectionAttrs.addItem(attr);
				} else if (attr.xsAttachmentLevel == 
					XSAttachmentLevel.XSOBSERVATION) {
					obsAttrs.addItem(attr);
				}
			}
			
			//Fetches the concept identity for the measure
			measureDimension.conceptIdentity = dsd.keyDescriptor.getDimension(
				measureDimension.conceptIdentity.id).conceptIdentity;
			measureDimension.localRepresentation = dsd.keyDescriptor.
				getDimension(measureDimension.conceptIdentity.id).
				localRepresentation;
						
			// Create the basic dataset
			var xsDataSet:XSDataSet = new XSDataSet();
			xsDataSet.dataExtractionDate = dataSet.dataExtractionDate;
			xsDataSet.describedBy = dataSet.describedBy;
			xsDataSet.reportingBeginDate = dataSet.reportingBeginDate;
			xsDataSet.reportingEndDate = dataSet.reportingEndDate;
			
			// Create the group
			var group:XSGroup = new XSGroup();
			var groupValues:KeyValuesCollection = new KeyValuesCollection();
			var series:TimeseriesKey = dataSet.timeseriesKeys.getItemAt(0) 
				as TimeseriesKey;
			
			for each (var groupDim:Dimension in groupKey) {
				var value:KeyValue;
				if (groupDim.conceptRole == ConceptRole.TIME) {
					value = new KeyValue(new Code(date), groupDim);
				} else {
					value = series.keyValues.getItemAt(series.valueFor.
						getItemIndex(series.valueFor.
						getDimension(groupDim.conceptIdentity.id))) as KeyValue;	
				}
				groupValues.addItem(value);
			}
			group.keyValues = groupValues;
			group.valueFor = groupKey;
			var groups:XSGroupsCollection = new XSGroupsCollection();
			groups.addItem(group);
			xsDataSet.groups = groups;
			
			// Create the sections
			var sectionKeys:Object = new Object();
			var sections:SectionsCollection = new SectionsCollection();
			var seriesToSections:Object = new Object();
			var sectionAttrsValue:AttributeValuesCollection =
				new AttributeValuesCollection();
			var obsAttrsValue:AttributeValuesCollection = 
				new AttributeValuesCollection();
			for each (var s:TimeseriesKey in dataSet.timeseriesKeys) {
				var key:String = "";
				var sectionValues:KeyValuesCollection = 
					new KeyValuesCollection();
				var measureDimensionCode:Code;	
				for each (var kv:KeyValue in s.keyValues) {
					if (null != sectionKey.getDimension(kv.valueFor.
						conceptIdentity.id) && kv.valueFor.conceptIdentity.id !=
						measureDimension.conceptIdentity.id) {
						key = key + kv.value.id + ".";
						 sectionValues.addItem(kv); 	
					}
					if (null == measureDimensionCode && 
						kv.valueFor.conceptIdentity.id == 
							measureDimension.conceptIdentity.id) {
						measureDimensionCode = kv.value;	
					}
				}
				
				if (!(sectionKeys.hasOwnProperty(key))) {		
					sectionAttrsValue = new AttributeValuesCollection();
							
					for each (var seriesAttr:AttributeValue in 
						s.attributeValues) {
						var id:String = (seriesAttr is CodedAttributeValue) ?
							(seriesAttr as CodedAttributeValue).valueFor.
								conceptIdentity.id :
							(seriesAttr as UncodedAttributeValue).valueFor.
								conceptIdentity.id ;	
						if (null != sectionAttrs.getAttribute(id)) {
							sectionAttrsValue.addItem(seriesAttr);	
						} else if (null != obsAttrs.getAttribute(id)) {
							obsAttrsValue.addItem(seriesAttr);
						}
					}
					var section:Section = new Section();
					section.keyValues = sectionValues;
					section.valueFor = sectionKey;
					section.attributeValues = sectionAttrsValue;
					sections.addItem(section);
					sectionKeys[key] = section;
				} 
				
				//Create the observations
				var obs:TimePeriod = s.timePeriods.getTimePeriod(date);
				if (null != obs) {
					obsAttrsValue = new AttributeValuesCollection();
					var measure:UncodedXSMeasure = new UncodedXSMeasure(
						"xsMeasure", measureDimension.conceptIdentity, 
						measureDimensionCode, measureDimension);
					var xsObs:UncodedXSObservation = new UncodedXSObservation(
						obs.observationValue, measure);
					if (null == (sectionKeys[key] as Section).observations) {
						(sectionKeys[key] as Section).observations = 
							new XSObservationsCollection();
					}	 
					
					for each (var obsAttr:AttributeValue in 
						obs.observation.attributeValues) {
						var id2:String = (obsAttr is CodedAttributeValue) ?
							(obsAttr as CodedAttributeValue).valueFor.
								conceptIdentity.id :
							(obsAttr as UncodedAttributeValue).valueFor.
								conceptIdentity.id ;	
						if (null != sectionAttrs.getAttribute(id2)) {
							sectionAttrsValue.addItem(obsAttr);	
						} else if (null != obsAttrs.getAttribute(id2)) {
							obsAttrsValue.addItem(obsAttr);
						}
					}
					for each (var seriesAttr:AttributeValue in 
						s.attributeValues) {
						var id:String = (seriesAttr is CodedAttributeValue) ?
							(seriesAttr as CodedAttributeValue).valueFor.
								conceptIdentity.id :
							(seriesAttr as UncodedAttributeValue).valueFor.
								conceptIdentity.id ;	
						if (null != obsAttrs.getAttribute(id)) {
							obsAttrsValue.addItem(seriesAttr);
						}
					}
					xsObs.attributeValues = obsAttrsValue;
					
					(sectionKeys[key] as Section).observations.addItem(xsObs);
				}
				measureDimensionCode = null;
			}
			group.sections = sections;

			return xsDataSet;
		}
	}
}