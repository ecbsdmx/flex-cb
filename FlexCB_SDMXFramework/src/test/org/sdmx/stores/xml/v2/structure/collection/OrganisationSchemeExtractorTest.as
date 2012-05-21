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
	
	import org.sdmx.model.v2.structure.organisation.DataProvider;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.organisation.Organisation;
	import org.sdmx.model.v2.structure.organisation.OrganisationScheme;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * @private
	 */
	public class OrganisationSchemeExtractorTest extends TestCase
	{
		public function OrganisationSchemeExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(OrganisationSchemeExtractorTest);
		}
		
		public function testExtractOrganisationSchemeSdmx20():void {
			var xml:XML = 
				<OrganisationScheme id="ESCB" agencyID="ECB" isFinal="true" uri="http://www.ecb.int" urn="ECB:DESC" validFrom="2007-07-28" validTo="2007-07-29" version="1.0" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name xml:lang="en">The European System of Central Banks</Name>
					<Description>The European System of Central Banks (Desc)</Description>
					<Agencies>
						<Agency id="ECB">
							<Name xml:lang="en">European Central Bank</Name>
							<DisseminatorContact>
								<Department>Directorate General Statistics - Statistical Information Services</Department>
								<Email>sis.external@ecb.int</Email>
							</DisseminatorContact>
						</Agency>
					</Agencies>
					<DataProviders>
						<DataProvider id="4F0">
							<Name xml:lang="en">European Central Bank</Name>
							<DisseminatorContact>
								<Department>Directorate General Statistics - Statistical Information Services</Department>
								<Email>sis.external@ecb.int</Email>
							</DisseminatorContact>
						</DataProvider>
					</DataProviders>
				</OrganisationScheme>
			var extractor:OrganisationSchemeExtractor = new OrganisationSchemeExtractor();
			var item:OrganisationScheme = extractor.extract(xml) as OrganisationScheme;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "ESCB", item.id);
			assertEquals("The URIs should be equal", "http://www.ecb.int", item.uri);
			assertEquals("The URNs should be equal", "ECB:DESC", item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			var sdmxDate:SDMXDate = new SDMXDate();
			assertEquals("The validFrom should be equal", sdmxDate.getDate("2007-07-28").getTime(), item.validFrom.getTime());
			assertEquals("The validTo should be equal", sdmxDate.getDate("2007-07-29").getTime(), item.validTo.getTime());			
			assertTrue("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "The European System of Central Banks", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 1 localised strings in the description collection", 1, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "The European System of Central Banks (Desc)", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The list of organisations cannot be null", item.organisations);
			assertEquals("There should be 2 organisation ins the list", 2, item.organisations.length);
			var organisation1:Organisation = item.organisations.getItemAt(1) as Organisation;
			var organisation2:Organisation = item.organisations.getItemAt(0) as Organisation;
			assertNotNull("The organisation 1 cannot be null", organisation1);
			assertTrue("The organisation 1 should be an agency", organisation1 is MaintenanceAgency);
			assertEquals("The IDs for organisation 1 should be equal", "ECB", organisation1.id);
			assertNotNull("The name for organisation 1 cannot be null", organisation1.name);
			assertEquals("The name for EN should be equal for organisation 1", "European Central Bank", organisation1.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The organisation 2 cannot be null", organisation2);
			assertTrue("The organisation 2 should be a data provider", organisation2 is DataProvider);
			assertEquals("The IDs for organisation 2 should be equal", "4F0", organisation2.id);
			assertNotNull("The name for organisation 2 cannot be null", organisation2.name);
			assertEquals("The name for EN should be equal for organisation 2", "European Central Bank", organisation2.name.localisedStrings.getDescriptionByLocale("en"));
		}
		
		public function testExtractAgencySchemeSdmx21():void {
			var xml:XML = 
				<structure:AgencyScheme id="AGENCIES" agencyID="SDMX"
					isExternalReference="false" version="1.0" 
					xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" 
					xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common">
					<common:Name>Maintenance agencies</common:Name>
					<structure:Agency id="ECB">
						<common:Name>European Central Bank</common:Name>
					</structure:Agency>
					<structure:Agency id="BIS">
						<common:Name>Bank for International Settlements</common:Name>
					</structure:Agency>				
				</structure:AgencyScheme>
			var extractor:OrganisationSchemeExtractor = new OrganisationSchemeExtractor();
			var item:OrganisationScheme = extractor.extract(xml) as OrganisationScheme;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "AGENCIES", item.id);
			assertEquals("The URIs should be null", null, item.uri);
			assertEquals("The URNs should be null", null, item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			assertEquals("The validFrom should be null", null, item.validFrom);
			assertEquals("The validTo should be null", null, item.validTo);			
			assertFalse("The isFinal flag should be equal", item.isFinal);
			assertEquals("SDMX should be the maintenance agency", "SDMX", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Maintenance agencies", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The description should be null", null, item.description);
			assertNotNull("The list of organisations cannot be null", item.organisations);
			assertEquals("There should be 2 organisations in the list", 2, item.organisations.length);
			var organisation1:Organisation = item.organisations.getItemAt(1) as Organisation;
			var organisation2:Organisation = item.organisations.getItemAt(0) as Organisation;
			assertNotNull("The organisation 1 cannot be null", organisation1);
			assertTrue("The organisation 1 should be an agency", organisation1 is MaintenanceAgency);
			assertEquals("The IDs for organisation 1 should be equal", "ECB", organisation1.id);
			assertNotNull("The name for organisation 1 cannot be null", organisation1.name);
			assertEquals("The name for EN should be equal for organisation 1", "European Central Bank", organisation1.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The organisation 2 cannot be null", organisation2);
			assertTrue("The organisation 2 should be another agency", organisation2 is MaintenanceAgency);
			assertEquals("The IDs for organisation 2 should be equal", "BIS", organisation2.id);
			assertNotNull("The name for organisation 2 cannot be null", organisation2.name);
			assertEquals("The name for EN should be equal for organisation 2", "Bank for International Settlements", organisation2.name.localisedStrings.getDescriptionByLocale("en"));
		}
		
		public function testExtractProviderSchemeSdmx21():void {
			var xml:XML = 
				<structure:DataProviderScheme id="DATA_PROVIDERS" agencyID="SDMX"
					isExternalReference="false" version="1.0" 
					xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" 
					xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common">
					<common:Name>Data providers</common:Name>
					<structure:DataProvider id="ECB">
						<common:Name>European Central Bank</common:Name>
					</structure:DataProvider>
				</structure:DataProviderScheme>	
			var extractor:OrganisationSchemeExtractor = new OrganisationSchemeExtractor();
			var item:OrganisationScheme = extractor.extract(xml) as OrganisationScheme;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "DATA_PROVIDERS", item.id);
			assertEquals("The URIs should be null", null, item.uri);
			assertEquals("The URNs should be null", null, item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			assertEquals("The validFrom should be null", null, item.validFrom);
			assertEquals("The validTo should be null", null, item.validTo);			
			assertFalse("The isFinal flag should be equal", item.isFinal);
			assertEquals("SDMX should be the maintenance agency", "SDMX", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Data providers", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The description should be null", null, item.description);
			assertNotNull("The list of organisations cannot be null", item.organisations);
			assertEquals("There should be 1 organisation in the list", 1, item.organisations.length);
			var organisation1:Organisation = item.organisations.getItemAt(0) as Organisation;
			assertNotNull("The organisation 1 cannot be null", organisation1);
			assertTrue("The organisation 1 should be an agency", organisation1 is DataProvider);
			assertEquals("The IDs for organisation 1 should be equal", "ECB", organisation1.id);
			assertNotNull("The name for organisation 1 cannot be null", organisation1.name);
			assertEquals("The name for EN should be equal for organisation 1", "European Central Bank", organisation1.name.localisedStrings.getDescriptionByLocale("en"));
		}
	}
}