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
	
	import org.sdmx.model.v2.base.InternationalString;
	import org.sdmx.model.v2.structure.code.Code;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.model.v2.structure.keyfamily.CodedMeasure;
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.organisation.MaintenanceAgency;

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
			/*try {
				period = new TimePeriod(null, value);
				fail("It should not be possible to construct an TimePeriod with a null date");
			} catch (error:ArgumentError) {}
			try {
				period = new TimePeriod(date, null);
				fail("It should not be possible to construct an TimePeriod with a null observation");
			} catch (error:ArgumentError) {}*/
		}
		
		public function testSetAndGetTimeValue():void {
			var date:String = "2007-05-21";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period:TimePeriod = new TimePeriod(date, value);
			assertEquals("The dates should be equal", date, period.periodComparator);
			assertTrue("The time value should be equal", 
				period.timeValue.fullYear == 2007 && period.timeValue.month == 4 && period.timeValue.date == 21 );
		}
		
		public function testSetAndGetObservation():void {
			var date:String = "2007-05-21";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period:TimePeriod = new TimePeriod(date, value);
			assertEquals("The observations should be equal", value, period.observation);
		}
		
		public function testQuarterlyConversion():void
		{
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			var period1:TimePeriod = new TimePeriod("2007-Q1", value);
			assertEquals("Q1 = 01", "2007-01", period1.periodComparator);
			var period2:TimePeriod = new TimePeriod("2007-Q2", value);
			assertEquals("Q2 = 04", "2007-04", period2.periodComparator);
			var period3:TimePeriod = new TimePeriod("2007-Q3", value);
			assertEquals("Q3 = 07", "2007-07", period3.periodComparator);
			var period4:TimePeriod = new TimePeriod("2007-Q4", value);
			assertEquals("Q4 = 10", "2007-10", period4.periodComparator);
		}
		
		public function testNotImplementedFeature():void
		{
			var date:String = "2007-W1";
			var value:Observation = new UncodedObservation("1.258", new UncodedMeasure("measure", new Concept("OBS_VALUE")));
			try {  
				var period:TimePeriod = new TimePeriod(date, value);
				fail("Not supported");
			} catch (error:ArgumentError) {}
			
			var date2:String = "2007-H2";
			try {  
				var period2:TimePeriod = new TimePeriod(date, value);
				fail("Not supported");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetCodedValue():void
		{
			var date:String = "2007-Q1";
			var value:Observation = new CodedObservation(new Code("A"), 
				new CodedMeasure("measure", new Concept("OBS_VALUE"), 
				new CodeList("testcl", new InternationalString(), 
				new MaintenanceAgency("ecb"))));
			var period:TimePeriod = new TimePeriod(date, value);	
			assertEquals("The value should be equal", "A", 
				period.observationValue);	
		}
	}
}