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

	/**
	 * @private
	 */
	public class KeyValuesCollectionTest extends TestCase
	{
		public function KeyValuesCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(KeyValuesCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:KeyValuesCollection = new KeyValuesCollection();
			try {
				collection.addItem("Wrong object");
				fail("Key values collections can only contain key values");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:KeyValuesCollection = new KeyValuesCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Key values collections can only contain key values");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:KeyValuesCollection = new KeyValuesCollection();
			var value1:KeyValue = new KeyValue(new Code("A"), 
				new Dimension("dim", new Concept("c1")));
			var value2:KeyValue = new KeyValue(new Code("B"), 
				new Dimension("dim", new Concept("c2")));	
			collection.addItem(value1);
			collection.setItemAt(value2, 0);
			assertEquals("1", 1, collection.length);
			assertEquals("value2", value2, collection.getItemAt(0));	
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Key values collections can only contain key values");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetAndSetSeriesKeys():void {
			var keyValue1:KeyValue = new KeyValue(new Code("M"), new Dimension("FREQ", new Concept("FREQ")));
			var keyValue2:KeyValue = new KeyValue(new Code("Z51"), new Dimension("CURRENCY", new Concept("CURRENCY")));
			var keyValue3:KeyValue = new KeyValue(new Code("EUR"), new Dimension("CURRENCY_DENOM", new Concept("CURRENCY_DENOM")));
			var keyValue4:KeyValue = new KeyValue(new Code("ERC0"), new Dimension("EXR_TYPE", new Concept("EXR_TYPE")));
			var keyValue5:KeyValue = new KeyValue(new Code("A"), new Dimension("EXR_SUFFIX", new Concept("EXR_SUFFIX")));
			var collection:KeyValuesCollection = new KeyValuesCollection();
			collection.addItem(keyValue1);
			collection.addItem(keyValue2);
			collection.addItem(keyValue3);
			collection.addItem(keyValue4);
			collection.addItem(keyValue5);
			assertEquals("The series key should be equal", "M.Z51.EUR.ERC0.A", collection.seriesKey);
			collection.removeItemAt(4);
			assertEquals("The series key should be equal - 2", "M.Z51.EUR.ERC0", collection.seriesKey);
			collection.removeAll();
			assertEquals("The series key should be equal - 3", "", collection.seriesKey);
		}
	}
}