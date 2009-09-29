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
package eu.ecb.core.view.panel
{
	import eu.ecb.core.view.ISDMXServiceView;
	import eu.ecb.core.view.ISDMXView;
	
	import flash.display.DisplayObject;
	
	import mx.containers.ViewStack;
	import mx.events.MenuEvent;

	/**
	 * This panel wraps a AS3 ViewStack in an SDMXDataPanelAdapter.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class StackPanel extends SDMXDataPanelAdapter
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _stack:ViewStack;
		
		/*===========================Constructor==============================*/
		 
		public function StackPanel(direction:String="vertical")
		{
			super(direction);
			_stack = new ViewStack();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		override public function addView(view:ISDMXServiceView):void
		{
			if (null != view) {
				_stack.addChild(view as DisplayObject);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function removeView(view:ISDMXServiceView):void
		{
			if (null != view) {
				_stack.removeChild(view as DisplayObject);
			}
		}
		
		public function displayPanel(index:uint):void
		{
			if (index < _stack.getChildren().length) {
				_stack.selectedIndex = index;
			}
		}
		
		public function handleStackItemSelected(event:MenuEvent):void
		{
			if (event.index < _stack.getChildren().length) {
				_stack.selectedIndex = event.index;
			}
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null != _stack) {
				_stack.percentWidth  = 100;
				_stack.percentHeight = 100
				addChild(_stack);
			}
		}
		
		/**
		 * @private
		 */ 
		override protected function commitFilteredDataSet():void 
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).filteredDataSet = _filteredDataSet;
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitFilteredReferenceSeries():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).filteredReferenceSeries = 
						_filteredReferenceSeries;
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitReferenceSeries():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).referenceSeries = _referenceSeries;
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitIsPercentage():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).isPercentage = _isPercentage;
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitDataSet():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).dataSet = _dataSet;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function commitReferenceSeriesFrequency():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).referenceSeriesFrequency = 
						_referenceSeriesFrequency;
				}
			}
		}			

		/**
		 * @private
		 */
		override protected function commitPeriods():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).periods = _periods;
				}
			}
		}		
		
		/**
		 * @private
		 */
		override protected function commitFullDataSet():void
		{
			for each (var view:DisplayObject in _stack.getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).fullDataSet = _fullDataSet;
				}
			}
		}
	}
}