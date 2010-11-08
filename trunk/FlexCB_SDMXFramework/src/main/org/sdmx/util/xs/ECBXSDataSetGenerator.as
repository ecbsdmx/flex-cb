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
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.SectionsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSGroupsCollection;
	import org.sdmx.model.v2.reporting.dataset.XSObservationsCollection;
	import org.sdmx.model.v2.structure.code.Code;
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
	 * @author Rok Povse
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
				
			//Perf: To be done only if DSD is different	
			for each (var dim:Dimension in dsd.keyDescriptor) {
				if (dim.xsAttachmentLevel == XSAttachmentLevel.GROUP) {
					groupKey.addItem(dim);
				} else if (dim.xsAttachmentLevel == XSAttachmentLevel.SECTION) {
					sectionKey.addItem(dim);
				}
			} 
						
			//Fetches the concept identity for the measure
			//Perf: To be done only if measure changes
			var matchingDimension:Dimension = dsd.keyDescriptor.getDimension(
				measureDimension.conceptIdentity.id) as Dimension;
			measureDimension.conceptIdentity = 
				matchingDimension.conceptIdentity;
			measureDimension.localRepresentation = dsd.keyDescriptor.
				getDimension(matchingDimension.conceptIdentity.id).
				localRepresentation;
						
			// Create the basic dataset
			var xsDataSet:XSDataSet = new XSDataSet();
			
			// Create the group
			var group:XSGroup = new XSGroup();
			var groupValues:KeyValuesCollection = new KeyValuesCollection();
			var series:TimeseriesKey = dataSet.timeseriesKeys.getItemAt(0) 
				as TimeseriesKey;
			
			//Perf: Can be optimised for sibling groups. No need to search for position
			for each (var groupDim:Dimension in groupKey) {
				var value:KeyValue;
				if (groupDim.conceptRole == ConceptRole.TIME) {
					value = new KeyValue(new Code(date), groupDim);
				} else {
					value = series.keyValues.getItemAt(series.valueFor.
						getItemIndex(groupDim)) as KeyValue;	
				}
				groupValues.addItem(value);
			}
			group.keyValues = groupValues;
			group.valueFor = groupKey;
			var groups:XSGroupsCollection = new XSGroupsCollection();
			groups.addItem(group);
			xsDataSet.groups = groups;
			
			// Create the sections
			var sectionKeys:Array = new Array();
			var sections:SectionsCollection = new SectionsCollection();
			var key:String = "";
			var sectionValues:KeyValuesCollection;
			var measureDimensionCode:Code;	
			var kvId:String;
			var obs:TimePeriod;
			var measure:UncodedXSMeasure;
			var observations:XSObservationsCollection;
			var kv:KeyValue;
			var tmpXSOBs:Array = new Array();
			for each (var s:TimeseriesKey in dataSet.timeseriesKeys) {
				key = "";
				sectionValues = new KeyValuesCollection();
				for each (kv in s.keyValues) {
					kvId = kv.valueFor.conceptIdentity.id;
					if (null != sectionKey.getDimension(kvId) &&
						kvId != measureDimension.conceptIdentity.id) {
						key = key + kv.value.id + ".";
						 sectionValues.addItem(kv); 	
					} else if (kvId == measureDimension.conceptIdentity.id && 
						null == measureDimensionCode) {
						measureDimensionCode = kv.value;	
					}
				}
				
				if (!(null != sectionKeys[key])) {		
					var section:Section = new Section();
					section.keyValues = sectionValues;
					section.valueFor = sectionKey;
					sections.addItem(section);
					sectionKeys[key] = section;
					tmpXSOBs[key] = new Array();
				} 
				
				//Create the observations
				obs = (s.timePeriods.length==1 && (s.timePeriods.
					getItemAt(0) as TimePeriod).periodComparator==date)?
					s.timePeriods.getItemAt(0) as TimePeriod:
					s.timePeriods.getTimePeriod(date);
				if (null != obs) {
					measure = new UncodedXSMeasure(
						"xsMeasure", measureDimension.conceptIdentity, 
						measureDimensionCode, measureDimension);
					
					(tmpXSOBs[key] as Array).push(new UncodedXSObservation(
						obs.observationValue, measure));
					
				}
				measureDimensionCode = null;
			}
			
			for (var obsKey:String in tmpXSOBs) {
				(sectionKeys[obsKey] as Section).observations =
				new XSObservationsCollection(tmpXSOBs[obsKey]);
			}
			
			group.sections = sections;
			return xsDataSet;
		}
	}
}