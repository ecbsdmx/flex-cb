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
package org.sdmx.model.v2.base
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import mx.resources.Locale;

	/**
	 *	@private 
	 */
	public class LocalisedStringsCollectionTest extends TestCase {

		public function LocalisedStringsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(LocalisedStringsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:LocalisedStringsCollection = new LocalisedStringsCollection();
			try {
				collection.addItem("Wrong object");
				fail("Localised strings collections can only contain localised strings");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:LocalisedStringsCollection = new LocalisedStringsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Localised strings collections can only contain localised strings");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:LocalisedStringsCollection = new LocalisedStringsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Localised strings collections can only contain localised strings");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetDescriptionByLocale():void {
			var collection:LocalisedStringsCollection = new LocalisedStringsCollection();
			var item1:LocalisedString = new LocalisedString(new Locale("en"), "Statistics");
			var item2:LocalisedString = new LocalisedString(new Locale("fr"), "Statistiques");
			collection.addItem(item1);
			collection.addItem(item2);
			assertEquals("There should be 2 items in the collection", 2, collection.length);
			assertEquals("There should be an item in French", item2.label, collection.getDescriptionByLocale("fr"));
			assertEquals("There should be an item in English", item1.label, collection.getDescriptionByLocale("en"));
			assertNull("There should be no item in German", collection.getDescriptionByLocale("de"));
		}
	}
}