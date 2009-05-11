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
	public class CodeListsTest extends TestCase {

		public function CodeListsTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodeListsTest);
		}
		
		public function testGetAndSetIDs():void
		{
			var collection:CodeLists = new CodeLists("test");
			assertEquals("ID =", "test", collection.id);
			collection.id = "test2";
			assertEquals("ID = (2)", "test2", collection.id);
		}	
		
		public function testAddItem():void {
			var collection:CodeLists = new CodeLists("test");
			try {
				collection.addItem("Wrong object");
				fail("Codelists collections can only contain codelists");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:CodeLists = new CodeLists("test");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Codelists collections can only contain codelists");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:CodeLists = new CodeLists("test");
			var maintainer:MaintenanceAgency = new MaintenanceAgency("ECB");
			var codeList1:CodeList = new CodeList("codeList1", new InternationalString(), maintainer);
			var codeList2:CodeList = new CodeList("codeList2", new InternationalString(), maintainer);
			collection.addItem(codeList1);
			collection.setItemAt(codeList2, 0);
			assertEquals("1", 1, collection.length);
			assertEquals("cl2", codeList2, collection.getItemAt(0));
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Codelists collections can only contain codelists");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetCodeList():void {
			var collection:CodeLists = new CodeLists();
			var maintainer:MaintenanceAgency = new MaintenanceAgency("ECB");
			var codeList1:CodeList = new CodeList("codeList1", new InternationalString(), maintainer);
			codeList1.version = "1.0";
			var codeList2:CodeList = new CodeList("codeList2", new InternationalString(), maintainer);
			codeList2.version = "1.0";
			var codeList3:CodeList = new CodeList("codeList2", new InternationalString(), maintainer);
			codeList3.version = "2.0";
			var codeList4:CodeList = new CodeList("codeList2", new InternationalString(), new MaintenanceAgency("OECD"));
			codeList4.version = "2.0";
			collection.addItem(codeList1);
			collection.addItem(codeList2);
			collection.addItem(codeList4);
			collection.addItem(codeList3);
			assertEquals("The 2nd code list should be returned 1", codeList2, collection.getCodeList("codeList2", null, null));
			assertEquals("The 2nd code list should be returned 2", codeList2, collection.getCodeList("codeList2", "1.0", null));
			assertEquals("The 2nd code list should be returned 3", codeList2, collection.getCodeList("codeList2", "1.0", "ECB"));
			assertEquals("The 3rd code list should be returned 3", codeList3, collection.getCodeList("codeList2", "2.0", "ECB"));
			assertEquals("The 3rd code list should be returned 3", codeList3, collection.getCodeList("codeList2", "2.0", "ECB"));			
			assertNull("No such code list - id", collection.getCodeList("codeList3"));
			assertNull("No such code list - version", collection.getCodeList("codeList2", "2.1", "ECB"));
			assertNull("No such code list - agency", collection.getCodeList("codeList2", "2.1", "IMF"));
			try {
				collection.getCodeList(null);
				fail("The code list id should be mandatory");
			} catch (error:ArgumentError) {}
			try {
				collection.getCodeList("");
				fail("The code list id should be mandatory");
			} catch (error:ArgumentError) {}
		}
	}
}