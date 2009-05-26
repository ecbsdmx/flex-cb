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
	import org.sdmx.model.v2.base.item.Item;
	import org.sdmx.model.v2.base.Annotation;
	import org.sdmx.model.v2.base.IdentifiableArtefactAdapter;

	/**
	 * @private
	 */
	public class IdentifiableArtefactExtractorTest extends TestCase
	{
		public function IdentifiableArtefactExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(IdentifiableArtefactExtractorTest);
		}
		
		public function testIdentifiableArtefactExtractionFull():void {
			var xml:XML = 				
				<Agency id="ECB" uri="http://www.ecb.int/" urn="INT:ECB:SDMX" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<Name>Test EN</Name> 
					<Name xml:lang="fr">Test FR</Name> 
					<Description>Test Description EN</Description> 
					<Description xml:lang="fr">Test Description FR</Description> 					
					<Annotations>
						<common:Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
							<AnnotationTitle>Test Annotation</AnnotationTitle>
							<AnnotationType>Text</AnnotationType>
							<AnnotationURL><![CDATA[http://www.ecb.int/]]></AnnotationURL>
							<AnnotationText>Test EN</AnnotationText>
							<AnnotationText xml:lang="fr">Test FR</AnnotationText>
						</common:Annotation>
					</Annotations>
				</Agency>
	
			var extractor:IdentifiableArtefactExtractor = new IdentifiableArtefactExtractor();
			var item:IdentifiableArtefactAdapter = extractor.extract(xml) as IdentifiableArtefactAdapter;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "ECB", item.id);
			assertEquals("The URIs should be equal", "http://www.ecb.int/", item.uri);
			assertEquals("The URNs should be equal", "INT:ECB:SDMX", item.urn);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 2 localised strings in the name collection", 2, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Test EN", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The names for FR should be equal", "Test FR", item.name.localisedStrings.getDescriptionByLocale("fr"));			
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 2 localised strings in the description collection", 2, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Test Description EN", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The descriptions for FR should be equal", "Test Description FR", item.description.localisedStrings.getDescriptionByLocale("fr"));			
			/*assertEquals("There should be 1 annotation", 1, item.annotations.length);
			var annotation:Annotation = item.annotations.getItemAt(0) as Annotation;
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("The titles should be equal", "Test Annotation", annotation.title);
			assertEquals("The URLs should be equal", "http://www.ecb.int/", annotation.url);
			assertEquals("There should be 2 localised strings in this annotation", 2, annotation.text.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", annotation.text.localisedStrings.getDescriptionByLocale("fr"));*/
		}	
		
		public function testNoId():void {
			var xml:XML = 				
				<Agency xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name>Test EN</Name> 
				</Agency>
	
			var extractor:IdentifiableArtefactExtractor = new IdentifiableArtefactExtractor();
			try {
				extractor.extract(xml);
				fail("No id should trigger an error");
			} catch (error:SyntaxError){}
		}
		
		public function testIdentifiableArtefactExtractionLight():void {
			var xml:XML = 				
				<Agency id="ECB" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name>Test EN</Name> 
				</Agency>
	
			var extractor:IdentifiableArtefactExtractor = new IdentifiableArtefactExtractor();
			var item:IdentifiableArtefactAdapter = extractor.extract(xml) as IdentifiableArtefactAdapter;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "ECB", item.id);
			assertNull("The URIs should be null", item.uri);
			assertNull("The URNs should be null", item.urn);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised string in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Test EN", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNull("The description should be null", item.description);
			assertNull("There should be no annotations", item.annotations);
		}
	}
}