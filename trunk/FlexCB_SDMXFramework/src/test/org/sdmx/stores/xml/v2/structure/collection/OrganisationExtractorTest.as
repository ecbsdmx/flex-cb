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
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.structure.organisation.Contact;
	import org.sdmx.model.v2.structure.organisation.Organisation;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * @private
	 */
	public class OrganisationExtractorTest extends TestCase
	{
		public function OrganisationExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(OrganisationExtractorTest);
		}
		
		public function testExtractOrganisation():void {
			var xml:XML = 
				<DataProvider id="ECB" uri="http://www.ecb.int/" urn="REGISTRY:ECB" validFrom="1998-06-01" version="2.0">
					<Name xml:lang="en">European Central Bank</Name>
					<Description xml:lang="en">European Central Bank Description</Description>
					<MaintenanceContact>
						<Department>Unit 1</Department>
						<Email>unit1@ecb.int</Email>
					</MaintenanceContact>
					<CollectorContact>
						<Department>Unit 2</Department>
						<Telephone>+4969987654321</Telephone>
					</CollectorContact>
					<DisseminatorContact>
						<Department>Unit 3</Department>
						<Fax>+4969123456789</Fax>
					</DisseminatorContact>
					<ReporterContact>
						<Department>Unit 4</Department>
						<X400>test4</X400>
					</ReporterContact>
					<OtherContact>
						<Department>Unit 5</Department>
						<URI>test1</URI>
					</OtherContact>
				</DataProvider>
			var extractor:OrganisationExtractor = new OrganisationExtractor();
			var organisation:Organisation = extractor.extract(xml) as Organisation;
			assertNotNull("The organisation cannot be null", organisation);
			assertEquals("The id should be equal", "ECB", organisation.id);
			assertEquals("The version should be equal", "2.0", organisation.version);
			assertEquals("The URI should be equal", "http://www.ecb.int/", organisation.uri);
			assertEquals("The URN should be equal", "REGISTRY:ECB", organisation.urn);
			var sdmxDate:SDMXDate = new SDMXDate();
			assertEquals("The valid from dates should be equal", sdmxDate.getDate("1998-06-01").getTime(), organisation.validFrom);
			assertEquals("The EN names should be equal", "European Central Bank", organisation.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The EN descriptions should be equal", "European Central Bank Description", organisation.description.localisedStrings.getDescriptionByLocale("en"));			
			assertEquals("There should be 5 contact details", 5, organisation.contacts.length);
			var contact1:Contact = organisation.contacts.getItemAt(0) as Contact;
			assertEquals("The dpt should be equal", "Unit 1", contact1.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The email address should be the same", "unit1@ecb.int", (contact1.contactDetails[Contact.EMAIL] as ArrayCollection).getItemAt(0));
			
			var contact2:Contact = organisation.contacts.getItemAt(1) as Contact;
			assertEquals("The dpt should be equal", "Unit 2", contact2.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The phone should be the same", "+4969987654321", (contact2.contactDetails[Contact.TELEPHONE] as ArrayCollection).getItemAt(0));
			
			var contact3:Contact = organisation.contacts.getItemAt(2) as Contact;
			assertEquals("The dpt should be equal", "Unit 3", contact3.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The fax should be the same", "+4969123456789", (contact3.contactDetails[Contact.FAX] as ArrayCollection).getItemAt(0));
			
			var contact4:Contact = organisation.contacts.getItemAt(3) as Contact;
			assertEquals("The dpt should be equal", "Unit 4", contact4.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The x400 address should be the same", "test4", (contact4.contactDetails[Contact.X400] as ArrayCollection).getItemAt(0));
			
			var contact5:Contact = organisation.contacts.getItemAt(4) as Contact;
			assertEquals("The dpt should be equal", "Unit 5", contact5.department.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The URI should be the same", "test1", (contact5.contactDetails[Contact.URI] as ArrayCollection).getItemAt(0));
		}		
	}
}