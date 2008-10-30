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
	import org.sdmx.model.v2.structure.keyfamily.UncodedMeasure;
	import org.sdmx.model.v2.structure.concept.Concept;

	/**
	 * @private
	 */ 
	public class UncodedObservationTest extends TestCase
	{
		
		public function UncodedObservationTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
			return new TestSuite(UncodedObservationTest);
		}
		
		public function testConstrutor():void {
			var measure:UncodedMeasure = new UncodedMeasure("measure", new Concept("concept"));
			var obs:UncodedObservation = new UncodedObservation("test", measure);
			assertEquals("The values should be equal", "test", obs.value);
			assertEquals("The valueFor should be equal", measure, obs.valueFor);
			try {
				var obs2:UncodedObservation = new UncodedObservation("", measure);
				fail("It should not be possible to construct an Uncoded measure with an empty value");
			} catch (error:ArgumentError) {}
			try {
				var obs3:UncodedObservation = new UncodedObservation("test", null);
				fail("It should not be possible to construct an Uncoded measure with a null measure");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValue():void {
			var measure:UncodedMeasure = new UncodedMeasure("measure", new Concept("concept"));
			var obs:UncodedObservation = new UncodedObservation("test", measure);
			assertEquals("The values should be equal", "test", obs.value);
			obs.value = "test_new";
			assertEquals("The new values should be equal", "test_new", obs.value);
			try {
				obs.value = " ";
				fail("It should not be possible to set an empty value");
			} catch (error:ArgumentError) {}
		}
		
		public function testSetAndGetValueFor():void {
			var measure:UncodedMeasure = new UncodedMeasure("measure", new Concept("concept"));
			var obs:UncodedObservation = new UncodedObservation("test", measure);
			assertEquals("The valueFor should be equal", measure, obs.valueFor);
			var measure2:UncodedMeasure = new UncodedMeasure("measure2", new Concept("new concept"));
			obs.valueFor = measure2;
			assertEquals("The new valueFor should be equal", measure2, obs.valueFor);
			try {
				obs.valueFor = null;
				fail("It should not be possible to pass a null measure");
			} catch (error:ArgumentError) {}
		}
	}
}