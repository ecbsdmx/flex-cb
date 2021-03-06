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
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.structure.ComponentList;
	import org.sdmx.model.v2.base.structure.ComponentListTest;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */ 
	public class MeasureDescriptorTest extends ComponentListTest
	{
		
		public function MeasureDescriptorTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function createComponentList():ComponentList {
			return new MeasureDescriptor(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(MeasureDescriptorTest);
		}
		
		public function testAddItem():void {
			var collection:MeasureDescriptor = new MeasureDescriptor("measure");
			try {
				collection.addItem("Wrong object");
				fail("A MeasureDescriptor can only contain measures");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:MeasureDescriptor = new MeasureDescriptor("measure");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("A MeasureDescriptor can only contain measures");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:MeasureDescriptor = new MeasureDescriptor("measure");
			var measure1:UncodedMeasure = new UncodedMeasure("m1", new Concept("c1"));
			var measure2:UncodedMeasure = new UncodedMeasure("m2", new Concept("c2"));
			collection.addItem(measure1);
			collection.setItemAt(measure2, 0);
			assertEquals("=1", 1, collection.length);
			assertTrue("Should be m2", collection.contains(measure2));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("A MeasureDescriptor can only contain measures");
			} catch (error:ArgumentError) {}
		}
	}
}