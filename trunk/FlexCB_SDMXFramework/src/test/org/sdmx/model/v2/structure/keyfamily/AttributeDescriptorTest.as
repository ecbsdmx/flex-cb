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
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.structure.Attribute;
	import org.sdmx.model.v2.base.structure.ComponentList;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.code.CodeList;

	/**
	 * @private
	 */
	public class AttributeDescriptorTest extends ComponentListTest
	{	
		public function AttributeDescriptorTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function createComponentList():ComponentList {
			return new AttributeDescriptor(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttributeDescriptorTest);
		}
		
		public function testAddItem():void {
			var collection:AttributeDescriptor = new AttributeDescriptor("ad");
			try {
				collection.addItem("Wrong object");
				fail("An AttributeDescriptor can only contain data attributes");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:AttributeDescriptor = new AttributeDescriptor("ad");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("An AttributeDescriptor can only contain data attributes");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:AttributeDescriptor = new AttributeDescriptor("ad");
			var attribute1:DataAttribute = new UncodedDataAttribute("attr1", new Concept("OBS_COM"));
			var attribute2:DataAttribute = new UncodedDataAttribute("attr2", new Concept("OBS_CONF"));
			collection.addItem(attribute1);
			collection.setItemAt(attribute2, 0);
			assertEquals("=1", 1, collection.length);
			assertTrue("Should be attr2", collection.contains(attribute2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("An AttributeDescriptor can only contain data attributes");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetAttribute():void {
			var collection:AttributeDescriptor = new AttributeDescriptor("attributes");
			var attribute:DataAttribute = new UncodedDataAttribute("attr1", new Concept("OBS_COM"));
			collection.addItem(attribute);
			assertEquals("The found attribute should be equal to attribute", attribute, collection.getAttribute("OBS_COM"));
			assertNull("No such attribute should exist in the collection", collection.getAttribute("OBS_STATUS"));
		}
	}
}