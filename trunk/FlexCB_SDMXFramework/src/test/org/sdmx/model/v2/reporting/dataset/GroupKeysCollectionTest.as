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
	
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;

	/**
	 * @private
	 */
	public class GroupKeysCollectionTest extends TestCase
	{
		public function GroupKeysCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GroupKeysCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:GroupKeysCollection = new GroupKeysCollection();
			try {
				collection.addItem("Wrong object");
				fail("Group keys collections can only contain group keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:GroupKeysCollection = new GroupKeysCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Group keys collections can only contain group keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:GroupKeysCollection = new GroupKeysCollection();
			var groupKey1:GroupKey = new GroupKey(new GroupKeyDescriptor("1"));
			var groupKey2:GroupKey = new GroupKey(new GroupKeyDescriptor("1"));
			collection.addItem(groupKey1);
			collection.setItemAt(groupKey2, 0);
			assertEquals("One group", 1, collection.length);
			assertEquals("GroupKey2", groupKey2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Group keys collections can only contain group keys");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetGroupsForTimeseries():void {
			var group1:GroupKey = new GroupKey(new GroupKeyDescriptor("id1"));
			var group2:GroupKey = new GroupKey(new GroupKeyDescriptor("id2"));
			var group3:GroupKey = new GroupKey(new GroupKeyDescriptor("id3"));
			var series1:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id4"));
			var series2:TimeseriesKey = new TimeseriesKey(new KeyDescriptor("id5"));
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
			series1.keyValues = groupKeyValues1;
			series2.keyValues = groupKeyValues2;
			group1.timeseriesKeys.addItem(series1);
			group2.timeseriesKeys.addItem(series1);
			group2.timeseriesKeys.addItem(series2);
			group3.timeseriesKeys.addItem(series2);
			var collection:GroupKeysCollection = new GroupKeysCollection();
			collection.addItem(group1);
			collection.addItem(group2);
			collection.addItem(group3);
			var results:GroupKeysCollection = collection.getGroupsForTimeseries(series1);
			assertEquals("There should be 2 results in the results collection", 2, results.length);
			assertTrue("The 1st group should be in the collection", results.contains(group1));
			assertTrue("The 2nd group should be in the collection", results.contains(group2));
		}
	}
}