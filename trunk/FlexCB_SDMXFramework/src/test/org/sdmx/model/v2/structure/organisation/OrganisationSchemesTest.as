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
package org.sdmx.model.v2.structure.organisation
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.InternationalString;

	/**
	 * @private 
	 */
	public class OrganisationSchemesTest extends TestCase {

		public function OrganisationSchemesTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(OrganisationSchemesTest);
		}
		
		public function testSetAndGetID():void
		{
			var schemes:OrganisationSchemes = new OrganisationSchemes("os");
			assertEquals("id=", "os", schemes.id);
			schemes.id = "os2";
			assertEquals("id2=", "os2", schemes.id);
		}
		
		public function testAddItem():void {
			var collection:OrganisationSchemes = new OrganisationSchemes();
			try {
				collection.addItem("Wrong object");
				fail("Organisation schemes collections can only contain organisation schemes");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:OrganisationSchemes = new OrganisationSchemes();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Organisation schemes collections can only contain organisation schemes");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:OrganisationSchemes = new OrganisationSchemes();
			var os1:OrganisationScheme = new OrganisationScheme("os1", 
				new InternationalString, new MaintenanceAgency("ecb"));
			var os2:OrganisationScheme = new OrganisationScheme("os2", 
				new InternationalString, new MaintenanceAgency("ecb"));	
			collection.addItem(os1);
			collection.setItemAt(os2, 0);
			assertEquals("should be 1", 1, collection.length);
			assertEquals("should be os2", os2, collection.getItemAt(0));	
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Organisation schemes collections can only contain organisation schemes");
			} catch (error:ArgumentError) {}
		}
	}
}