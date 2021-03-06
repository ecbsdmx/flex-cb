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
	public class MemberSelectionsCollectionTest extends TestCase {

		public function MemberSelectionsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(MemberSelectionsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:MemberSelectionsCollection = new MemberSelectionsCollection();
			try {
				collection.addItem("Wrong object");
				fail("Member selections collections can only contain member selections");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:MemberSelectionsCollection = new MemberSelectionsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Member selections collections can only contain member selections");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:MemberSelectionsCollection = new MemberSelectionsCollection();
			var ms1:MemberSelection = new MemberSelection();
			var ms2:MemberSelection = new MemberSelection();
			collection.addItem(ms1);
			collection.setItemAt(ms2, 0);
			assertEquals("1 ms", 1, collection.length);
			assertEquals("ms2", ms2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Member selections collections can only contain member selections");
			} catch (error:ArgumentError) {}
		}
	}
}