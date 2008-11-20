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
	import org.sdmx.model.v2.base.structure.StructureTest;
	import org.sdmx.model.v2.base.structure.Structure;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */
	public class KeyFamilyTest extends StructureTest
	{
		private var _keyFamily:KeyFamily;
		
		private var _key:KeyDescriptor;
		
		private var _measure:MeasureDescriptor;
		
		public function KeyFamilyTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			_key = new KeyDescriptor("key");
			var dimension1:Dimension = new Dimension("dim1", new Concept("FREQ"));
			var dimension2:Dimension = new Dimension("dim2", new Concept("CURRENCY"));
			var dimension3:Dimension = new Dimension("dim3", new Concept("CURRENCY_DENOM"));
			var dimension4:Dimension = new Dimension("dim4", new Concept("EXR_TYPE"));
			var dimension5:Dimension = new Dimension("dim5", new Concept("EXR_SUFFIX"));
			_key.addItem(dimension1);
			_key.addItem(dimension2);
			_key.addItem(dimension3);
			_key.addItem(dimension4);
			_key.addItem(dimension5);	
			_measure = new MeasureDescriptor("measures");
			_measure.addItem(new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			_keyFamily = createKeyFamily();
			super.setUp();
		}
				
		public override function createStructure():Structure {
			return createKeyFamily();
		}
		
		public function createKeyFamily():KeyFamily {
			return new KeyFamily(_id, _name, _maintainer, _key, _measure);
		}
				
		public static function suite():TestSuite {
			return new TestSuite(KeyFamilyTest);
		}
		
		public override function testConstructor():void {
			super.testConstructor();
			assertEquals("The keys should be equal", _key, _keyFamily.keyDescriptor);
			assertEquals("The measures should be equal", _measure, _keyFamily.measureDescriptor);
			try {
				new KeyFamily(_id, _name, _maintainer, null, _measure);
				fail("The key cannot be null");
			} catch (error:ArgumentError) {}
			try {
				new KeyFamily(_id, _name, _maintainer, new KeyDescriptor("key"), _measure);
				fail("The key cannot be empty");
			} catch (error:ArgumentError) {}
			try {
				new KeyFamily(_id, _name, _maintainer, _key, null);
				fail("The measure cannot be null");
			} catch (error:ArgumentError) {}
			try {
				new KeyFamily(_id, _name, _maintainer, _key, new MeasureDescriptor("measure"));
				fail("The measure cannot be empty");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetAttributeDescriptor():void {
			var attributes:AttributeDescriptor = new AttributeDescriptor("attributes");
			_keyFamily.attributeDescriptor = attributes;
			assertEquals("The attributes should be equal", attributes, _keyFamily.attributeDescriptor);
		}
		
		public function testSetAndGetGroupDescriptor():void {
			var group:GroupKeyDescriptorsCollection = new GroupKeyDescriptorsCollection();
			_keyFamily.groupDescriptors = group;
			assertEquals("The groups should be equal", group, _keyFamily.groupDescriptors);
		}
	}
}