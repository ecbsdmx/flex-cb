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
		
		public function testExtractOrganisationScheme():void {
			var xml:XML = 
				<OrganisationScheme id="ESCB" agencyID="ECB" isFinal="true" uri="http://www.ecb.int" urn="ECB:DESC" validFrom="2007-07-28" validTo="2007-07-29" version="1.0">
					<Name xml:lang="en">The European System of Central Banks</Name>
					<Description>The European System of Central Banks (Desc)</Description>
					<DataProviders>
						<DataProvider id="ECB">
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
			assertEquals("There should be 1 organisation in the list", 1, item.organisations.length);
			var organisation:Organisation = item.organisations.getItemAt(0) as Organisation;
			assertNotNull("The organisation cannot be null", organisation);
			assertTrue("The organisation should be a data provider", organisation is DataProvider);
			assertEquals("The IDs for organisation should be equal", "ECB", organisation.id);
			assertNotNull("The name for organisation cannot be null", organisation.name);
			assertEquals("The name for EN should be equal for organisation", "European Central Bank", organisation.name.localisedStrings.getDescriptionByLocale("en"));
		}
	}
}