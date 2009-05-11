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

	/**
	 * @private
	 */ 
	public class CubeRegionTest extends TestCase {

		public function CubeRegionTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(CubeRegionTest);
		}
		
		public function testSetAndGetIsIncluded():void {
			var cube:CubeRegion = new CubeRegion();
			assertFalse("By default the cube region should be excluded", cube.isIncluded);
			cube.isIncluded = true;
			assertTrue("The cube region should be included", cube.isIncluded);
		}
		
		public function testSetAndGetMembers():void {
			var cube:CubeRegion = new CubeRegion();
			assertEquals("By default, there should be no member selection", 0, cube.members.length);
			var members:MemberSelectionsCollection = new MemberSelectionsCollection();	
			var member:MemberSelection = new MemberSelection();
			members.addItem(member);
			cube.members = members;
			assertEquals("There should be 1 member", 1, cube.members.length);
			assertEquals("The members should be equal", member, cube.members.getItemAt(0));
		}
	}
}