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
package eu.ecb.core.util.formatter.observation
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.structure.keyfamily.GroupKeyDescriptor;
	import org.sdmx.model.v2.structure.keyfamily.KeyDescriptor;

	/**
	 *	@private 
	 */
	public class ObservationAdapterFormatterTest extends TestCase
	{
		private var _formatter:ObservationAdapterFormatter;
		
		public function ObservationAdapterFormatterTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(ObservationAdapterFormatterTest);
		}
		
		public override function setUp():void {
			super.setUp();
			_formatter = createFormatter();
			assertNotNull("Problem creating formatter", _formatter);
		}
		
		public function createFormatter():ObservationAdapterFormatter {
			return new ObservationAdapterFormatter();
		}
		
		public function testSetAndGetSeries():void
		{
			assertNull("No series should be assigned by default", 
				_formatter.series);
			var series:TimeseriesKey = new TimeseriesKey(new KeyDescriptor());
			_formatter.series = series;
			assertEquals("The series should be equal", series, 
				_formatter.series);	
		}
		
		public function testSetAndGetGroup():void
		{
			assertNull("No groups should be assigned by default", 
				_formatter.group);
			var group:GroupKey = new GroupKey(new GroupKeyDescriptor("GroupKey"));
			_formatter.group = group;
			assertEquals("The groups should be equal", group, 
				_formatter.group);	
		}
		
		public function testFormat():void
		{
			try {
				_formatter.format("test");
				fail("This should be implemented by subclasses");
			} catch (error:IllegalOperationError) {}
		}
	}
}