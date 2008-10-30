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
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class KeyFamiliesTest extends TestCase {
		
		public function KeyFamiliesTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(KeyFamiliesTest);
		}
		
		public function testAddItem():void {
			var collection:KeyFamilies = new KeyFamilies("ad");
			try {
				collection.addItem("Wrong object");
				fail("An collection of key families can only contain key families");
			} catch (error:ArgumentError) {}
		}
		
		public function testAddItemAt():void {
			var collection:KeyFamilies = new KeyFamilies("ad");
			try {
				collection.addItemAt("Wrong object", 0);
				fail("An collection of key families can only contain key families");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetItemAt():void {
			var collection:KeyFamilies = new KeyFamilies("ad");
			try {
				collection.setItemAt("Wrong object", 0);
				fail("An collection of key families can only contain key families");
			} catch (error:ArgumentError) {}
		}
		
		public function testGetKeyFamilyByURI():void {
			var collection:KeyFamilies = new KeyFamilies("ad");
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
			var keyFamily1:KeyFamily = new KeyFamily("test", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			var keyFamily2:KeyFamily = new KeyFamily("ECB_SEC1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);			
			keyFamily1.uri = "http://www.ecb.int/vocabulary/stats/exr/1";
			collection.addItem(keyFamily1);
			collection.addItem(keyFamily2);			
			assertEquals("The key families should be equal", keyFamily1, collection.getKeyFamilyByURI(keyFamily1.uri));
			assertNull("There should be no such key family in the collection", collection.getKeyFamilyByURI("http://www.ecb.int/vocabulary/stats/sec/1"));
		}
		
		public function testGetKeyFamilyByID():void {
			var collection:KeyFamilies = new KeyFamilies("ad");
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
			var keyFamily1:KeyFamily = new KeyFamily("ECB_EXR1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			var keyFamily2:KeyFamily = new KeyFamily("ECB_SEC1", new InternationalString(), new MaintenanceAgency("ECB"), key, measure);
			collection.addItem(keyFamily1);
			assertEquals("The key families should be equal", keyFamily1, collection.getKeyFamilyByID("ECB_EXR1", "ECB"));
			assertNull("There should be no such key family in the collection", collection.getKeyFamilyByID("ECB_OFI1", "ECB"));
		}
	}
}