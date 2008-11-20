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
package org.sdmx.stores.xml.v2.structure.collection
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.category.CategoryScheme;
	import org.sdmx.model.v2.structure.category.Category;
	import org.sdmx.model.v2.structure.keyfamily.DataflowDefinition;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.MeasureDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.keyfamily.KeyFamily;
	import org.sdmx.model.v2.structure.keyfamily.DataflowsCollection;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

	/**
	 * @private
	 */
	public class CategorySchemeExtractorTest extends TestCase {
		
		public function CategorySchemeExtractorTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CategorySchemeExtractorTest);
		}
		
		public function testExtractCategoryScheme():void {
			var xml:XML = 
				<CategoryScheme id="ECBCategories" agencyID="ECB">
					<Name xml:lang="en">ECB website categories</Name>
					<Description xml:lang="en">ECB website categories (DESC)</Description>
					<Category id="exr1">
						<Name xml:lang="en">Euro foreign exchange reference rates</Name>
						<DataflowRef>
							<AgencyID>ECB</AgencyID>
							<DataflowID>ECB_EXR1_WEB</DataflowID>
						</DataflowRef>
					</Category>
				</CategoryScheme>
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
			var extractor:CategorySchemeExtractor = new CategorySchemeExtractor(dataflows);
			var item:CategoryScheme = extractor.extract(xml) as CategoryScheme;
			assertNotNull("The scheme cannot be null", item);	
			assertEquals("The IDs should be equal", "ECBCategories", item.id);
			assertEquals("The ECB should be the maintenance agency", "ECB", item.maintainer.id);
			assertNotNull("The name cannot be null", item.name);
			assertEquals("There should be 1 localised strings in the name collection", 1, item.name.localisedStrings.length);
			assertEquals("The names for EN should be equal", "ECB website categories", item.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The description cannot be null", item.description);
			assertEquals("There should be 1 localised strings in the description collection", 1, item.description.localisedStrings.length);
			assertEquals("The descriptions for EN should be equal", "ECB website categories (DESC)", item.description.localisedStrings.getDescriptionByLocale("en"));
			assertEquals("There should be 1 category in the list", 1, item.categories.length);
			var category:Category = item.categories.getItemAt(0) as Category;
			assertNotNull("The category cannot be null", category);
			assertEquals("The IDs for category should be equal", "exr1", category.id);
			assertNotNull("The names for the category cannot be null", category.name);
			assertEquals("There should be 1 localised strings in the names collection for the category", 1, category.name.localisedStrings.length);
			assertEquals("The names for EN should be equal for the category", "Euro foreign exchange reference rates", category.name.localisedStrings.getDescriptionByLocale("en"));
			assertNotNull("The dataflows cannot be null", category.dataflows);			
			assertEquals("There should be 1 dataflow in the collection", 1, category.dataflows.length);
			assertEquals("The dataflow id should be equal", "ECB_EXR1_WEB", (category.dataflows.getItemAt(0) as DataflowDefinition).id);
		}
	}
}