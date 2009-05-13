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
package org.sdmx.model.v2.structure.keyfamily
{
	import org.sdmx.model.v2.base.structure.ComponentListTest;
	import org.sdmx.model.v2.base.structure.ComponentList;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class KeyDescriptorTest extends ComponentListTest
	{
		public function KeyDescriptorTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
		}
		
		public override function createComponentList():ComponentList {
			return new KeyDescriptor(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(KeyDescriptorTest);
		}
		
		public function testAddItem():void {
			var collection:KeyDescriptor = new KeyDescriptor("dimensions");
			try {
				collection.addItem("Wrong object");
				fail("A KeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:KeyDescriptor = new KeyDescriptor("dimensions");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("A KeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:KeyDescriptor = new KeyDescriptor("dimensions");
			var dim1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dim2:Dimension = new Dimension("dim2", new Concept("REF_AREA"));
			collection.addItem(dim1);
			collection.setItemAt(dim2, 0);
			assertEquals("=1", 1, collection.length);
			assertTrue("Should be dim2", collection.contains(dim2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("A KeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetDimension():void {
			var collection:KeyDescriptor = new KeyDescriptor("dimensions");
			var dimension:Dimension = new Dimension("dim1", new Concept("OBS_CONF"));
			collection.addItem(dimension);
			assertEquals("The found dimension should be equal to dim1", dimension, collection.getDimension("OBS_CONF"));
			assertNull("No such dimension should exist in the collection", collection.getDimension("OBS_STATUS"));
		}
	}
}