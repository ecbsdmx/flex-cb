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
package org.sdmx.model.v2.base.structure
{
	import org.sdmx.model.v2.base.item.Item;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.type.UsageStatus;
	
	/**
	 *	@private 
	 */
	public class AttributeTest extends ComponentTest
	{
		private var _attribute:Attribute;
		
		public function AttributeTest(methodName:String = null) {
			super(methodName);
		}
		
		public override function setUp():void {
			super.setUp();
			_attribute = createAttribute();
			assertNotNull("Problem creating attribute", _attribute);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(AttributeTest);
		}
		
		public override function createComponent():Component {
			return createAttribute();
		}
		
		public function createAttribute():Attribute {
			return new Attribute(_id, _item);
		}
		
		public function testSetAndGetUsageStatus():void {
			assertNull("There should be no default for usage status", _attribute.usageStatus);
			_attribute.usageStatus = UsageStatus.CONDITIONAL;
			assertEquals("Usage status should be equal", UsageStatus.CONDITIONAL, _attribute.usageStatus);
			try {
				_attribute.usageStatus = "My own status";
				fail("Not a proper usage status");
			} catch (error:TypeError) {}
		}
	}
}