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
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;

	/**
	 * @private
	 */
	public class TimePeriodTest extends TestCase
	{
		public function TimePeriodTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(TimePeriodTest);
		}
		
		public function testConstructor():void {
			var date:String = "2007-05-21";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period:TimePeriod = new TimePeriod(date, value);
			assertEquals("The dates should be equal", date, period.periodComparator);
			assertEquals("The observations should be equal", value, period.observation);
			try {
				period = new TimePeriod(null, value);
				fail("It should not be possible to construct an TimePeriod with a null date");
			} catch (error:ArgumentError) {}
			try {
				period = new TimePeriod(date, null);
				fail("It should not be possible to construct an TimePeriod with a null observation");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetTimeValue():void {
			var date:String = "2007-05-21";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period:TimePeriod = new TimePeriod(date, value);
			assertEquals("The dates should be equal", date, period.periodComparator);
			var date2:String = "2007-08-29";
			period.timeValue = new Date(2007, 7, 29);
			assertEquals("The new dates should be equal", date2, period.periodComparator);
			try {
				period.timeValue = null;
				fail("It should not be possible to set a null date");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetObservation():void {
			var date:String = "2007-05-21";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period:TimePeriod = new TimePeriod(date, value);
			assertEquals("The observations should be equal", value, period.observation);
			var value2:Observation = new UncodedObservation("1.3515", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			period.observation = value2;
			assertEquals("The new observations should be equal", value2, period.observation);
			try {
				period.observation = null;
				fail("It should not be possible to set a null observation");
			} catch (error:ArgumentError) {}
		}
	}
}