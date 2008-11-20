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
package org.sdmx.model.v2.structure.keyfamily
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.base.InternationalString;

	/**
	 * @private
	 */
	public class DataflowsCollectionTest extends TestCase {
		
		public function DataflowsCollectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(DataflowsCollectionTest);
		}
		
		public function testAddItem():void {
			var collection:DataflowsCollection = new DataflowsCollection();
			try {
				collection.addItem("Wrong object");
				fail("An collection of dataflows can only contain dataflows");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:DataflowsCollection = new DataflowsCollection();
			try {
				collection.addItemAt("Wrong object", 0);
				fail("An collection of dataflows can only contain dataflows");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:DataflowsCollection = new DataflowsCollection();
			try {
				collection.setItemAt("Wrong object", 0);
				fail("An collection of dataflows can only contain dataflows");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetDataflowById():void {
			var collection:DataflowsCollection = new DataflowsCollection();
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
			var dataflowDef1:DataflowDefinition = new DataflowDefinition("ECB_OFI1_WEB", new InternationalString(), new MaintenanceAgency("ECB"), keyFamily);
			dataflowDef1.version = "1.0";
			dataflows.addItem(dataflowDef1);			
			var dataflowDef2:DataflowDefinition = new DataflowDefinition("ECB_OFI1_WEB", new InternationalString(), new MaintenanceAgency("ECB"), keyFamily);
			dataflowDef2.version = "2.0";
			dataflows.addItem(dataflowDef2);			
			dataflows.addItem(new DataflowDefinition("ECB_OFI1_WEB", new InternationalString(), new MaintenanceAgency("OECD"), keyFamily));						
			assertEquals("dataflowDef1 should be there", dataflowDef1, dataflows.getDataflowById("ECB_OFI1_WEB", "ECB", null));
			assertEquals("dataflowDef2 should be there", dataflowDef2, dataflows.getDataflowById("ECB_OFI1_WEB", "ECB", "2.0"));
			assertNull("No such dataflow!", dataflows.getDataflowById("ECB_OFI1_WEB", "IMF", "2.0"));
		}
	}
}