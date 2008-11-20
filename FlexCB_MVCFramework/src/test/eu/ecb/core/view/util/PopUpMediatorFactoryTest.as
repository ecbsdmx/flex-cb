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
package eu.ecb.core.view.util
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import eu.ecb.core.model.IModel;
	import mx.charts.LineChart;
	import mx.charts.BarChart;
	import mx.collections.ArrayCollection;

	/**
	 * @private
	 */ 
	internal class PopUpMediatorFactoryTest extends TestCase
	{
		public function PopUpMediatorFactoryTest(methodName:String = null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
			return new TestSuite(PopUpMediatorFactoryTest);
		}
		
		public function testFactorySingletonConstruction():void {
			var factory1:PopUpMediatorFactory = 
				PopUpMediatorFactory.getInstance();
			var factory2:PopUpMediatorFactory = 
				PopUpMediatorFactory.getInstance();
			assertEquals("The factories should be equal", factory1, factory2);
		}
		
		public function testIdenticalControllersCreation():void {
			var factory:PopUpMediatorFactory = 
				PopUpMediatorFactory.getInstance();
			var view:LineChart = new LineChart();	
			var mediator1:PopUpMediator = factory.getMediator(view);
			var mediator2:PopUpMediator = factory.getMediator(view);
			assertEquals("The controllers should be the same", mediator1, 
				mediator2);		
		}
		
		public function testDifferentControllersCreation():void {
			var view1:LineChart = new LineChart();
			var view2:BarChart = new BarChart();
			var factory:PopUpMediatorFactory = 
				PopUpMediatorFactory.getInstance();
			var mediator1:PopUpMediator = factory.getMediator(view1);
			var mediator2:PopUpMediator = factory.getMediator(view2);
			assertTrue("The controllers should be different", 
				mediator1 != mediator2);		
		}
	}
}