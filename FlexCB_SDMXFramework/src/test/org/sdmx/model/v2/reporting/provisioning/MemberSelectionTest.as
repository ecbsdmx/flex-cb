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
package org.sdmx.model.v2.reporting.provisioning
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.structure.Component;
	import org.sdmx.model.v2.structure.keyfamily.Dimension;
	import mx.collections.ArrayCollection;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */ 
	public class MemberSelectionTest extends TestCase {
		
		public function MemberSelectionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(MemberSelectionTest);
		}
		
		public function testSetAndGetIsIncluded():void {
			var member:MemberSelection = new MemberSelection();
			assertFalse("By default, the member should be excluded", member.isIncluded);
			member.isIncluded = true;
			assertTrue("The member should now be true", member.isIncluded);
		}
		
		public function testSetAndGetStructureComponent():void {
			var member:MemberSelection = new MemberSelection();
			assertNull("By default, the component should be null", member.structureComponent);
			var component:Component = new Dimension("TEST", new Concept("SOME_TEST"));
			member.structureComponent = component;
			assertEquals("The components should be equal", component, member.structureComponent);
		}
		
		public function testSetAndGetValues():void {
			var member:MemberSelection = new MemberSelection();
			assertEquals("By default, there should be no values", 0, member.values.length);
			var values:ArrayCollection = new ArrayCollection();
			values.addItem(1);
			member.values = values;
			assertEquals("By default, there should be one item in the list of values", 
				1, member.values.length);
		}
	}
}