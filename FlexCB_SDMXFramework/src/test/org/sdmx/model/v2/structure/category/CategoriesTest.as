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
package org.sdmx.model.v2.structure.category
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	
	/**
	 * @private 
	 */
	public class CategoriesTest extends TestCase
	{
		public function CategoriesTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CategoriesTest);
		}
		
		public function testSetAndGetID():void
		{
			var collection:CategorieSchemesCollection =
				new CategorieSchemesCollection("id");
			assertEquals("ID should be =", "id", collection.id);
			collection.id = "id2";
			assertEquals("ID should be = (2)", "id2", collection.id);	 
		}
		
		public function testAddItem():void {
			var collection:CategorieSchemesCollection = new CategorieSchemesCollection("Categories");
			try {
				collection.addItem("Wrong object");
				fail("Categories collections can only contain category schemes");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:CategorieSchemesCollection = new CategorieSchemesCollection("Categories");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Categories collections can only contain category schemes");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:CategorieSchemesCollection = 
				new CategorieSchemesCollection("Categories");
			var cs1:CategoryScheme = new CategoryScheme("cs1", 
				new InternationalString(), new MaintenanceAgency("ecb"));	
			var cs2:CategoryScheme = new CategoryScheme("cs2", 
				new InternationalString(), new MaintenanceAgency("ecb"));
			collection.addItem(cs1);
			collection.setItemAt(cs2, 0);
			assertEquals("Should be 1", 1, collection.length);
			assertEquals("Should be cs2", cs2, collection.getItemAt(0));		
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Categories collections can only contain category schemes");
			} catch (error:ArgumentError) {}
		}
	}
}