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
package eu.ecb.core.view.panel
{
	import eu.ecb.core.controller.SDMXDataController;
	import eu.ecb.core.model.SDMXDataModel;
	import eu.ecb.core.view.chart.ECBChartEvents;
	import eu.ecb.core.view.chart.ECBLegend;
	import eu.ecb.core.view.chart.ECBLineChart;
	import eu.ecb.core.view.chart.PeriodSlider;
	import eu.ecb.core.view.filter.PeriodZoomBox;
	import eu.ecb.core.view.summary.ChartSummaryBox;
	import eu.ecb.core.view.summary.SeriesSummaryBox;
	
	import flash.events.DataEvent;
	import flash.utils.getTimer;
	
	import mx.binding.utils.BindingUtils;

	/**
	 * Creates a basic data panel, similar to the Flex panels available on the 
	 * ECB website. 
	 * 
	 * The panel will contain:
	 * <ul>
	 * <li>A line with the latest observation value and the latest period</li>
	 * <li>A line with the list of predefined periods to choose from</li>
	 * <li>One or two lines with information regarding the selected period 
	 * (minimum and maximum values, etc)</li>
	 * <li>A chart displaying the data</li>
	 * <li>A slider allowing to precisely set the period of interest</li>   
	 * </ul>
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class BasicDataPanel extends SDMXDataPanelAdapter
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _seriesSummaryBox:SeriesSummaryBox;
		
		/**
		 * @private
		 */
		protected var _filterBox:SDMXDataPanelAdapter;
		
		/**
		 * @private
		 */
		protected var _periodZoomBox:PeriodZoomBox;
		
		/**
		 * @private
		 */
		protected var _chartBox:SDMXDataPanelAdapter;
		
		/**
		 * @private
		 */
		protected var _chartSummaryBox:ChartSummaryBox;
		
		/**
		 * @private
		 */
		protected var _chart:ECBLineChart;
		
		/**
		 * @private
		 */
		protected var _legend:ECBLegend;
		
		/**
		 * @private
		 */
		protected var _periodSlider:PeriodSlider;
		
		/*===========================Constructor==============================*/
		
		public function BasicDataPanel(model:SDMXDataModel, 
			controller:SDMXDataController, showChange:Boolean = false)
		{
			super(model, controller);
			styleName = "dataPanel";
			_showChange = showChange;
			BindingUtils.bindProperty(this, "referenceSeriesFrequency", _model, 
				"referenceSeriesFrequency");
			BindingUtils.bindProperty(this, "referenceSeries", _model, 
				"referenceSeries");
			BindingUtils.bindProperty(this, "isPercentage", _model, 
				"isPercentage");
			BindingUtils.bindProperty(this, "filteredDataSet", _model, 
				"filteredDataSet");
			BindingUtils.bindProperty(this, "dataSet", _model, 
				"dataSet");
			BindingUtils.bindProperty(this, "fullDataSet", _model, 
				"fullDataSet");			
			BindingUtils.bindProperty(this, "filteredReferenceSeries", _model, 
				"filteredReferenceSeries");
			BindingUtils.bindProperty(this, "periods", _model, "periods");
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function createChildren():void 
		{
			super.createChildren();
						
			if (null == _seriesSummaryBox) {
				createSeriesSummaryBox();
			}
			
			if (null == _filterBox) {
				createFilterBox();	
			}
			
			if (null == _periodZoomBox) {
				createZoomBox();
			}
			
			if (null == _chartBox) {
				createChartBox();
			}
			
			if (null == _chartSummaryBox) {
				createChartSummaryBox();
			}
			
			if (null == _chart) {
				createChart();
			}
			
			if (null == _periodSlider) {
				createPeriodSlider();
			}
			
			if (null == _legend) {
				createLegend();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handleDataChartDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			_controller.handleChartDragged(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handleLeftDividerDragged(event:DataEvent):void 
		{
			_periodZoomBox.removeSelectedPeriodHighlight();
			_controller.handleLeftDividerDragged(event);
			event.stopImmediatePropagation();
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handleRightDividerDragged(event:DataEvent):void 
		{
			_periodZoomBox.removeSelectedPeriodHighlight();
			_controller.handleRightDividerDragged(event);
			event.stopImmediatePropagation();			
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handlePeriodChanged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			_controller.handlePeriodChange(event);
		}
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function commitFilteredDataSet():void 
		{
			super.commitFilteredDataSet();
			if (_filteredDataSet.timeseriesKeys.length <= 1) {
				_legend.height = 0;
			}
			_chartBox.visible = true;
			_filterBox.visible = true;
			_filterBox.width = _chart.getExplicitOrMeasuredWidth();
			_periodSlider.size = _chart.getExplicitOrMeasuredWidth();
			_chartSummaryBox.width = _chart.getExplicitOrMeasuredWidth();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitIsPercentage():void
		{
			super.commitIsPercentage();
			_chartSummaryBox.height = _isPercentage ? 25 : 40;
		}
		
		/**
		 * @private
		 */
		protected function createSeriesSummaryBox():void
		{
			_seriesSummaryBox = new SeriesSummaryBox();
			_seriesSummaryBox.showChange = _showChange;
			_seriesSummaryBox.height = 20;
			addView(_seriesSummaryBox);
		}
		
		/**
		 * @private
		 */
		protected function createFilterBox():void
		{
			_filterBox = new SDMXDataPanelAdapter(_model, _controller, 
				"horizontal");
			_filterBox.styleName = "filterBox";
			_filterBox.visible = false;
			_filterBox.percentWidth = 100;
			_filterBox.height = 28;
			addView(_filterBox);
		}
		
		/**
		 * @private
		 */
		protected function createZoomBox():void
		{
			_periodZoomBox = new PeriodZoomBox();
			_periodZoomBox.percentWidth = 100;
			_periodZoomBox.height = 20;
			_periodZoomBox.addEventListener("selectedPeriodChanged",
				handlePeriodChanged);
			_filterBox.addView(_periodZoomBox);
		}
		
		/**
		 * @private
		 */
		protected function createChartBox():void
		{
			_chartBox = new SDMXDataPanelAdapter(_model, _controller);
			_chartBox.styleName = "chartBox";
			_chartBox.visible = false;
			_chartBox.percentWidth  = 100;
			_chartBox.percentHeight = 100;
			addView(_chartBox);
		}
		
		/**
		 * @private
		 */
		protected function createChartSummaryBox():void
		{
			_chartSummaryBox = new ChartSummaryBox();
			_chartSummaryBox.width = width - 30;
			_chartSummaryBox.setStyle("verticalAlign", "top");
			_chartSummaryBox.showChange = _showChange;
			_chartBox.addView(_chartSummaryBox);
		}
		
		/**
		 * @private
		 */
		protected function createChart():void
		{
			_chart = new ECBLineChart();
			_chart.width = width - 50;
			_chart.showChange = _showChange;
			_chart.addEventListener(ECBChartEvents.CHART_DRAGGED, 
				handleDataChartDragged, false, 0, true);		
			_chartBox.addView(_chart);
		}
		
		/**
		 * @private
		 */
		protected function createPeriodSlider():void
		{
			_periodSlider = new PeriodSlider();
			_periodSlider.width = _chart.getExplicitOrMeasuredWidth();
			_periodSlider.height = 70;
			_periodSlider.addEventListener(ECBChartEvents.CHART_DRAGGED, 
				handleDataChartDragged, false, 0, true);
			_periodSlider.addEventListener(
				ECBChartEvents.LEFT_DIVIDER_DRAGGED, 
				handleLeftDividerDragged, false, 0, true);	
			_periodSlider.addEventListener(
				ECBChartEvents.RIGHT_DIVIDER_DRAGGED,
				handleRightDividerDragged, false, 0, true);	
			_chartBox.addView(_periodSlider);
		}
		
		/**
		 * @private
		 */
		protected function createLegend():void
		{
			_legend = new ECBLegend();
			_chartBox.addView(_legend);
		}
	}
}