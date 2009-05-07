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
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.code.Code;

	/**
	 * @private
	 */
	public class TimeseriesKeyTest extends KeyTest
	{
		public function TimeseriesKeyTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(TimeseriesKeyTest);
		}
		
		public function testConstructor():void {
			var descriptor:KeyDescriptor = new KeyDescriptor("key");
			var seriesKey:TimeseriesKey = new TimeseriesKey(descriptor);
			assertEquals("The valueFor should be equal", descriptor, seriesKey.valueFor);
			try {
				seriesKey = new TimeseriesKey(null);
				fail("The key descriptor cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			var descriptor:KeyDescriptor = new KeyDescriptor("key");
			var seriesKey:TimeseriesKey = new TimeseriesKey(descriptor);
			assertEquals("The valueFor should be equal", descriptor, seriesKey.valueFor);
			var descriptor2:KeyDescriptor = new KeyDescriptor("new key");
			seriesKey.valueFor = descriptor2;
			assertEquals("The valueFor should be equal", descriptor2, seriesKey.valueFor);
			try {
				seriesKey.valueFor = null;
				fail("The key descriptor cannot be set to null");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddAndGetTimePeriods():void {
			var collection:TimePeriodsCollection = new TimePeriodsCollection();
			collection.addItem(new TimePeriod("1980-11-13", new UncodedObservation("1.25", new UncodedMeasure("obs1", new Concept("OBS_VALUE")))));			
			collection.addItem(new TimePeriod("1980-11-13", new UncodedObservation("1.37", new UncodedMeasure("obs2", new Concept("OBS_VALUE")))));			
			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.timePeriods = collection;
			assertEquals("The collections should be equal", collection, key.timePeriods);
		}
		
		public function testBelongsToGroup():void {
			var dim0:Dimension = new Dimension("dim0", new Concept("FREQ"));
			var dim1:Dimension = new Dimension("dim1", new Concept("CURRENCY"));
			var dim2:Dimension = new Dimension("dim2", new Concept("CURRENCY_DENOM"));
			var dim3:Dimension = new Dimension("dim3", new Concept("EXR_TYPE"));
			var dim4:Dimension = new Dimension("dim4", new Concept("EXR_SUFFIX"));
			var groupKeyValues1:KeyValuesCollection = new KeyValuesCollection();
			groupKeyValues1.addItem(new KeyValue(new Code("RUB"), dim1));
			groupKeyValues1.addItem(new KeyValue(new Code("EUR"), dim2));
			groupKeyValues1.addItem(new KeyValue(new Code("S"), dim3));
			groupKeyValues1.addItem(new KeyValue(new Code("A"), dim4));
			var groupKeyValues2:KeyValuesCollection = new KeyValuesCollection();
			groupKeyValues2.addItem(new KeyValue(new Code("USD"), dim1));
			groupKeyValues2.addItem(new KeyValue(new Code("EUR"), dim2));
			groupKeyValues2.addItem(new KeyValue(new Code("S"), dim3));
			groupKeyValues2.addItem(new KeyValue(new Code("A"), dim4));
			var seriesKeyValues:KeyValuesCollection = new KeyValuesCollection();
			seriesKeyValues.addItem(new KeyValue(new Code("D"), dim0));
			seriesKeyValues.addItem(new KeyValue(new Code("RUB"), dim1));
			seriesKeyValues.addItem(new KeyValue(new Code("EUR"), dim2));
			seriesKeyValues.addItem(new KeyValue(new Code("S"), dim3));
			seriesKeyValues.addItem(new KeyValue(new Code("A"), dim4));
			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = seriesKeyValues;
			assertTrue("The series should belong to the 1st group", key.belongsToGroup(groupKeyValues1));
			assertFalse("The series should not belong to the 2nd group", key.belongsToGroup(groupKeyValues2));
		}
		
		public function testSiblingGroupKey():void
		{
			var dim0:Dimension = new Dimension("dim0", new Concept("FREQ"));
			var dim1:Dimension = new Dimension("dim1", new Concept("CURRENCY"));
			var dim2:Dimension = new Dimension("dim2", new Concept("CURRENCY_DENOM"));
			var dim3:Dimension = new Dimension("dim3", new Concept("EXR_TYPE"));
			var dim4:Dimension = new Dimension("dim4", new Concept("EXR_SUFFIX"));
			var seriesKeyValues:KeyValuesCollection = new KeyValuesCollection();
			seriesKeyValues.addItem(new KeyValue(new Code("D"), dim0));
			seriesKeyValues.addItem(new KeyValue(new Code("RUB"), dim1));
			seriesKeyValues.addItem(new KeyValue(new Code("EUR"), dim2));
			seriesKeyValues.addItem(new KeyValue(new Code("S"), dim3));
			seriesKeyValues.addItem(new KeyValue(new Code("A"), dim4));
			var key:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id"));
			key.keyValues = seriesKeyValues;
			assertEquals("The group keys should be equal", "RUB.EUR.S.A", 
				key.siblingGroupKey);
			assertTrue("Should belong to RUB group", 
				key.belongsToSiblingGroup("RUB.EUR.S.A"));
			assertFalse("Should not belong to USD group", 
				key.belongsToSiblingGroup("USD.EUR.S.A"));		
		}
	}
}