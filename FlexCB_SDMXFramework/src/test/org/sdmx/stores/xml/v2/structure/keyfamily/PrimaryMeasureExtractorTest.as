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
package org.sdmx.stores.xml.v2.structure.keyfamily
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.Measure;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.base.type.ConceptRole;

	/**
	 * @private
	 */
	public class PrimaryMeasureExtractorTest extends TestCase {
		
		public function PrimaryMeasureExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(PrimaryMeasureExtractorTest);
		}
		
		public function testPrimaryMeasureExtraction():void {
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("OBS_VALUE");
			var concept2:Concept = new Concept("OBS_STATUS");
			var concept3:Concept = new Concept("OBS_CONF");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<PrimaryMeasure conceptRef="OBS_VALUE"/>
			var extractor:PrimaryMeasureExtractor = new PrimaryMeasureExtractor(null, concepts);
			var item:Measure = extractor.extract(xml) as Measure;
			assertNotNull("The item cannot be null", item);
			assertTrue("It should be an uncoded measure", item is UncodedMeasure);
			assertEquals("It should be a primary measure", ConceptRole.PRIMARY_MEASURE, item.conceptRole);
			assertEquals("The 1st concept should be the measure concept", concept1, item.conceptIdentity);
		}
		
		public function testUnknownConcept():void {
			var concepts:Concepts = new Concepts("Concepts");
			var concept2:Concept = new Concept("OBS_STATUS");
			var concept3:Concept = new Concept("OBS_CONF");
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<PrimaryMeasure conceptRef="OBS_VALUE"/>
			var extractor:PrimaryMeasureExtractor = new PrimaryMeasureExtractor(null, concepts);
			try {
				extractor.extract(xml);
				fail("No measure can exist without a concept");
			} catch (error:SyntaxError) {}
		}
	}
}