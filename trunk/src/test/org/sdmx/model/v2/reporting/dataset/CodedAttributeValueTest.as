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
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.keyfamily.CodedDataAttribute;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;
	import org.sdmx.model.v2.base.InternationalString;

	/**
	 * @private
	 */
	public class CodedAttributeValueTest extends AttributeValueTest
	{
		private var _value:Code;
		
		private var _valueFor:CodedDataAttribute;
		
		public function CodedAttributeValueTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CodedAttributeValueTest);
		}
		
		public override function setUp():void {
			_value = new Code("F");
			_valueFor = new CodedDataAttribute("test", new Concept("testConcept"), new CodeList("testCl", new InternationalString(), new MaintenanceAgency("ECB")));
			super.setUp();
		}
		
		public override function createAttributeValue():AttributeValue {
			return new CodedAttributeValue(_attachableArtefact, _value, _valueFor);
		}
		
		public function testConstructor():void {
			super.testConstructorSetAndGet();
			assertEquals("The codes should be equal", _value, (_attribute as CodedAttributeValue).value);
			assertEquals("The valuefor should be equal", _valueFor, (_attribute as CodedAttributeValue).valueFor);
			try {
				new CodedAttributeValue(_attachableArtefact, null, _valueFor);
				fail("The code cannot be null");
			} catch (error:ArgumentError) {}
			
			try {
				new CodedAttributeValue(_attachableArtefact, _value, null);
				fail("The coded data attribute cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValue():void {
			assertEquals("The codes should be equal", _value, (_attribute as CodedAttributeValue).value);
			var newValue:Code = new Code("N");
			(_attribute as CodedAttributeValue).value = newValue;
			assertEquals("The new codes should be equal", newValue, (_attribute as CodedAttributeValue).value);
			try {
				(_attribute as CodedAttributeValue).value = null;
				fail("The code cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			assertEquals("The valuefor should be equal", _valueFor, (_attribute as CodedAttributeValue).valueFor);
			var newValueFor:CodedDataAttribute = new CodedDataAttribute("test2", new Concept("testConcept2"), new CodeList("testCl2", new InternationalString(), new MaintenanceAgency("ECB")));
			(_attribute as CodedAttributeValue).valueFor = newValueFor;
			assertEquals("The new valueFor should be equal", newValueFor, (_attribute as CodedAttributeValue).valueFor);
			try {
				(_attribute as CodedAttributeValue).valueFor = null;
				fail("The valueFor cannot be null");
			} catch (error:ArgumentError) {}
		}
	}
}