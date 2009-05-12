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
	import org.sdmx.model.v2.base.LocalisedString;
	import mx.resources.Locale;
	import mx.collections.ArrayCollection;

	/**
	 * @private 
	 */
	public class ContactTest extends TestCase
	{
		private var _contact:Contact;
		
		public function ContactTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_contact = new Contact();
		}
		
		public static function suite():TestSuite {			
			return new TestSuite(ContactTest);
		}
		
		public function testSetAndGetId():void {
			assertNull("The id should initially be null", _contact.id);
			var id:String = "testContact"
			_contact.id = id;
			assertEquals("The ids should be equal", id, _contact.id);
		}
		
		public function testSetAndGetName():void {
			assertNull("The name should initially be null", _contact.name);
			var name:InternationalString = new InternationalString();
			name.localisedStrings.addItem(new LocalisedString(new Locale("en"), "name"));
			_contact.name = name;
			assertEquals("The names should be equal", name, _contact.name);
		}
		
		public function testSetAndGetDepartment():void {
			assertNull("The department should initially be null", _contact.department);
			var department:InternationalString = new InternationalString();
			department.localisedStrings.addItem(new LocalisedString(new Locale("en"), "department"));
			_contact.department = department;
			assertEquals("The departments should be equal", department, _contact.department);					
		}
		
		public function testSetAndGetRole():void {
			assertNull("The role should initially be null", _contact.role);
			var role:InternationalString = new InternationalString();
			role.localisedStrings.addItem(new LocalisedString(new Locale("en"), "role"));
			_contact.role = role;
			assertEquals("The roles should be equal", role, _contact.role);	
		}		
		
		public function testSetAndGetContactDetails():void {
			var details:Array = _contact.contactDetails;
			assertNull("Initially, the telephone list should be empty", details[Contact.TELEPHONE]);
			assertNull("Initially, the fax list should be empty", details[Contact.FAX]);
			assertNull("Initially, the email list should be empty", details[Contact.EMAIL]);
			assertNull("Initially, the uri list should be empty", details[Contact.URI]);
			assertNull("Initially, the x400 list should be empty", details[Contact.X400]);
			var phone1:String = "+496913440";
			var phone2:String = "+33154879689";
			var email:String = "test@example.com";
			_contact.addContactDetails(Contact.TELEPHONE, phone1);
			_contact.addContactDetails(Contact.TELEPHONE, phone2);
			_contact.addContactDetails(Contact.EMAIL, email);
			var details1:Array = _contact.contactDetails;
			assertNull("Initially, the fax list should still be empty", details1[Contact.FAX]);
			assertNull("Initially, the uri list should still be empty", details1[Contact.URI]);
			assertNull("Initially, the x400 list should still be empty", details1[Contact.X400]);
			assertEquals("There should be 2 phone numbers", 2, (details1[Contact.TELEPHONE] as ArrayCollection).length);
			assertEquals("There should be 1 email address", 1, (details1[Contact.EMAIL] as ArrayCollection).length);
			assertTrue("The 2 phone numbers should be in the list", (details1[Contact.TELEPHONE] as ArrayCollection).contains(phone1) && (details1[Contact.TELEPHONE] as ArrayCollection).contains(phone2));
			assertTrue("The email address should be in the list", (details1[Contact.EMAIL] as ArrayCollection).contains(email));
			try {
				_contact.addContactDetails(8, "shouldFail");
				fail("It should not be possible to add contact details of unknown type");
			} catch (error:ArgumentError) {
			}
		}
	}
}