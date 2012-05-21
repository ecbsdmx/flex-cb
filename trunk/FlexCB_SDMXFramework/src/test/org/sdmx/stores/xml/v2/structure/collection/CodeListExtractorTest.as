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
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.util.date.SDMXDate;

	/**
	 * @private
	 */
	public class CodeListExtractorTest extends TestCase {
		
		public function CodeListExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodeListExtractorTest);
		}
		
		public function testCodeListExtractionSdmx20():void {
			var xml:XML = 
				<CodeList agencyID="ECB" id="CL_COLLECTION" version="1.0" uri="http://www.sdmx.org/" urn="urn:sdmx:org.sdmx.infomodel.codelist.CodeList=ECB:CL_COLLECTION" isFinal="true" validFrom="2007-01-01" validTo="2008-12-31" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<Name xml:lang="en">Collection indicator code list</Name>
					<Description xml:lang="en">Test description for the Collection indicator code list</Description>
					<Code value="A" urn="urn:sdmx:org.sdmx.infomodel.codelist.CodeList=ECB:CL_COLLECTION.Code=A">
						<Description xml:lang="en">Average of observations through period</Description>
					</Code>
					<Code value="B">
						<Description xml:lang="en">Beginning of period</Description>
					</Code>
					<Code value="E">
						<Description xml:lang="en">End of period</Description>
					</Code>
					<Code value="H">
						<Description xml:lang="en">Highest in period</Description>
					</Code>
					<Code value="L">
						<Description xml:lang="en">Lowest in period</Description>
					</Code>
					<Code value="M">
						<Description xml:lang="en">Middle of period</Description>
					</Code>
					<Code value="S">
						<Description xml:lang="en">Summed through period</Description>
					</Code>
					<Code value="U">
						<Description xml:lang="en">Unknown</Description>
					</Code>
					<Code value="V">
						<Description xml:lang="en">Other</Description>
					</Code>
					<Code value="Y">
						<Description xml:lang="en">Annualised summed</Description>
					</Code>
					<Annotations>
						<common:Annotation xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
							<AnnotationTitle>Test Annotation</AnnotationTitle>
							<AnnotationType>Text</AnnotationType>
							<AnnotationURL><![CDATA[http://www.ecb.int/]]></AnnotationURL>
							<AnnotationText>Test EN</AnnotationText>
							<AnnotationText xml:lang="fr">Test FR</AnnotationText>
						</common:Annotation>
					</Annotations>
				</CodeList> 

			var extractor:CodeListExtractor = new CodeListExtractor();
			var item:CodeList = extractor.extract(xml) as CodeList;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "CL_COLLECTION", item.id);
			assertEquals("The URIs should be equal", "http://www.sdmx.org/", item.uri);
			assertEquals("The URNs should be equal", "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=ECB:CL_COLLECTION", item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			var sdmxDate:SDMXDate = new SDMXDate();
			assertEquals("The validFrom should be equal", sdmxDate.getDate("2007-01-01").getTime(), item.validFrom.getTime());
			assertEquals("The validTo should be equal", sdmxDate.getDate("2008-12-31").getTime(), item.validTo.getTime());			
			assertTrue("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Collection indicator code list", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 1 localised strings in the description collection", 1, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Test description for the Collection indicator code list", item.description.localisedStrings.getDescriptionByLocale("en"));
			/*assertEquals("There should be 1 annotation", 1, item.annotations.length);
			var annotation:Annotation = item.annotations.getItemAt(0) as Annotation;
			assertEquals("The types should be equal", "Text", annotation.type);
			assertEquals("The titles should be equal", "Test Annotation", annotation.title);
			assertEquals("The URLs should be equal", "http://www.ecb.int/", annotation.url);
			assertEquals("There should be 2 localised strings in this annotation", 2, annotation.text.localisedStrings.length);
			assertEquals("The EN text should be equal", "Test EN", annotation.text.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The FR text should be equal", "Test FR", annotation.text.localisedStrings.getDescriptionByLocale("fr"));*/
			assertNotNull("The list of codes cannot be null", item.codes);
			assertEquals("There should be 10 codes in the list", 10, item.codes.length);
			var code1:Code = item.codes.getItemAt(0) as Code;
			var code2:Code = item.codes.getItemAt(9) as Code;
			assertNotNull("The code1 cannot be null", code1);
			assertNotNull("The code2 cannot be null", code2);
			assertEquals("The IDs for code1 should be equal", "A", code1.id);
			assertEquals("The IDs for code1 should be equal", "Y", code2.id);
			assertEquals("The URNs for code1 should be equal", "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=ECB:CL_COLLECTION.Code=A", code1.urn);
			assertNull("There should be no URN for code2", code2.urn);
			assertNotNull("The description for code1 cannot be null", code1.description);
			assertNotNull("The description for code2 cannot be null", code2.description);			
			assertEquals("There should be 1 localised strings in the description collection for code1", 1, code1.description.localisedStrings.length);
			assertEquals("There should be 1 localised strings in the description collection for code2", 1, code2.description.localisedStrings.length);			
			assertEquals("The descriptions for EN should be equal for code1", "Average of observations through period", code1.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The descriptions for EN should be equal for code2", "Annualised summed", code2.description.localisedStrings.getDescriptionByLocale("en"));			
		}
		
		public function testCodeListExtractionSdmx21():void {
			var xml:XML = 
			<structure:Codelist isFinal="true" version="1.0" isExternalReference="false"
				validFrom="2010-01-01T00:00:00Z" validTo="2010-12-31T23:59:59Z" agencyID="ECB" id="CL_OBS_CONF"
				urn="urn:sdmx:org.sdmx.infomodel.codelist.Codelist=ECB:CL_OBS_CONF[1.0]"
				xmlns:structure="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" 
				xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common">
				<common:Name>Observation confidentiality code list</common:Name>
				<common:Description>Test description in English</common:Description>				
				<structure:Code id="C">
					<common:Name>Confidential statistical information</common:Name>
				</structure:Code>
				<structure:Code id="D">
					<common:Name>Secondary confidentiality set by the sender,
						not for publication</common:Name>
				</structure:Code>
				<structure:Code id="F">
					<common:Name>Free</common:Name>
				</structure:Code>
				<structure:Code id="N">
					<common:Name>Not for publication, restricted for internal
						use only</common:Name>
				</structure:Code>
				<structure:Code id="S">
					<common:Name>Secondary confidentiality set and managed by the receiver, not for publication</common:Name>
				</structure:Code>
			</structure:Codelist>

			var extractor:CodeListExtractor = new CodeListExtractor();
			var item:CodeList = extractor.extract(xml) as CodeList;
			assertNotNull("The item cannot be null", item);
			assertEquals("The IDs should be equal", "CL_OBS_CONF", item.id);
			assertEquals("The URNs should be equal", "urn:sdmx:org.sdmx.infomodel.codelist.Codelist=ECB:CL_OBS_CONF[1.0]", item.urn);
			assertEquals("The versions should be equal", "1.0", item.version);
			var sdmxDate:SDMXDate = new SDMXDate();
			assertEquals("The validFrom should be equal", sdmxDate.getDate("2010-01-01T00:00:00Z").getTime(), item.validFrom.getTime());
			assertEquals("The validTo should be equal", sdmxDate.getDate("2010-12-31T23:59:59Z").getTime(), item.validTo.getTime());			
			assertTrue("The isFinal flag should be equal", item.isFinal);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "Observation confidentiality code list", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 1 localised strings in the description collection", 1, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "Test description in English", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The list of codes cannot be null", item.codes);
			assertEquals("There should be 5 codes in the list", 5, item.codes.length);
			var code1:Code = item.codes.getItemAt(0) as Code;
			var code2:Code = item.codes.getItemAt(4) as Code;
			assertNotNull("The code1 cannot be null", code1);
			assertNotNull("The code2 cannot be null", code2);
			assertEquals("The IDs for code1 should be equal", "C", code1.id);
			assertEquals("The IDs for code1 should be equal", "S", code2.id);
			assertNull("There should be no URN for code1", code1.urn);
			assertNull("There should be no URN for code2", code2.urn);
			assertNotNull("The description for code1 cannot be null", code1.description);
			assertNotNull("The description for code2 cannot be null", code2.description);			
			assertEquals("There should be 1 localised strings in the description collection for code1", 1, code1.description.localisedStrings.length);
			assertEquals("There should be 1 localised strings in the description collection for code2", 1, code2.description.localisedStrings.length);			
			assertEquals("The descriptions for EN should be equal for code1", "Confidential statistical information", code1.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The descriptions for EN should be equal for code2", "Secondary confidentiality set and managed by the receiver, not for publication", code2.description.localisedStrings.getDescriptionByLocale("en"));			
		}
	}
}