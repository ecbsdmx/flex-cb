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
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.base.LocalisedString;
	import mx.resources.Locale;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	
	/**
	 * @private
	 */
	public class CodedMeasureTest extends MeasureTest {

		private var _codeList:CodeList;
		
		public function CodedMeasureTest(methodName:String = null) {
			super(methodName);
		}	
		
		public static function suite():TestSuite {
			return new TestSuite(CodedMeasureTest);
		}
		
		public override function setUp():void {
			super.setUp();
			var clName:InternationalString = new InternationalString();
			clName.localisedStrings.addItem(new LocalisedString(new Locale("en"), "Exch. rate series variation code list"));
			_codeList = new CodeList("CL_EXR_SUFFIX", clName, new MaintenanceAgency("OECB"));
			_codeList.codes.addItem(new Code("A"));
			_codeList.codes.addItem(new Code("B"));
		}
		
		public override function createMeasure():Measure {
			return new CodedMeasure(_id, _item, _codeList);
		}	
		
		public override function testConstructor():void {
			super.testConstructor();
			assertEquals("Local representations should be equal", _codeList, createMeasure().localRepresentation);
		}
	}
}