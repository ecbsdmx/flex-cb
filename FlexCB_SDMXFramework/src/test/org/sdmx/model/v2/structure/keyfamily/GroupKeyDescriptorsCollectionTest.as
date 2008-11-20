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
package org.sdmx.model.v2.structure.keyfamily
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class GroupKeyDescriptorsCollectionTest extends TestCase {
		
		public function GroupKeyDescriptorsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(GroupKeyDescriptorsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			try {
				collection.addItem("Wrong object");
				fail("A GroupKeyDescriptorsCollection can only contain GroupKeyDescriptor");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("A GroupKeyDescriptorsCollection can only contain GroupKeyDescriptor");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("A GroupKeyDescriptorsCollection can only contain GroupKeyDescriptor");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetId():void {
			var collection:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			assertEquals("By default the id should be 'Groups'", "Groups", collection.id);
			var newId:String = "MyCollection";
			collection.id = newId;
			assertEquals("The new id should be equal", newId, collection.id);
		}
		
		public function testGetGroup():void {
			var collection:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			var groupKeyDescriptor:GroupKeyDescriptor = new GroupKeyDescriptor("siblingGroup");
			var dim1:Dimension = new Dimension("dim1", new Concept("CURRENCY"));
			var dim2:Dimension = new Dimension("dim2", new Concept("CURRENCY_DENOM"));
			var dim3:Dimension = new Dimension("dim3", new Concept("EXR_TYPE"));
			var dim4:Dimension = new Dimension("dim4", new Concept("EXR_SUFFIX"));						
			groupKeyDescriptor.addItem(dim1);
			groupKeyDescriptor.addItem(dim2);
			groupKeyDescriptor.addItem(dim3);
			groupKeyDescriptor.addItem(dim4);									
			collection.addItem(groupKeyDescriptor);
			assertEquals("The groups should be equal", groupKeyDescriptor, collection.getGroup("CURRENCY.CURRENCY_DENOM.EXR_TYPE.EXR_SUFFIX"));
			assertNull("This should not be in the collection", collection.getGroup("TEST.BLAH"));
		}
	}
}