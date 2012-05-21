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
	import org.sdmx.model.v2.base.Annotation;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class ConceptExtractorTest extends TestCase {

		public function ConceptExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ConceptExtractorTest);
		}
		
		public function testConceptExtractionFull():void {
			var xml:XML = 
				<Concept id="ADJU_DETAIL" version="1.0" uri="http://www.sdmx.org/" urn="urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS"  xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<Name>Adjustment detail</Name>
					<Name xml:lang="fr">Adjustment detail (FR)</Name>			
					<Description>Average of observations through period</Description>
					<Description xml:lang="fr">Average of observations through period (in French)</Description>
					<Annotations>
						<common:Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
							<AnnotationTitle>Test Annotation</AnnotationTitle>
							<AnnotationType>Text</AnnotationType>
							<AnnotationURL>http://www.ecb.int/</AnnotationURL>
							<AnnotationText xml:lang="en">Test EN</AnnotationText>
							<AnnotationText xml:lang="fr">Test FR</AnnotationText>
						</common:Annotation>
					</Annotations>
				</Concept>	
			var extractor:ConceptExtractor = new ConceptExtractor(null);
			var item:Concept = extractor.extract(xml) as Concept;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "ADJU_DETAIL", item.id);
			assertEquals("The URNs should be equal", "urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS", item.urn);
			assertEquals("The URIs should be equal", "http://www.sdmx.org/", item.uri);
			assertEquals("The versions should be equal", "1.0", item.version);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 2 localised strings in the name collection", 2, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Adjustment detail", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The names for FR should be equal", "Adjustment detail (FR)", item.name.localisedStrings.getDescriptionByLocale("fr"));			
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 2 localised strings in the description collection", 2, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Average of observations through period", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The descriptions for FR should be equal", "Average of observations through period (in French)", item.description.localisedStrings.getDescriptionByLocale("fr"));			
			/*assertEquals("There should be 1 annotation", 1, item.annotations.length);
			var annotation:Annotation = item.annotations.getItemAt(0) as Annotation;
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("The titles should be equal", "Test Annotation", annotation.title);
			assertEquals("The URLs should be equal", "http://www.ecb.int/", annotation.url);
			assertEquals("There should be 2 localised strings in this annotation", 2, annotation.text.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", annotation.text.localisedStrings.getDescriptionByLocale("fr"));*/	
		}
		
		public function testNoName():void {
			var xml:XML = 
				<Concept id="ADJU_DETAIL" version="1.0" uri="http://www.sdmx.org/" urn="urn:sdmx:org.sdmx.infomodel.concepscheme.ConceptScheme=ECB:AME_CONCEPTS"  xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<Description>Average of observations through period</Description>
					<Description xml:lang="fr">Average of observations through period (in French)</Description>
					<Annotations>
						<common:Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
							<AnnotationTitle>Test Annotation</AnnotationTitle>
							<AnnotationType>Text</AnnotationType>
							<AnnotationURL>http://www.ecb.int/</AnnotationURL>
							<AnnotationText xml:lang="en">Test EN</AnnotationText>
							<AnnotationText xml:lang="fr">Test FR</AnnotationText>
						</common:Annotation>
					</Annotations>
				</Concept>
			var extractor:ConceptExtractor = new ConceptExtractor(null);
			try {
				extractor.extract(xml);
				fail("Name is mandatory!");
			} catch (error:SyntaxError) {}	
		}
	}
}