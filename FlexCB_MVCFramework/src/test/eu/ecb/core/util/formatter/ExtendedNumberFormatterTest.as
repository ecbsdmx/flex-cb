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
package eu.ecb.core.util.formatter
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 *	@private 
	 */
	public class ExtendedNumberFormatterTest extends TestCase {
		
		public function ExtendedNumberFormatterTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(ExtendedNumberFormatterTest);
		}
		
		public function testSetAndGetForceSigned():void
		{
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();
			assertFalse("By default, no forceSigned", formatter.forceSigned);
			formatter.forceSigned = true;
			assertTrue("Should be forceSigned", formatter.forceSigned);
		}
		
		public function testStandardFormatting():void {
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();
			formatter.precision = 3;	
			var number1:Number = 1596.789;
			var result1:String = formatter.format(number1);
			assertEquals("The result should be '1,596.789'", "1,596.789", result1);
			var number2:Number = -1596.789;
			var result2:String = formatter.format(number2);
			assertEquals("The result should be '-1,596.789'", "-1,596.789", result2);
			 	
		}
		
		public function testSmallNumberFormatting():void {
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();
			formatter.precision = 3;	
			var number1:Number = 0.789;
			var result1:String = formatter.format(number1);
			assertEquals("The result should be '0.789'", "0.789", result1);
			var number2:Number = -0.789;
			var result2:String = formatter.format(number2);
			assertEquals("The result should be '-0.789'", "-0.789", result2);	
			var number3:Number = .789;
			var result3:String = formatter.format(number3);
			assertEquals("The result should be '0.789'", "0.789", result3);
		}
		
		public function testForcedSigned():void {
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();
			formatter.forceSigned = true;
			formatter.precision = 3;
			var number1:Number = 1596.789;
			var result1:String = formatter.format(number1);
			assertEquals("The result should be '+1,596.789'", "+1,596.789", result1);
			var number2:Number = +0.789;
			var result2:String = formatter.format(number2);
			assertEquals("The result should be '+0.789'", "+0.789", result2);	
		}
		
		public function testNotANumber():void {
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();			
			try {
				formatter.format("Test");
				fail("The formatter should accept numbers only");
			} catch (error:ArgumentError) {}	
		}
		
		public function testSmallNegativeNumber():void {
			var formatter:ExtendedNumberFormatter = 
				new ExtendedNumberFormatter();
			formatter.precision = 1;
			var number:Number = -0.02;
			var result:String = formatter.format(number);
			assertEquals("The result should be '0.0'", "0.0", result);
		}
	}
}