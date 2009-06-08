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
	import org.sdmx.model.v2.structure.concept.Concepts;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.code.CodeLists;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.base.type.ConceptRole;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;

	/**
	 * @private
	 */
	public class DimensionExtractorTest extends TestCase {
		
		public function DimensionExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(DimensionExtractorTest);
		}
		
		public function testPrimaryMeasureExtraction():void {
			var concepts:Concepts = new Concepts("Concepts");
			var concept1:Concept = new Concept("FREQ");
			var concept2:Concept = new Concept("REF_AREA");
			var concept3:Concept = new Concept("CURRENCY");
			concepts.addItem(concept1);
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var codeLists:CodeLists = new CodeLists("Code lists");
			var codeList1:CodeList = new CodeList("CL_FREQ", new InternationalString(), new MaintenanceAgency("ECB"));
			codeList1.version = "1.0";
			var codeList2:CodeList = new CodeList("CL_FREQ", new InternationalString(), new MaintenanceAgency("ECB"));			
			codeList2.version = "2.0";
			var codeList3:CodeList = new CodeList("CL_FREQ", new InternationalString(), new MaintenanceAgency("OECD"));
			codeList3.version = "2.0";
			codeLists.addItem(codeList1);
			codeLists.addItem(codeList3);
			codeLists.addItem(codeList2);
			var xml:XML =
				<Dimension conceptRef="FREQ" codelist="CL_FREQ" codelistVersion="2.0" codelistAgency="ECB" isFrequencyDimension="true"/>
			var extractor:DimensionExtractor = new DimensionExtractor(codeLists, concepts);
			var item:Dimension = extractor.extract(xml) as Dimension;
			assertNotNull("The item cannot be null", item);
			assertEquals("It should be a frequency dimension", ConceptRole.FREQUENCY, item.conceptRole);
			assertEquals("The 1st concept should be the time concept", concept1, item.conceptIdentity);
			assertEquals("The 2nd code list should be the one", codeList2, item.localRepresentation);
		}
		
		public function testUnknownConcept():void {
			var concepts:Concepts = new Concepts("Concepts");
			var concept2:Concept = new Concept("REF_AREA");
			var concept3:Concept = new Concept("CURRENCY");
			concepts.addItem(concept2);
			concepts.addItem(concept3);
			var xml:XML =
				<Dimension conceptRef="FREQ" codelist="CL_FREQ" isCountDimension="true"/>
			var extractor:DimensionExtractor = new DimensionExtractor(null, concepts);
			try {
				extractor.extract(xml);
				fail("No dimension can exist without a concept");
			} catch (error:SyntaxError) {}
		}
	}
}