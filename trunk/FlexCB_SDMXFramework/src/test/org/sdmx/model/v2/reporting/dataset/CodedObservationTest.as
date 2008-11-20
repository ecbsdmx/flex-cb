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
package org.sdmx.model.v2.reporting.dataset
{
	import flexunit.framework.TestCase;
	import org.sdmx.model.v2.structure.keyfamily.CodedMeasure;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.InternationalString;
	import mx.resources.Locale;
	import org.sdmx.model.v2.base.LocalisedString;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class CodedObservationTest extends TestCase {
		
		private var _codeList:CodeList;
		
		public function CodedObservationTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodedObservationTest);
		}
		
		public override function setUp():void {
			super.setUp();
			var clName:InternationalString = new InternationalString();
			clName.localisedStrings.addItem(new LocalisedString(new Locale("en"), "Exch. rate series variation code list"));
			_codeList = new CodeList("CL_EXR_SUFFIX", clName, new MaintenanceAgency("OECB"));
			_codeList.codes.addItem(new Code("A"));
			_codeList.codes.addItem(new Code("B"));
		}
		
		public function testConstrutor():void {
			var measure:CodedMeasure = new CodedMeasure("measure", new Concept("concept"), _codeList);
			var code:Code = new Code("A");
			var obs:CodedObservation = new CodedObservation(code, measure);
			assertEquals("The values should be equal", code, obs.value);
			assertEquals("The valueFor should be equal", measure, obs.valueFor);
			try {
				var obs2:CodedObservation = new CodedObservation(null, measure);
				fail("It should not be possible to construct a Coded measure with a null code");
			} catch (error:ArgumentError) {}
			try {
				var obs3:CodedObservation = new CodedObservation(code, null);
				fail("It should not be possible to construct a Coded measure with a null measure");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValue():void {
			var measure:CodedMeasure = new CodedMeasure("measure", new Concept("concept"), _codeList);
			var code:Code = new Code("A");
			var code2:Code = new Code("B");
			var obs:CodedObservation = new CodedObservation(code, measure);
			assertEquals("The values should be equal", code, obs.value);
			obs.value = code2;
			assertEquals("The new values should be equal", code2, obs.value);
			try {
				obs.value = null;
				fail("It should not be possible to set a null code");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			var measure:CodedMeasure = new CodedMeasure("measure", new Concept("concept"), _codeList);
			var code:Code = new Code("A");
			var obs:CodedObservation = new CodedObservation(code, measure);
			assertEquals("The valueFor should be equal", measure, obs.valueFor);
			var measure2:CodedMeasure = new CodedMeasure("measure2", new Concept("new concept"), _codeList);
			obs.valueFor = measure2;
			assertEquals("The new valueFor should be equal", measure2, obs.valueFor);
			try {
				obs.valueFor = null;
				fail("It should not be possible to pass a null measure");
			} catch (error:ArgumentError) {}
		}	
	}
}