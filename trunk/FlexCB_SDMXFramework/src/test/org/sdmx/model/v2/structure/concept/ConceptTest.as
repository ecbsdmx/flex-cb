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
package org.sdmx.model.v2.structure.concept
{
	import org.sdmx.model.v2.base.item.ItemTest;
	import org.sdmx.model.v2.base.item.Item;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.LocalisedString;
	import mx.resources.Locale;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.base.type.DataType;
	
	/**
	 * @private 
	 */
	public class ConceptTest extends ItemTest
	{
		
		public function ConceptTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function createItem():Item {
			return createConcept();
		}
		
		public function createConcept():Concept {
			return new Concept(_id);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ConceptTest);
		}
		
		public function testRepresentation():void {
			var conceptName:InternationalString = new InternationalString();
			conceptName.localisedStrings.addItem(new LocalisedString(new Locale("en"), "Exchange rate type"));
			var exrType:Concept = new Concept("EXR_TYPE");
			exrType.name = conceptName;
			assertNull("By default, there is no core representation", exrType.coreRepresentation);

			var clName:InternationalString = new InternationalString();
			clName.localisedStrings.addItem(new LocalisedString(new Locale("en"), "Exch. rate series variation code list"));
			var codeList:CodeList = new CodeList("CL_EXR_SUFFIX", clName, new MaintenanceAgency("OECB"));
			codeList.codes.addItem(new Code("A"));
			codeList.codes.addItem(new Code("B"));
			exrType.coreRepresentation = codeList;
			assertEquals("Core representations should be equal", codeList, exrType.coreRepresentation);
		}
		
		public function testType():void {
			var exrType:Concept = new Concept("EXR_TYPE");
			assertNull("No core type should be set by default", exrType.coreType);
			exrType.coreType = DataType.DATE_TIME;
			assertEquals("The core types should be equal", DataType.DATE_TIME, exrType.coreType);
			try {
				exrType.coreType = "My own self-made non-SDMX data type";
				fail("It should not be possible to add non SDMX data types as core type");
			} catch (error:TypeError){}
		}
	}
}