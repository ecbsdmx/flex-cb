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
package org.sdmx.model.v2.base.structure
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import org.sdmx.model.v2.base.type.DataType;

	/**
	 *	@private 
	 */
	public class LengthRangeTest extends TestCase
	{
		public function LengthRangeTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(LengthRangeTest);
		}
		
		public function testConstructor():void {
			var representation:LengthRange = new LengthRange(0, 10);
			assertEquals("The min length should be 0", 0, representation.minLength);
			assertEquals("The max length should be 10", 10, representation.maxLength);
		}
		
		public function testSetAndGetMinLength():void {
			var representation:LengthRange = new LengthRange();
			representation.minLength = 2;
			assertEquals("The min length should be 2", 2, representation.minLength);
		}
		
		public function testSetAndGetMaxLength():void {
			var representation:LengthRange = new LengthRange();
			representation.maxLength = 20;
			assertEquals("The max length should be 20", 20, representation.maxLength);	
		}
		
		public function testSetAndGetType():void {
			var representation:LengthRange = new LengthRange();
			representation.dataType = DataType.BASE64_BINARY;
			assertEquals("The max length should be 20", DataType.BASE64_BINARY, representation.dataType);
			try {
				representation.dataType = "My own type";	
			} catch (error:ArgumentError) {}
		}
	}
}