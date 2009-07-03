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
	public class SDMXDateFormatterTest extends TestCase {

		public function SDMXDateFormatterTest(methodName:String=null) {
			super(methodName);
		}

		public static function suite():TestSuite {
			return new TestSuite(SDMXDateFormatterTest);
		}
		
		public function testBusinessAndDailyFrequency():void {
			var date:Date = new Date("1980", "10", "13");
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			formatter.frequency = "D";
			assertEquals("Expected formatted was: 13 November 1980", "13 November 1980", formatter.format(date));
		}
		
		public function testMonthlyFrequency():void {
			var date:Date = new Date("1980", "10", "13");
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			formatter.frequency = "M";
			assertEquals("Expected formatted was: November 1980", "November 1980", formatter.format(date));			
		}
		
		public function testQuarterlyFrequency():void {
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			formatter.frequency = "Q";
			assertEquals("Expected formatted was: 1918 Q1", "1918 Q1", 
				formatter.format(new Date("1918", "1", "18")));			
			assertEquals("Expected formatted was: 1947 Q3", "1947 Q3", 
				formatter.format(new Date("1947", "8", "25")));
			assertEquals("Expected formatted was: 1980 Q4", "1980 Q4", 
				formatter.format(new Date("1980", "9", "13")));
			assertEquals("Expected formatted was: 2001 Q2", "2001 Q2", 
				formatter.format(new Date("2001", "5", "6")));			
		}
		
		public function testAnnualFrequency():void {
			var date:Date = new Date("1980", "10", "13");
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			formatter.frequency = "A";
			assertEquals("Expected formatted was: 1980", "1980", formatter.format(date));			
		}
		
		public function testUnknownFrequency():void 
		{
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			try {
				formatter.frequency = "FAIL";
				fail("Should not be possible to set unknown frequency");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetShortFormat():void
		{
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			assertFalse("By default, not short format", 
				formatter.isShortFormat);
			formatter.isShortFormat = true;
			assertTrue("Should be short format", formatter.isShortFormat);	
		}
		
		public function testNotADate():void
		{
			var formatter:SDMXDateFormatter = new SDMXDateFormatter();
			try {
				formatter.format("Not a date");
				fail("Should not be possible to format something else than a" + 
						" date");
			}  catch (error:ArgumentError) {}
		}
	}
}