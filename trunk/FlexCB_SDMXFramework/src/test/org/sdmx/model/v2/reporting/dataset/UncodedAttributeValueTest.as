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
	import org.sdmx.model.v2.structure.keyfamily.UncodedDataAttribute;
	import org.sdmx.model.v2.structure.concept.Concept;
	import flexunit.framework.TestSuite;
	
	/**
	 * @private
	 */
	public class UncodedAttributeValueTest extends AttributeValueTest
	{
		private var _value:String;
		
		private var _valueFor:UncodedDataAttribute;
		
		public function UncodedAttributeValueTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(UncodedAttributeValueTest);
		}
		
		public override function setUp():void {
			_value = "apo";
			_valueFor = new UncodedDataAttribute("attr", new Concept("test"));
			super.setUp();
		}
		
		public override function createAttributeValue():AttributeValue {
			return new UncodedAttributeValue(_attachableArtefact, _value, _valueFor);
		}
		
		public function testConstructor():void {
			super.testConstructorSetAndGet();
			assertEquals("The codes should be equal", _value, (_attribute as UncodedAttributeValue).value);
			assertEquals("The valuefor should be equal", _valueFor, (_attribute as UncodedAttributeValue).valueFor);
			try {
				new UncodedAttributeValue(_attachableArtefact, null, _valueFor);
				fail("The value cannot be null");
			} catch (error:ArgumentError) {}
			
			try {
				new UncodedAttributeValue(_attachableArtefact, _value, null);
				fail("The uncoded data attribute cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValue():void {
			assertEquals("The values should be equal", _value, (_attribute as UncodedAttributeValue).value);
			var newValue:String = "test";
			(_attribute as UncodedAttributeValue).value = newValue;
			assertEquals("The new values should be equal", newValue, (_attribute as UncodedAttributeValue).value);
			try {
				(_attribute as UncodedAttributeValue).value = null;
				fail("The value cannot be null");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			assertEquals("The valuefor should be equal", _valueFor, (_attribute as UncodedAttributeValue).valueFor);
			var newValueFor:UncodedDataAttribute = new UncodedDataAttribute("attr2", new Concept("Test2"));
			(_attribute as UncodedAttributeValue).valueFor = newValueFor;
			assertEquals("The new valueFor should be equal", newValueFor, (_attribute as UncodedAttributeValue).valueFor);
			try {
				(_attribute as UncodedAttributeValue).valueFor = null;
				fail("The valueFor cannot be null");
			} catch (error:ArgumentError) {}
		}
	}
}