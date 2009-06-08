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
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegion;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelection;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamilies;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private
	 */
	public class DataflowExtractorTest extends TestCase {

		public function DataflowExtractorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(DataflowExtractorTest);
		}
		
		public function testDataflowExtraction():void {
			var xml:XML = 
				<Dataflow id="ECB_EXR1_WEB" agencyID="ECB" isFinal="true" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name xml:lang="en">Euro foreign exchange reference rates</Name>
					<KeyFamilyRef>
						<KeyFamilyID>ECB_EXR1</KeyFamilyID>
						<KeyFamilyAgencyID>ECB</KeyFamilyAgencyID>
					</KeyFamilyRef>
				</Dataflow>
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", new Concept("OBS_VALUE")));
				
			var keyFamilies:KeyFamilies = new KeyFamilies();	
			var keyFamily1:KeyFamily = new KeyFamily("ECB_BSI1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			var keyFamily2:KeyFamily = new KeyFamily("ECB_EXR1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);			
			var keyFamily3:KeyFamily = new KeyFamily("ECB_SEC1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			keyFamilies.addItem(keyFamily1);
			keyFamilies.addItem(keyFamily2);
			keyFamilies.addItem(keyFamily3);
			var extractor:DataflowExtractor = new DataflowExtractor(keyFamilies);
			var dataflow:DataflowDefinition = extractor.extract(xml) as DataflowDefinition;
			assertNotNull("The dataflow cannot be null", dataflow);
			assertEquals("The key family should be ECB_EXR1", keyFamily2, dataflow.structure);
			assertEquals("The dataflow ID should be equal", "ECB_EXR1_WEB", dataflow.id);
			assertEquals("The agency ID should be equal", "ECB", dataflow.maintainer.id);
			assertTrue("The dataflow should be final", dataflow.isFinal);
			assertEquals("The name in EN should be equal", "Euro foreign exchange reference rates", dataflow.name.localisedStrings.getDescriptionByLocale("en"));
		}
		
		public function testDataflowExtractionWithNoKF():void {
			var xml:XML = 
				<Dataflow id="ECB_EXR1_WEB" agencyID="ECB" isFinal="true" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name xml:lang="en">Euro foreign exchange reference rates</Name>
					<KeyFamilyRef>
						<KeyFamilyID>ECB_EXR1</KeyFamilyID>
						<KeyFamilyAgencyID>ECB</KeyFamilyAgencyID>
					</KeyFamilyRef>
				</Dataflow>
			var extractor:DataflowExtractor = new DataflowExtractor(null);
			var dataflow:DataflowDefinition = extractor.extract(xml) as DataflowDefinition;
			assertNotNull("The dataflow cannot be null", dataflow);
			assertEquals("The key family should be ECB_EXR1", "ECB_EXR1", dataflow.structure.id);
			assertEquals("The dataflow ID should be equal", "ECB_EXR1_WEB", dataflow.id);
			assertEquals("The agency ID should be equal", "ECB", dataflow.maintainer.id);
			assertTrue("The dataflow should be final", dataflow.isFinal);
			assertEquals("The name in EN should be equal", "Euro foreign exchange reference rates", dataflow.name.localisedStrings.getDescriptionByLocale("en"));
		}
		
		public function testDataflowExtractionWithConstraints():void {
			var xml:XML = 
				<Dataflow id="ECB_EXR1_WEB" agencyID="ECB" isFinal="true" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common">
					<Name xml:lang="en">Euro foreign exchange reference rates</Name>
					<KeyFamilyRef>
						<KeyFamilyID>ECB_EXR1</KeyFamilyID>
						<KeyFamilyAgencyID>ECB</KeyFamilyAgencyID>
					</KeyFamilyRef>
					<Constraint ConstraintType="Content">
		                <common:ConstraintID>ECB_ILM1-CONSTRAINT</common:ConstraintID>
		                <common:CubeRegion isIncluded="true">
		                    <common:Member isIncluded="true">
		                        <common:ComponentRef>FREQ</common:ComponentRef>
		                        <common:MemberValue>
		                            <common:Value>M</common:Value>
		                        </common:MemberValue>
		
		                        <common:MemberValue>
		                            <common:Value>W</common:Value>
		                        </common:MemberValue>
		                    </common:Member>
		                    <common:Member isIncluded="false">
		                        <common:ComponentRef>REF_AREA</common:ComponentRef>
		                        <common:MemberValue>
		                            <common:Value>U2</common:Value>
		
		                        </common:MemberValue>
		                    </common:Member>
						</common:CubeRegion>
					</Constraint>					
				</Dataflow>;
			var key:KeyDescriptor = new KeyDescriptor("key");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			key.addItem(dimension1);
			key.addItem(dimension2);
			key.addItem(dimension3);
			key.addItem(dimension4);
			key.addItem(dimension5);	
			var measure:MeasureDescriptor = new MeasureDescriptor("measures");
			measure.addItem(new UncodedMeasure("measure", new Concept("OBS_VALUE")));
				
			var keyFamilies:KeyFamilies = new KeyFamilies();	
			var keyFamily1:KeyFamily = new KeyFamily("ECB_BSI1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			var keyFamily2:KeyFamily = new KeyFamily("ECB_EXR1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);			
			var keyFamily3:KeyFamily = new KeyFamily("ECB_SEC1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			keyFamilies.addItem(keyFamily1);
			keyFamilies.addItem(keyFamily2);
			keyFamilies.addItem(keyFamily3);
			var extractor:DataflowExtractor = new DataflowExtractor(keyFamilies);
			var dataflow:DataflowDefinition = extractor.extract(xml) as DataflowDefinition;
			assertNotNull("The dataflow cannot be null", dataflow);
			assertEquals("The key family should be ECB_EXR1", keyFamily2, dataflow.structure);
			assertEquals("The dataflow ID should be equal", "ECB_EXR1_WEB", dataflow.id);
			assertEquals("The agency ID should be equal", "ECB", dataflow.maintainer.id);
			assertTrue("The dataflow should be final", dataflow.isFinal);
			assertEquals("The name in EN should be equal", "Euro foreign exchange reference rates", dataflow.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("There should be some content constraint", 
				dataflow.contentConstraint);
			assertEquals("There should be 1 cube", 1, 
				dataflow.contentConstraint.permittedContentRegion.length);
			var cube:CubeRegion = dataflow.contentConstraint.permittedContentRegion.getItemAt(0) as CubeRegion;
			assertTrue("cube should be included", cube.isIncluded);
			assertEquals("There should be 2 members", 2, cube.members.length);
			var m1:MemberSelection = cube.members.getItemAt(0) as MemberSelection;
			var m2:MemberSelection = cube.members.getItemAt(1) as MemberSelection;
			assertTrue("m1 should be included", m1.isIncluded);
			assertEquals("m1 should be on FREQ", "FREQ", m1.structureComponent.conceptIdentity.id);
			assertEquals("m1 should contain 2 values", 2, m1.values.length);
			assertEquals("value 1 is M", "M", m1.values.getItemAt(0));
			assertEquals("value 2 is W", "W", m1.values.getItemAt(1));
			assertEquals("m2 should be on REF_AREA", "REF_AREA", m2.structureComponent.conceptIdentity.id);
			assertEquals("m2 should contain 1 value", 1, m2.values.length);
			assertEquals("value is U2", "U2", m2.values.getItemAt(0));
			assertFalse("m2 should be excluded", m2.isIncluded);
		}
	}
}