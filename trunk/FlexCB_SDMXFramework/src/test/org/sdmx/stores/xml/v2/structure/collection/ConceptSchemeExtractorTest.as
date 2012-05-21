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
	
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.concept.ConceptScheme;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * @private
	 */
	public class ConceptSchemeExtractorTest extends TestCase {
		
		public function ConceptSchemeExtractorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ConceptSchemeExtractorTest);
		}
		
		public function testConceptSchemeExtractionSdmx20():void {
			var xml:XML =
				<ConceptScheme agencyID="ECB" id="AME_CONCEPTS" version="1.0" uri="http://www.sdmx.org/" urn="urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS" isFinal="true" validFrom="2007-01-01" validTo="2008-12-31">
					<Name xml:lang="en">AME concept scheme</Name> 
					<Description xml:lang="en">Test description for the AME concept scheme</Description> 
					<Concept id="AME_AGG_METHOD">
						<Name xml:lang="en">Ameco aggregation method</Name> 
					</Concept>
					<Concept id="AME_ITEM">
						<Name xml:lang="en">Ameco item</Name> 
					</Concept>
					<Concept id="AME_REF_AREA">
						<Name xml:lang="en">Ameco reference area</Name> 
					</Concept>
					<Concept id="AME_REFERENCE">
						<Name xml:lang="en">Ameco reference</Name> 
					</Concept>
					<Concept id="AME_TRANSFORMATION">
						<Name xml:lang="en">Ameco transformation</Name> 
					</Concept>
					<Concept id="AME_UNIT">
						<Name xml:lang="en">Ameco unit</Name> 
					</Concept>
				</ConceptScheme>
			var extractor:ConceptSchemeExtractor = new ConceptSchemeExtractor(null);
			var item:ConceptScheme = extractor.extract(xml) as ConceptScheme;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "AME_CONCEPTS", item.id);
			assertEquals("The URIs should be equal", "http://www.sdmx.org/", item.uri);
			assertEquals("The URNs should be equal", "urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS", item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			var sdmxDate:SDMXDate = new SDMXDate();
			assertEquals("The validFrom should be equal", sdmxDate.getDate("2007-01-01").getTime(), item.validFrom.getTime());
			assertEquals("The validTo should be equal", sdmxDate.getDate("2008-12-31").getTime(), item.validTo.getTime());			
			assertTrue("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "AME concept scheme", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 1 localised strings in the description collection", 1, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Test description for the AME concept scheme", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The list of concepts cannot be null", item.concepts);
			assertEquals("There should be 6 concepts in the list", 6, item.concepts.length);
			var concept1:Concept = item.concepts.getItemAt(0) as Concept;
			var concept2:Concept = item.concepts.getItemAt(5) as Concept;
			assertNotNull("The concept1 cannot be null", concept1);
			assertNotNull("The concept2 cannot be null", concept2);
			assertEquals("The IDs for concept1 should be equal", "AME_AGG_METHOD", concept1.id);
			assertEquals("The IDs for concept1 should be equal", "AME_UNIT", concept2.id);
			assertNotNull("The name for concept1 cannot be null", concept1.name);
			assertNotNull("The name for concept2 cannot be null", concept2.name);			
			assertEquals("The name for EN should be equal for concept1", "Ameco aggregation method", concept1.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The name for EN should be equal for concept2", "Ameco unit", concept2.name.localisedStrings.getDescriptionByLocale("en"));
		}
		
		public function testConceptSchemeExtractionSdmx21():void {
			var xml:XML =
			<ConceptScheme id="AME_CONCEPTS" agencyID="ECB" version="1.0" xmlns="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common">
				<common:Name>AME concept scheme</common:Name>
				<Concept id="AME_AGG_METHOD">
					<common:Name>Ameco aggregation method</common:Name>
				</Concept>
				<Concept id="AME_ITEM">
					<common:Name>Ameco item</common:Name>
				</Concept>
				<Concept id="AME_REFERENCE">
					<common:Name>Ameco reference</common:Name>
				</Concept>
				<Concept id="AME_REF_AREA">
					<common:Name>Ameco reference area</common:Name>
				</Concept>
				<Concept id="AME_TRANSFORMATION">
					<common:Name>Ameco transformation</common:Name>
				</Concept>
				<Concept id="AME_UNIT">
					<common:Name>Ameco unit</common:Name>
				</Concept>
			</ConceptScheme>
			var extractor:ConceptSchemeExtractor = new ConceptSchemeExtractor(null);
			var item:ConceptScheme = extractor.extract(xml) as ConceptScheme;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "AME_CONCEPTS", item.id);
			assertEquals("The versions should be equal", "1.0", item.version);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "AME concept scheme", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The list of concepts cannot be null", item.concepts);
			assertEquals("There should be 6 concepts in the list", 6, item.concepts.length);
			var concept1:Concept = item.concepts.getItemAt(0) as Concept;
			var concept2:Concept = item.concepts.getItemAt(5) as Concept;
			assertNotNull("The concept1 cannot be null", concept1);
			assertNotNull("The concept2 cannot be null", concept2);
			assertEquals("The IDs for concept1 should be equal", "AME_AGG_METHOD", concept1.id);
			assertEquals("The IDs for concept1 should be equal", "AME_UNIT", concept2.id);
			assertNotNull("The name for concept1 cannot be null", concept1.name);
			assertNotNull("The name for concept2 cannot be null", concept2.name);			
			assertEquals("The name for EN should be equal for concept1", "Ameco aggregation method", concept1.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The name for EN should be equal for concept2", "Ameco unit", concept2.name.localisedStrings.getDescriptionByLocale("en"));
		}
	}
}