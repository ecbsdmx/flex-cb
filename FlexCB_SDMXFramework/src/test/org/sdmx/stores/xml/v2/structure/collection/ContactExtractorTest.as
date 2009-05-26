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
package org.sdmx.stores.xml.v2.structure.collection
{
	import flexunit.framework.TestCase;
	import org.sdmx.model.v2.structure.organisation.Contact;
	import flexunit.framework.TestSuite;
	import mx.collections.ArrayCollection;

	/**
	 * @private
	 */
	public class ContactExtractorTest extends TestCase
	{
		public function ContactExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ContactExtractorTest);
		}
		
		public function testExtractContact():void {
			var xml:XML = 					
				<DisseminatorContact>
					<id>S-SIS</id>
					<Department>Directorate General Statistics - Statistical Information Services</Department>
					<Role>Secret Information Services</Role>
					<Email>sis.external@ecb.int</Email>
					<Email>A.Tester@ecb.int</Email>
					<Fax>+4969134401</Fax>
					<Telephone>+496913440112</Telephone>
				</DisseminatorContact>
			var extractor:ContactExtractor = new ContactExtractor();
			var contact:Contact = extractor.extract(xml) as Contact;
			assertNotNull("Contact cannot be null", contact);
			assertEquals("The ids should be equal", "S-SIS", contact.id);
			assertEquals("The dpt should be equal", "Directorate General Statistics - Statistical Information Services", contact.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The roles should be equal", "Secret Information Services", contact.role.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("There should be 2 emails listed", 2, (contact.contactDetails[Contact.EMAIL] as ArrayCollection).length);
			assertEquals("There should be 1 fax listed", 1, (contact.contactDetails[Contact.FAX] as ArrayCollection).length);	
			assertEquals("There should be 1 phone listed", 1, (contact.contactDetails[Contact.TELEPHONE] as ArrayCollection).length);			
			assertEquals("The 1st email should be equal", "sis.external@ecb.int", (contact.contactDetails[Contact.EMAIL] as ArrayCollection).getItemAt(0));
			assertEquals("The 2nd email should be equal", "A.Tester@ecb.int", (contact.contactDetails[Contact.EMAIL] as ArrayCollection).getItemAt(1));			
			assertEquals("The fax should be equal", "+4969134401", (contact.contactDetails[Contact.FAX] as ArrayCollection).getItemAt(0));
			assertEquals("The phone should be equal", "+496913440112", (contact.contactDetails[Contact.TELEPHONE] as ArrayCollection).getItemAt(0));
		}
	}
}