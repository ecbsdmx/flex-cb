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
package org.sdmx.util.validator
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import mx.events.ValidationResultEvent;

	/**
	 *	@private 
	 */
	public class SDMXDateValidatorTest extends TestCase {
		
		private var _validator:SDMXDateValidator = new SDMXDateValidator();
		
		private var _results:ValidationResultEvent;
		
		public function SDMXDateValidatorTest(methodName:String = null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(SDMXDateValidatorTest);
		}
		
		public function testGYear():void {
			_results = _validator.validate("2007");
			assertEquals("2007 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007+12:00");
			assertEquals("2007+02:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-00:00");
			assertEquals("2007-00:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-13:59");
			assertEquals("2007-13:59 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007+13:00");
		}
		
		public function testGYearMonth():void {
			_results = _validator.validate("2007-10");
			assertEquals("2007-10 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10+12:00");
			assertEquals("2007-10+12:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-00:00");
			assertEquals("2007-10-00:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-13:59");
			assertEquals("2007-10-13:59 should be a valid date", ValidationResultEvent.VALID, _results.type);
		}
		
		public function testGYearMonthDay():void {
			_results = _validator.validate("2007-10-30");
			assertEquals("2007-10-30 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30+12:00");
			assertEquals("2007-10-30+12:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30-00:00");
			assertEquals("2007-10-30-00:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30-13:59");
			assertEquals("2007-10-30-13:59 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30+13:00");
		}
		
		public function testGYearMonthDayTime():void {
			_results = _validator.validate("2007-10-30T13:55:00");
			assertEquals("2007-10-30T13:55:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30T13:55:00+12:00");
			assertEquals("2007-10-30T13:55:00+12:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30T13:55:00-00:00");
			assertEquals("2007-10-30T13:55:00-00:00 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-10-30T13:55:00-13:59");
		}
		
		public function testSDMXPeriodType():void {
			_results = _validator.validate("2007-Q1");
			assertEquals("2007-Q1 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-Q4");
			assertEquals("2007-Q4 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-Q5");
			assertEquals("2007-Q5 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-Q0");
			assertEquals("2007-Q0 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-T1");
			assertEquals("2007-T1 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-T3");
			assertEquals("2007-T3 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-T4");
			assertEquals("2007-T4 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-T0");
			assertEquals("2007-T0 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-B1");
			assertEquals("2007-B1 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-B2");
			assertEquals("2007-B2 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-B0");
			assertEquals("2007-B0 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-B3");
			assertEquals("2007-B3 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-W1");
			assertEquals("2007-W1 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-W52");
			assertEquals("2007-W52 should be a valid date", ValidationResultEvent.VALID, _results.type);
			_results = _validator.validate("2007-W0");
			assertEquals("2007-W0 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("2007-W53");
			assertEquals("2007-W53 should not be a valid date", ValidationResultEvent.INVALID, _results.type);
		}
		
		public function testLength():void
		{
			_results = _validator.validate("207");
			assertEquals("207", ValidationResultEvent.INVALID, _results.type);
			_results = _validator.validate("0123456789012345678012345");
			assertEquals("207", ValidationResultEvent.INVALID, _results.type);
		}
	}
}