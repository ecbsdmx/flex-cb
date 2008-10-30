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
package org.sdmx.model.v2.structure.code
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private 
	 */
	public class CodesCollectionTest extends TestCase {
		
		public function CodesCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodesCollectionTest);
		}
		
		public function testSetAndGetCodeValueLength():void {
			var collection:CodesCollection = new CodesCollection();
			assertEquals("The code value length should be initially 0", 0, collection.codeValueLength);
			var length:uint = 3;
			collection.codeValueLength = length;
			assertEquals("The code value length should be equal", length, collection.codeValueLength);
		}
		
		public function testAddItem():void {
			var collection:CodesCollection = new CodesCollection();
			try {
				collection.addItem("Wrong object");
				fail("Codes collections can only contain codes");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:CodesCollection = new CodesCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Codes collections can only contain codes");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:CodesCollection = new CodesCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Codes collections can only contain codes");
			} catch (error:ArgumentError) {}
		}
		
		public function testChangeCodeLength():void {
			var collection:CodesCollection = new CodesCollection();
			collection.addItem(new Code("A"));
			collection.addItem(new Code("AB"));			
			collection.addItem(new Code("ABC"));
			collection.codeValueLength = 4;
			assertEquals("The codes in the list should not have been affected by the new code value length", 3, collection.length);
			try {
				collection.codeValueLength = 2;
				fail("If code list already contains codes, it should not be possible to set a code value length smaller than existing code values");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddCodeWithLongId():void {
			var collection:CodesCollection = new CodesCollection();
			collection.codeValueLength = 3;
			collection.addItem(new Code("A"));
			collection.addItem(new Code("AB"));			
			collection.addItem(new Code("ABC"));
			try {
				collection.addItem(new Code("ABCD"));
				fail("It should not be possible to add codes with values longer than codeValueLength");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddCodeWithLongIdAtPosition():void {
			var collection:CodesCollection = new CodesCollection();
			collection.codeValueLength = 3;
			collection.addItem(new Code("A"));
			collection.addItem(new Code("AB"));			
			collection.addItem(new Code("ABC"));
			try {
				collection.addItemAt(new Code("ABCD"), 0);
				fail("It should not be possible to add codes at a certain position with values longer than codeValueLength");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetCodeWithLongIdAtPosition():void {
			var collection:CodesCollection = new CodesCollection();
			collection.codeValueLength = 3;
			collection.addItem(new Code("A"));
			collection.addItem(new Code("AB"));			
			collection.addItem(new Code("ABC"));
			try {
				collection.setItemAt(new Code("ABCD"), 0);
				fail("It should not be possible to add codes at a certain position with values longer than codeValueLength");
			} catch (error:ArgumentError) {}
		}
		
		public function testNoDuplicates():void {	
			var collection:CodesCollection = new CodesCollection();
			var code1:Code = new Code("A");
			var code2:Code = new Code("AB");
			var code3:Code = new Code("A");						
			collection.addItem(code1);
			collection.addItem(code2);
			assertEquals("There should be 2 codes in the code list", 2, collection.length);
			assertTrue("The first code A should be in the list", collection.contains(code1));
			collection.addItem(code3);
			assertEquals("There should still be only 2 codes in the code list", 2, collection.length);
			assertFalse("The first code A should not be in the list anymore", collection.contains(code1));
			assertTrue("The code AB should be in the list", collection.contains(code2));
			assertTrue("The second code A should be in the list", collection.contains(code3));
		}
		
		public function testGetCode():void {
			var collection:CodesCollection = new CodesCollection();
			var code1:Code = new Code("A");
			var code2:Code = new Code("B");
			collection.addItem(code1);
			assertEquals("The 1st codes should be equal", code1, collection.getCode("A"));
			assertNull("The 2nd code is not in the list", collection.getCode("B"));
			collection.addItem(code2);
			assertEquals("The 2nd codes should be equal", code2, collection.getCode("B"));
		}
	}
}