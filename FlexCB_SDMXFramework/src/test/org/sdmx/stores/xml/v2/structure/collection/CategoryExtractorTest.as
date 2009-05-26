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
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private
	 */
	public class CategoryExtractorTest extends TestCase {
		
		public function CategoryExtractorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CategoryExtractorTest);
		}
		
		public function testExtractCategory():void {
			var xml:XML = 
				<Category id="exr1" version="1.0" uri="http://www.sdmx.org" urn="UID" xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure">
					<Name xml:lang="en">Euro foreign exchange reference rates</Name>
					<Description xml:lang="en">Euro foreign exchange reference rates section on the ECB website</Description>
					<DataflowRef>
						<AgencyID>ECB</AgencyID>
						<DataflowID>ECB_EXR1_WEB</DataflowID>
					</DataflowRef>
					<Category version="1.0" id="2120778">
						<Name xml:lang="en">Consumer price indices</Name>
					</Category>
				</Category>
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
			var keyFamily:KeyFamily = new KeyFamily("ECB_EXR1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			var dataflows:DataflowsCollection = new DataflowsCollection();
			dataflows.addItem(new DataflowDefinition("ECB_EXR1_WEB", new InternationalString(), new MaintenanceAgency("ECB"), keyFamily));
			dataflows.addItem(new DataflowDefinition("ECB_OFI1_WEB", new InternationalString(), new MaintenanceAgency("ECB"), keyFamily));			
			var extractor:CategoryExtractor = new CategoryExtractor(dataflows);
			var category:Category = extractor.extract(xml) as Category;	
			assertNotNull("The category cannot be null", category);
			assertEquals("The id should be equal", "exr1", category.id);
			assertEquals("The version should be equal", "1.0", category.version);
			assertEquals("The URI should be equal", "http://www.sdmx.org", category.uri);
			assertEquals("The URN should be equal", "UID", category.urn);
			assertEquals("The EN names should be equal", "Euro foreign exchange reference rates", category.name.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("The EN descriptions should be equal", "Euro foreign exchange reference rates section on the ECB website", category.description.localisedStrings.getDescriptionByLocale("en"));			
			assertEquals("There should be one dataflow attached to the category", 1, category.dataflows.length);
			var dataflow:DataflowDefinition = category.dataflows.getItemAt(0) as DataflowDefinition;
			assertEquals("The dataflow id should be equal", "ECB_EXR1_WEB", dataflow.id);
			assertEquals("The dataflow agency id should be equal", "ECB", dataflow.maintainer.id);
			assertTrue("There should be one subcategory", category.categories.length == 1);
			var subcategory:Category = 
				category.categories.getItemAt(0) as Category;
			assertEquals("The id should be equal", "2120778", subcategory.id);
			assertEquals("The EN names should be equal", "Consumer price indices", 
				subcategory.name.localisedStrings.getDescriptionByLocale("en"));
		}
	}
}