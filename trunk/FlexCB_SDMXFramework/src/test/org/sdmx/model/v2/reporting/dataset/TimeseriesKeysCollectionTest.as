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
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class TimeseriesKeysCollectionTest extends TestCase {
		
		public function TimeseriesKeysCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(TimeseriesKeysCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			try {
				collection.addItem("Wrong object");
				fail("Time series keys collections can only contain time series keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Time series keys collections can only contain time series keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var series1:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test1"));
			var series2:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test2"));
			collection.addItem(series1);
			collection.setItemAt(series2, 0);
			assertEquals("There should be one series", 1, collection.length);
			assertEquals("series2", series2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Time series keys collections can only contain time series keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetTimeseriesKey():void {
			var collection:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var dimension1:Dimension = new Dimension("1", new Concept("Concept1"));
			var dimension2:Dimension = new Dimension("2", new Concept("Concept2"));
			var dimension3:Dimension = new Dimension("3", new Concept("Concept3"));						
			var series1:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test1"));
			var series2:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test2"));
			var series3:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test3"));
			var keyValues1:KeyValuesCollection = new KeyValuesCollection();
			keyValues1.addItem(new KeyValue(new Code("A"), dimension1));
			keyValues1.addItem(new KeyValue(new Code("1"), dimension2));
			keyValues1.addItem(new KeyValue(new Code("I"), dimension3));
			var keyValues2:KeyValuesCollection = new KeyValuesCollection();
			keyValues2.addItem(new KeyValue(new Code("B"), dimension1));
			keyValues2.addItem(new KeyValue(new Code("2"), dimension2));
			keyValues2.addItem(new KeyValue(new Code("II"), dimension3));
			var keyValues3:KeyValuesCollection = new KeyValuesCollection();
			keyValues3.addItem(new KeyValue(new Code("C"), dimension1));
			keyValues3.addItem(new KeyValue(new Code("3"), dimension2));
			keyValues3.addItem(new KeyValue(new Code("III"), dimension3));
			series1.keyValues = keyValues1;
			series2.keyValues = keyValues2;
			series3.keyValues = keyValues3;
			collection.addItem(series1);
			collection.addItem(series2);
			collection.addItem(series3);
			assertEquals("The series should be equal", series2, collection.getTimeseriesKey("B.2.II"));
			assertNull("no series", collection.getTimeseriesKey("B.2.IV"));
		}
		
		public function testGetTimeseriesKeyBySiblingGroup():void {
			var collection:TimeseriesKeysCollection = new TimeseriesKeysCollection();
			var dimension1:Dimension = new Dimension("1", new Concept("Concept1"));
			var dimension2:Dimension = new Dimension("2", new Concept("Concept2"));
			var dimension3:Dimension = new Dimension("3", new Concept("Concept3"));						
			var series1:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test1"));
			var series2:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test2"));
			var series3:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("test3"));
			var keyValues1:KeyValuesCollection = new KeyValuesCollection();
			keyValues1.addItem(new KeyValue(new Code("A"), dimension1));
			keyValues1.addItem(new KeyValue(new Code("1"), dimension2));
			keyValues1.addItem(new KeyValue(new Code("I"), dimension3));
			var keyValues2:KeyValuesCollection = new KeyValuesCollection();
			keyValues2.addItem(new KeyValue(new Code("B"), dimension1));
			keyValues2.addItem(new KeyValue(new Code("2"), dimension2));
			keyValues2.addItem(new KeyValue(new Code("II"), dimension3));
			var keyValues3:KeyValuesCollection = new KeyValuesCollection();
			keyValues3.addItem(new KeyValue(new Code("C"), dimension1));
			keyValues3.addItem(new KeyValue(new Code("3"), dimension2));
			keyValues3.addItem(new KeyValue(new Code("III"), dimension3));
			series1.keyValues = keyValues1;
			series2.keyValues = keyValues2;
			series3.keyValues = keyValues3;
			collection.addItem(series1);
			collection.addItem(series2);
			collection.addItem(series3);
			assertEquals("The series should be equal", series2, collection.getTimeseriesKeyBySiblingGroup("2.II"));
			assertNull("no series", collection.getTimeseriesKeyBySiblingGroup("2.IV"));
		}
	}
}