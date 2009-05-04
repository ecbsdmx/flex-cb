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
package org.sdmx.util.date
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	/**
	 *	@private 
	 */
	public class SDMXDateTest extends TestCase {
		
		public function SDMXDateTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(SDMXDateTest);
		}
		
		public function testConvertGYear():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("2007");
			assertEquals("Years should be equal", 2007, date.fullYear);
			assertEquals("Months should be equal", 0, date.month);
			assertEquals("Dates should be equal", 1, date.date);
		}
		
		public function testConvertGYearMonth():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("2006-02");
			assertEquals("Years should be equal", 2006, date.fullYear);
			assertEquals("Months should be equal", 1, date.month);
			assertEquals("Dates should be equal", 1, date.date);
		}
		
		public function testConvertGYearMonthDay():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("2000-03-31");
			assertEquals("Years should be equal", 2000, date.fullYear);
			assertEquals("Months should be equal", 2, date.month);
			assertEquals("Dates should be equal", 31, date.date);
		}
		
		public function testConvertGYearMonthDayFebruary():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("2007-02-01");
			assertEquals("Years should be equal", 2007, date.fullYear);
			assertEquals("Months should be equal", 1, date.month);
			assertEquals("Dates should be equal", 1, date.date);
		}
		
		public function testConvertGYearMonthDayTime():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("1999-04-16T11:10:40");
			assertEquals("Years should be equal", 1999, date.fullYear);
			assertEquals("Months should be equal", 3, date.month);
			assertEquals("Dates should be equal", 16, date.date);
		}
		
		public function testConvertSDMXDate():void {
			var sdmxDate:SDMXDate = new SDMXDate();
			var date:Date = sdmxDate.getDate("2009-Q1");
			assertEquals("Years should be equal", 2009, date.fullYear);
			assertEquals("Months should be equal", 0, date.month);
			assertEquals("Dates should be equal", 1, date.date);
			date = sdmxDate.getDate("2009-Q2");
			assertEquals("Years should be equal", 2009, date.fullYear);
			assertEquals("Months should be equal", 3, date.month);
			assertEquals("Dates should be equal", 1, date.date);
			date = sdmxDate.getDate("2009-Q3");
			assertEquals("Years should be equal", 2009, date.fullYear);
			assertEquals("Months should be equal", 6, date.month);
			assertEquals("Dates should be equal", 1, date.date);
			date = sdmxDate.getDate("2009-Q4");
			assertEquals("Years should be equal", 2009, date.fullYear);
			assertEquals("Months should be equal", 9, date.month);
			assertEquals("Dates should be equal", 1, date.date);
		}
		
		public function testErrors():void
		{
			var sdmxDate:SDMXDate = new SDMXDate();
			try {
				sdmxDate.getDate("");
				fail("Empty dates should fail");
			} catch (error:ArgumentError) {}
			
			try {
				sdmxDate.getDate(null);
				fail("Null dates should fail");
			} catch (error:ArgumentError) {}
			
			try {
				sdmxDate.getDate("ABCD");
				fail("Not a date");
			} catch (error:ArgumentError) {}
			
			try {
				sdmxDate.getDate("2009-H1");
				fail("Not yet supported");
			} catch (error:Error) {}
			
			try {
				sdmxDate.getDate("2009-Q5");
				fail("Only four quarters");
			} catch (error:Error) {}
		}
	}
}