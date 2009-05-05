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
package org.sdmx.event
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.sdmx.stores.api.SDMXQueryParameters;

	public class SDMXQueryEventTest extends TestCase
	{
		public function SDMXQueryEventTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			return new TestSuite(SDMXQueryEventTest);
		}
				
		public function testCreateSDMXQueryEvent():void {
			var params:SDMXQueryParameters = new SDMXQueryParameters();
			var event:SDMXQueryEvent = 
				new SDMXQueryEvent(params, "testCreateSDMXDataEvent");
			assertEquals("The XML data should be equal", params, event.params);
		}
		
		public function testCloneEvent():void {
			var params:SDMXQueryParameters = new SDMXQueryParameters();
			var event:SDMXQueryEvent = 
				new SDMXQueryEvent(params, "testCreateSDMXDataEvent");
			var clonedEvent:SDMXQueryEvent = event.clone() as SDMXQueryEvent;
			assertTrue("Events should not be the same object", 
				event != clonedEvent);
			assertEquals("Events should have the same object", event.params, 
				clonedEvent.params);		
		}
		
	}
}