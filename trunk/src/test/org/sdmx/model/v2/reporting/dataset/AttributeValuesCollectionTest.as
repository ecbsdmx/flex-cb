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
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class AttributeValuesCollectionTest extends TestCase {

		public function AttributeValuesCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttributeValuesCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:AttributeValuesCollection = new AttributeValuesCollection();
			try {
				collection.addItem("Wrong object");
				fail("Attribute values collections can only contain attribute values");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:AttributeValuesCollection = new AttributeValuesCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Attribute values collections can only contain attribute values");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:AttributeValuesCollection = new AttributeValuesCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Attribute values collections can only contain attribute values");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetAttributesByAttachableArtefact():void {
			var dataSet1:DataSet = new DataSet();
			var dataSet2:DataSet = new DataSet();
			var dataSet3:DataSet = new DataSet();
			var attributeValue1:UncodedAttributeValue = new UncodedAttributeValue(dataSet1, "1", new UncodedDataAttribute("id1", new Concept("A")));
			var attributeValue2:UncodedAttributeValue = new UncodedAttributeValue(dataSet2, "2", new UncodedDataAttribute("id2", new Concept("B")));			
			var attributeValue3:UncodedAttributeValue = new UncodedAttributeValue(dataSet2, "3", new UncodedDataAttribute("id3", new Concept("C")));
			var attributeValue4:UncodedAttributeValue = new UncodedAttributeValue(dataSet3, "4", new UncodedDataAttribute("id4", new Concept("D")));
			var collection:AttributeValuesCollection = new AttributeValuesCollection();
			collection.addItem(attributeValue1);
			collection.addItem(attributeValue2);
			collection.addItem(attributeValue3);
			collection.addItem(attributeValue4);
			var results:AttributeValuesCollection = collection.getAttributes(dataSet2);
			assertEquals("There should be 2 results in the results collection", 2, results.length);
			assertTrue("The 2nd attribute should be in the collection", results.contains(attributeValue2));
			assertTrue("The 3rd attribute should be in the collection", results.contains(attributeValue3));
		}
	}
}