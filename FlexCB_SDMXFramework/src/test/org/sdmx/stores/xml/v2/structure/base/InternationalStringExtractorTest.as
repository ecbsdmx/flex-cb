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
	import org.sdmx.model.v2.base.InternationalString;

	/**
	 * @private
	 */ 
	public class InternationalStringExtractorTest extends TestCase {

		public function InternationalStringExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(InternationalStringExtractorTest);
		}
		
		public function testInternationalStringExtraction():void {
			var xml:XML = 
				<Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<AnnotationText>Test EN</AnnotationText>
					<AnnotationText xml:lang="fr">Test FR</AnnotationText>
				</Annotation>
			
			var extractor:InternationalStringExtractor = new InternationalStringExtractor();
			var item:InternationalString = extractor.extract(xml.children()) as InternationalString;
			assertEquals("There should be 2 localised strings in this collection", 2, item.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", item.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", item.localisedStrings.getDescriptionByLocale("fr"));		
		}
	}
}