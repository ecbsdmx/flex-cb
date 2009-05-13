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
	public class GroupKeyDescriptorTest extends ComponentListTest
	{
		public function GroupKeyDescriptorTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function createComponentList():ComponentList {
			return new GroupKeyDescriptor(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GroupKeyDescriptorTest);
		}
		
		public function testAddItem():void {
			var collection:GroupKeyDescriptor = new GroupKeyDescriptor("group");
			try {
				collection.addItem("Wrong object");
				fail("A GroupKeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:GroupKeyDescriptor = new GroupKeyDescriptor("group");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("A GroupKeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:GroupKeyDescriptor = new GroupKeyDescriptor("group");
			try {
				collection.setItemAt("Wrong object", 0);
				fail("A GroupKeyDescriptor can only contain dimensions");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetGroupKey():void {
			var collection:GroupKeyDescriptor = new GroupKeyDescriptor("dimensions");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			collection.addItem(dimension1);
			collection.addItem(dimension2);
			collection.addItem(dimension3);
			collection.addItem(dimension4);
			collection.addItem(dimension5);												
			assertEquals("The group key should be equal", "FREQ.CURRENCY.CURRENCY_DENOM.EXR_TYPE.EXR_SUFFIX", collection.groupKey);
		}
	}
}