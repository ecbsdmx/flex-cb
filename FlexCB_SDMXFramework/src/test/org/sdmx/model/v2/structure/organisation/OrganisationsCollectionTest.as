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

	/**
	 * @private 
	 */
	public class OrganisationsCollectionTest extends TestCase
	{
		public function OrganisationsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(OrganisationsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:OrganisationsCollection = new OrganisationsCollection();
			try {
				collection.addItem("Wrong object");
				fail("Organisations collections can only contain organisations");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:OrganisationsCollection = new OrganisationsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("Organisations collections can only contain organisations");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:OrganisationsCollection = new OrganisationsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("Organisations collections can only contain organisations");
			} catch (error:ArgumentError) {}
		}
		
		public function testNoDuplicates():void {	
			var collection:OrganisationsCollection = new OrganisationsCollection();
			var org1:Organisation = new Organisation("A");
			var org2:Organisation = new Organisation("AB");
			var org3:Organisation = new Organisation("A");						
			collection.addItem(org1);
			collection.addItem(org2);
			collection.addItem(org3);
			assertEquals("There should be only 2 organisations in the list", 2, collection.length);
			assertFalse("The first org should not be in the list anymore", collection.contains(org1));
			assertTrue("The org AB should be in the list", collection.contains(org2));
			assertTrue("The second org A should be in the list", collection.contains(org3));
		}
	}
}