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
package org.sdmx.model.v2.structure.organisation
{
	import org.sdmx.model.v2.base.item.ItemTest;
	import org.sdmx.model.v2.base.item.Item;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.LocalisedString;
	import mx.resources.Locale;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.base.type.DataType;
	
	/**
	 * @private 
	 */
	public class OrganisationTest extends ItemTest
	{
		private var _organisation:Organisation;
		
		public function OrganisationTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_organisation = createOrganisation();
			assertNotNull("Problem creating organisation", _organisation);
			/*_collection = createOrganisation();
			_item1 = new Organisation("BIS");
			_item2 = new Organisation("ECB");
			_item3 = new Organisation("OECD");		*/
		}
		
		public override function createItem():Item {
			return createOrganisation();
		}
		
		public function createOrganisation():Organisation {
			return new Organisation(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(OrganisationTest);
		}
		
		public function testSetAndGetContact():void {
			var contact:Contact = new Contact();
			contact.id = "test";
			contact.addContactDetails(Contact.EMAIL, "test@example.com");
			var contacts:ContactsCollection = new ContactsCollection();
			contacts.addItem(contact);
			_organisation.contacts = contacts;
			assertEquals("Contacts should be equal", contacts, _organisation.contacts);
		}
	}
}