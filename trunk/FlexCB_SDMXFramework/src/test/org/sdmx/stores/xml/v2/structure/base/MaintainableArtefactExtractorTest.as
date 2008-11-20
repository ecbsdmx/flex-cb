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
package org.sdmx.stores.xml.v2.structure.base
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.base.Annotation;
	import org.sdmx.model.v2.base.MaintainableArtefact;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * @private
	 */
	public class MaintainableArtefactExtractorTest extends TestCase {
		
		public function MaintainableArtefactExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(MaintainableArtefactExtractorTest);
		}
		
		public function testMaintainableArtefactExtractionFull():void {
			var xml:XML = 
				<ConceptScheme agencyID="ECB" id="AME_CONCEPTS" version="1.0" uri="http://www.sdmx.org/" urn="urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS" isFinal="true" validFrom="2007-01-01" validTo="2008-12-31" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
  					<Name>AME concept scheme</Name> 
  					<Name xml:lang="fr">Collection de concepts pour AME</Name> 
					<Description>Test description for the AME concept scheme</Description> 
					<Description xml:lang="fr">Description bidon pour AME</Description> 
					<Annotations>
						<common:Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
							<AnnotationTitle>Test Annotation</AnnotationTitle>
							<AnnotationType>Text</AnnotationType>
							<AnnotationURL><![CDATA[http://www.ecb.int/]]></AnnotationURL>
							<AnnotationText>Test EN</AnnotationText>
							<AnnotationText xml:lang="fr">Test FR</AnnotationText>
						</common:Annotation>
					</Annotations>
				</ConceptScheme>	

			var extractor:MaintainableArtefactExtractor = new MaintainableArtefactExtractor();
			var item:MaintainableArtefact = extractor.extract(xml) as MaintainableArtefact;
			var sdmxDate:SDMXDate = new SDMXDate();
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "AME_CONCEPTS", item.id);
			assertEquals("The URIs should be equal", "http://www.sdmx.org/", item.uri);
			assertEquals("The URNs should be equal", "urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS", item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			assertEquals("The validFrom should be equal", sdmxDate.getDate("2007-01-01").getTime(), item.validFrom.getTime());
			assertEquals("The validTo should be equal", sdmxDate.getDate("2008-12-31").getTime(), item.validTo.getTime());			
			assertTrue("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 2 localised strings in the name collection", 2, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "AME concept scheme", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The names for FR should be equal", "Collection de concepts pour AME", item.name.localisedStrings.getDescriptionByLocale("fr"));			
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 2 localised strings in the description collection", 2, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Test description for the AME concept scheme", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The descriptions for FR should be equal", "Description bidon pour AME", item.description.localisedStrings.getDescriptionByLocale("fr"));			
			/*assertEquals("There should be 1 annotation", 1, item.annotations.length);
			var annotation:Annotation = item.annotations.getItemAt(0) as Annotation;
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("The titles should be equal", "Test Annotation", annotation.title);
			assertEquals("The URLs should be equal", "http://www.ecb.int/", annotation.url);
			assertEquals("There should be 2 localised strings in this annotation", 2, annotation.text.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", annotation.text.localisedStrings.getDescriptionByLocale("fr"));*/	
		}
		
		public function testMaintainableArtefactExtractionLight():void {
			var xml:XML = 
				<ConceptScheme agencyID="ECB" id="AME_CONCEPTS" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
  					<Name>AME concept scheme</Name> 
				</ConceptScheme>	

			var extractor:MaintainableArtefactExtractor = new MaintainableArtefactExtractor();
			var item:MaintainableArtefact = extractor.extract(xml) as MaintainableArtefact;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "AME_CONCEPTS", item.id);
			assertNull("The URIs should be null", item.uri);
			assertNull("The URNs should be null", item.urn);
			assertNull("The version should be null", item.version);
			assertNull("The validFrom should be null", item.validFrom);
			assertNull("The validTo should be null", item.validTo);			
			assertFalse("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised string in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "AME concept scheme", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNull("The description should be null", item.description);
			assertNull("There should be no annotations", item.annotations);
		}
		
		public function testNoAgencyId():void {
			var xml:XML = 
				<ConceptScheme id="AME_CONCEPTS" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
  					<Name>AME concept scheme</Name> 
				</ConceptScheme>	

			var extractor:MaintainableArtefactExtractor = new MaintainableArtefactExtractor();
			try {
				extractor.extract(xml) as MaintainableArtefact;
				fail("agencyID is mandatory!");
			} catch (error:SyntaxError) {}
		}
	}
}