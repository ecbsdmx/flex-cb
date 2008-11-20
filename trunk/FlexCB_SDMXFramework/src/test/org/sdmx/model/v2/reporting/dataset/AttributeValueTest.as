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
	import flexunit.framework.TestCase;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;

	/**
	 * @private
	 */
	public class AttributeValueTest extends TestCase
	{
		
		protected var _attribute:AttributeValue;
		
		protected var _attachableArtefact:AttachableArtefact;
		
		public function AttributeValueTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttributeValueTest);
		}
		
		public override function setUp():void {
			super.setUp();
			_attachableArtefact = new DataSet();
			_attribute = createAttributeValue();
		}
		
		public function createAttributeValue():AttributeValue {
			return new AttributeValue(_attachableArtefact);
		}
		
		public function testConstructorSetAndGet():void {
			assertEquals("The attachable artefacts should be equal", _attachableArtefact, _attribute.attachesTo);
			var newAttachment:AttachableArtefact = 
				new UncodedObservation("test", new UncodedMeasure("measure", new Concept("concept")));
			_attribute.attachesTo = newAttachment;
			assertEquals("The new attachable artefacts should be equal", newAttachment, _attribute.attachesTo);
			try {
				_attribute.attachesTo = null;
				fail("The attachable artefact cannot be null");
			} catch (error:ArgumentError) {}
		}
	}
}