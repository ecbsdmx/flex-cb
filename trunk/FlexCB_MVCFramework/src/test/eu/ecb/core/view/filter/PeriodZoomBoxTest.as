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
package eu.ecb.core.view.filter
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.controls.LinkBar;

	/**
	 * @private
	 * 
	 * @todo find a better way to test views
	 */ 
	public class PeriodZoomBoxTest extends TestCase
	{
		public function PeriodZoomBoxTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(PeriodZoomBoxTest);
		}
		
		public function testDisplay():void {
			var view:PeriodZoomBox = new PeriodZoomBox();
			view.creationForTests();
			var periods:ArrayCollection = new ArrayCollection();
			var period1:Object = {label: "3m", toolTip: "Test 3m"};
			var period2:Object = {label: "6m", toolTip: "Test 6m"};
			var period3:Object = {label: "1y", toolTip: "Test 1y"};						
			periods.addItem(period1);
			periods.addItem(period2);
			periods.addItem(period3);
			view.periods = periods;
			assertEquals("The view should have 2 children", 2, 
				view.getChildren().length);
			assertTrue("The 1st view should be a label", view.getChildAt(0) is Label);
			assertTrue("The 2nd view should be a link bar", view.getChildAt(1) is LinkBar);	
			/*var label:Label = view.getChildAt(0) as Label;
			assertEquals("The text of the label should be equal", "Select date range: ", (view.getChildAt(0) as Label).text);
			assertEquals("The link bar should have 3 children", 3, ((view.getChildAt(1) as LinkBar).dataProvider as ArrayCollection).length);
			assertEquals("The 1st children should be the same", period1, ((view.getChildAt(1) as LinkBar).dataProvider as ArrayCollection).getItemAt(0));
			assertEquals("The 3rd children should be the same", period3, ((view.getChildAt(1) as LinkBar).dataProvider as ArrayCollection).getItemAt(2));*/
		}
	}
}