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

	/**
	 * @private
	 */
	public class AnnotationExtractorTest extends TestCase
	{
		public function AnnotationExtractorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AnnotationExtractorTest);
		}
		
		public function testExtractAnnotationFull():void {
			var test:XML = 
				<Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<AnnotationTitle>Test Annotation</AnnotationTitle>
					<AnnotationType>Text</AnnotationType>
					<AnnotationURL><![CDATA[http://www.ecb.int/]]></AnnotationURL>
					<AnnotationText>Test EN</AnnotationText>
					<AnnotationText xml:lang="fr">Test FR</AnnotationText>
				</Annotation>
			var extractor:AnnotationExtractor = new AnnotationExtractor();
			var annotation:Annotation = extractor.extract(test) as Annotation;
			assertNotNull("The annotation cannot be null", annotation);
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("The titles should be equal", "Test Annotation", annotation.title);
			assertEquals("The URLs should be equal", "http://www.ecb.int/", annotation.url);
			assertEquals("There should be 2 localised strings in this annotation", 2, annotation.text.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", annotation.text.localisedStrings.getDescriptionByLocale("fr"));
		}
		
		public function testExtractAnnotationLight():void {
			var test:XML = 
				<Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<AnnotationType>Text</AnnotationType>
					<AnnotationText>Test EN</AnnotationText>
				</Annotation>
			var extractor:AnnotationExtractor = new AnnotationExtractor();
			var annotation:Annotation = extractor.extract(test) as Annotation;
			assertNotNull("The annotation cannot be null", annotation);
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("There should be 1 localised string in this annotation", 1, annotation.text.localisedStrings.length);			
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
		}
	}
}