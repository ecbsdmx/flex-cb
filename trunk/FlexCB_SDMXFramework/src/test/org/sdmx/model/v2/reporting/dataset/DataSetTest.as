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
package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;

	/**
	 * @private
	 */
	public class DataSetTest extends TestCase
	{
		public function DataSetTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(DataSetTest);
		}
		
		public function testSetAndGetReportingBeginDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:DataSet = new DataSet();
			dataSet.reportingBeginDate = date;
			assertEquals("The begin dates should be equal", date, dataSet.reportingBeginDate);
		}
		
		public function testSetAndGetReportingEndDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:DataSet = new DataSet();
			dataSet.reportingEndDate = date;
			assertEquals("The end dates should be equal", date, dataSet.reportingEndDate);
		}
		
		public function testSetWrongReportingDates():void {
			var beginDate:Date = new Date(2007, 5, 22);
			var endDate:Date = new Date(2007, 5, 15);
			var dataSet:DataSet = new DataSet();
			dataSet.reportingBeginDate = beginDate;
			try {
				dataSet.reportingEndDate = endDate;
				fail("The end date cannot be before the begin date");
			} catch (error:ArgumentError) {}
			endDate = new Date(2007, 5, 29);
			dataSet.reportingEndDate = endDate;
			beginDate = new Date(2007, 5, 30);
			try {
				dataSet.reportingBeginDate = beginDate;
				fail("The begin date cannot be after the end date");
			} catch (error:ArgumentError) {}
			beginDate = new Date(2007, 5, 22);
			dataSet.reportingBeginDate = beginDate;
			assertEquals("The begin dates should be equal", beginDate, dataSet.reportingBeginDate);
			assertEquals("The end dates should be equal", endDate, dataSet.reportingEndDate);
		}
		
		public function testSetAndGetDataExtractionDate():void {
			var date:Date = new Date(2007, 5, 22);
			var dataSet:DataSet = new DataSet();
			dataSet.dataExtractionDate = date;
			assertEquals("The end dates should be equal", date, dataSet.dataExtractionDate);
		}
		
		public function testSetAndGetDescribedBy():void {
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var dataflow:DataflowDefinition = new DataflowDefinition("test", 
				new InternationalString(), new MaintenanceAgency("ECB"), 
				new KeyFamily("ECB_EXR", new InternationalString(), 
				new MaintenanceAgency("ECB"), key, measure));
			var dataSet:DataSet = new DataSet();	
			dataSet.describedBy = dataflow;
			assertEquals("The dataflow definitions should be equal", dataflow, 
				dataSet.describedBy);						
		}
		
		public function testSetAndGetGroupKeys():void {
			var groups:GroupKeysCollection = new GroupKeysCollection();
			var groupDescriptor:GroupKeyDescriptor = new GroupKeyDescriptor("Test");
			groups.addItem(new GroupKey(groupDescriptor));
			groups.addItem(new GroupKey(groupDescriptor));
			var dataSet:DataSet = new DataSet();
			dataSet.groupKeys = groups;
			assertEquals("Collections should be equal", groups, dataSet.groupKeys);
		}
		
		public function testSetAndGetTimeseriesKeys():void {
			var keys:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var keyDescriptor:KeyDescriptor = new KeyDescriptor("test");
			keys.addItem(new TimeseriesKey(keyDescriptor));
			keys.addItem(new TimeseriesKey(keyDescriptor));
			var dataSet:DataSet = new DataSet();
			dataSet.timeseriesKeys = keys;
			assertEquals("Collections should be equal", keys, dataSet.timeseriesKeys);
		}
		
		public function testSetAndGetAttributeValues():void {
			var dataSet:DataSet = new DataSet();
			var attributes:AttributeValuesCollection 
				= new AttributeValuesCollection();
			attributes.addItem(new AttributeValue(dataSet));
			attributes.addItem(new AttributeValue(dataSet));
			dataSet.attributeValues = attributes;
			assertEquals("Collections should be equal", attributes, dataSet.attributeValues);
		}
	}
}