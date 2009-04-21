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
	import eu.ecb.core.controller.PassiveSDMXDataController;
	import eu.ecb.core.model.SDMXDataModel;
	import eu.ecb.core.view.ISDMXServiceView;
	import eu.ecb.core.view.ISDMXView;
	import eu.ecb.core.view.SDMXViewAdapter;
	
	import flash.display.DisplayObject;

	/**
	 * Basic implementation of the ISDMXDataPanel interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SDMXDataPanelAdapter extends SDMXViewAdapter
		implements ISDMXDataPanel
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _desiredHeight:Number;
		
		/**
		 * @private
		 */
		protected var _desiredHeightChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _desiredWidth:Number;
		
		/**
		 * @private
		 */
		protected var _desiredWidthChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _showChange:Boolean;
		
		/**
		 * @private
		 */
		protected var _showChangeChanged:Boolean;
			
		/**
		 * @private
		 */		
		protected var _model:SDMXDataModel;
		
		/**
		 * @private
		 */
		protected var _controller:PassiveSDMXDataController;
		
		/*===========================Constructor==============================*/
		
		public function SDMXDataPanelAdapter(model:SDMXDataModel, 
			controller:PassiveSDMXDataController, direction:String = "vertical")
		{
			super(direction);
			_model = model;
			_controller = controller;
			percentWidth = 100;
			percentHeight = 100;
		}
		
		/*========================Protected methods===========================*/
				
		override protected function resourcesChanged():void {
			if (!initialized) return;
			super.resourcesChanged();
			_model.updateLanguage();	
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 		
		public function set desiredHeight(desiredHeight:Number):void
		{
			if (_desiredHeight != desiredHeight) {
				_desiredHeight = desiredHeight;
				_desiredHeightChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set desiredWidth(desiredWidth:Number):void
		{
			if (_desiredWidth != desiredWidth) {
				_desiredWidth = desiredWidth;
				_desiredWidthChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set showChange(showChange:Boolean):void
		{
			_showChange = showChange;
			_showChangeChanged = true;
			invalidateProperties();
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function addView(view:ISDMXServiceView):void
		{
			if (null != view) {
				addChild(view as DisplayObject);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function removeView(view:ISDMXServiceView):void
		{
			if (null != view) {
				removeChild(view as DisplayObject);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getView(index:uint):ISDMXServiceView
		{
			if (index < getChildren().length) {
				return getChildAt(index) as ISDMXView;
			} else {
				throw new ArgumentError("There are only " + getChildren().
					length + " views in this panel");
			}
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_dataSetChanged) {
				_dataSetChanged = false;
				commitDataSet()
			}
			
			if (_referenceSeriesFrequencyChanged) {
				_referenceSeriesFrequencyChanged = false;
				commitReferenceSeriesFrequency();
			}
		
			if (_periodsChanged) {
				_periodsChanged = false;
				commitPeriods();
			}
			
			if (_isPercentageChanged) {
				_isPercentageChanged = false;
				commitIsPercentage();
			}
			
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				commitReferenceSeries();
			}
			
			if (_filteredReferenceSeriesChanged) {
				_filteredReferenceSeriesChanged = false;
				commitFilteredReferenceSeries();
			}
			
			if (_filteredDataSetChanged) {
				_filteredDataSetChanged = false;
				commitFilteredDataSet();
			}
			
			if (_fullDataSetChanged) {
				_fullDataSetChanged = false;
				commitFullDataSet();
			}
		}
		
		/**
		 * @private
		 */ 
		protected function commitFilteredDataSet():void 
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).filteredDataSet = _filteredDataSet;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function commitFilteredReferenceSeries():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).filteredReferenceSeries = 
						_filteredReferenceSeries;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function commitReferenceSeries():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).referenceSeries = _referenceSeries;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function commitIsPercentage():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).isPercentage = _isPercentage;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function commitDataSet():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).dataSet = _dataSet;
				}
			}
		}

		/**
		 * @private
		 */
		protected function commitReferenceSeriesFrequency():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).referenceSeriesFrequency = 
						_referenceSeriesFrequency;
				}
			}
		}			

		/**
		 * @private
		 */
		protected function commitPeriods():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).periods = _periods;
				}
			}
		}		
		
		/**
		 * @private
		 */
		protected function commitFullDataSet():void
		{
			for each (var view:DisplayObject in getChildren()) {
				if (view is ISDMXView) {
					(view as ISDMXView).fullDataSet = _fullDataSet;
				}
			}
		}
	}
}