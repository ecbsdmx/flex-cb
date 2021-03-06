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
package org.sdmx.model.v2.reporting.provisioning
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * @private
	 */ 
	public class AttachmentConstraintsCollectionTest extends TestCase {
		
		public function AttachmentConstraintsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttachmentConstraintsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:AttachmentConstraintsCollection = new AttachmentConstraintsCollection();
			try {
				collection.addItem("Wrong object");
				fail("Attachment constraints collection can only contain Attachment constraints");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:AttachmentConstraintsCollection = new AttachmentConstraintsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Attachment constraints collection can only contain Attachment constraints");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:AttachmentConstraintsCollection = new AttachmentConstraintsCollection();
			var constraint1:AttachmentConstraint = new AttachmentConstraint("c1");
			var constraint2:AttachmentConstraint = new AttachmentConstraint("c2");
			collection.addItem(constraint1);
			collection.setItemAt(constraint2, 0);
			assertEquals("1 constraint", 1, collection.length);
			assertEquals("cs2", constraint2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Attachment constraints collection can only contain Attachment constraints");
			} catch (error:ArgumentError) {}
		}
	}
}