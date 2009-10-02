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
	import eu.ecb.core.controller.ISDMXServiceController;
	import eu.ecb.core.controller.SDMXDataController;
	import eu.ecb.core.model.SDMXDataModel;
	import eu.ecb.core.view.chart.ECBChartEvents;
	import eu.ecb.core.view.chart.ECBLegend;
	import eu.ecb.core.view.chart.ECBLineChart;
	import eu.ecb.core.view.chart.PeriodSlider;
	import eu.ecb.core.view.filter.PeriodZoomBox;
	import eu.ecb.core.view.filter.ViewSelector;
	import eu.ecb.core.view.summary.ChartSummaryBox;
	import eu.ecb.core.view.summary.MetadataPanel;
	import eu.ecb.core.view.summary.SeriesSummaryBox;
	import eu.ecb.core.view.table.Table;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;

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
	[ResourceBundle("flex_cb_mvc_lang")]
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
		protected var _viewSelectorBox:ViewSelector;
		
		/**
		 * @private
		 */
		protected var _chart:ECBLineChart;
		
		/**
		 * @private
		 */
		protected var _table:Table;
		
		/**
		 * @private
		 */
		protected var _legend:ECBLegend;
		
		/**
		 * @private
		 */
		protected var _periodSlider:PeriodSlider;
		
		/**
		 * @private
		 */
		protected var _viewStack:StackPanel;
		
		/**
		 * @private
		 */
		protected var _chartAndSliderPanel:SDMXDataPanelAdapter;
		
		/**
		 * @private
		 */
		protected var _metadataPanel:MetadataPanel;

		/**
		 * @private
		 */
		protected var _showSeriesSummaryBox:Boolean;

		/**
		 * @private
		 */
		protected var _showChartSummaryBox:Boolean;
		
		/**
		 * @private
		 */		
		protected var _model:SDMXDataModel;
		
		/**
		 * @private
		 */
		protected var _controller:ISDMXServiceController;

		/**
		 * @private
		 */
		protected var _showTableView:Boolean;
		
		/**
		 * @private
		 */
		protected var _showMetadataView:Boolean;								
														
		/*===========================Constructor==============================*/
		
		public function BasicDataPanel(model:SDMXDataModel, 
			controller:SDMXDataController, showChange:Boolean = false,
			showSeriesSummaryBox:Boolean = true,
			showChartSummaryBox:Boolean = true, showTableView:Boolean = true,
			showMetadataView:Boolean = true)
		{
			super();
			_model = model;
			_controller = controller;
			styleName = "dataPanel";
			_showChange = showChange;
			_showSeriesSummaryBox = showSeriesSummaryBox;
			_showChartSummaryBox = showChartSummaryBox;
			_showTableView = showTableView;
			_showMetadataView = showMetadataView;
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
				"allDataSets");			
			BindingUtils.bindProperty(this, "filteredReferenceSeries", _model, 
				"filteredReferenceSeries");
			BindingUtils.bindProperty(this, "periods", _model, "periods");
			ChangeWatcher.watch(this, "width", handleChangedWidth);
		}

		/*========================Public methods===========================*/
		
		public function get legend():ECBLegend {
			return _legend;
		}
		
		public function get chart():ECBLineChart {
			return _chart;
		}		
				
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */
		override protected function resourcesChanged():void {
			if (!initialized) return;
			super.resourcesChanged();
			_model.updateLanguage();	
		}
		
		/**
		 * @inheritDoc
		 */ 		
		override protected function createChildren():void 
		{
			super.createChildren();
						
			if (null == _seriesSummaryBox && _showSeriesSummaryBox) {
				createSeriesSummaryBox();
			}
			
			if (null == _filterBox) {
				createFilterBox();	
			}
			
			if (null == _periodZoomBox) {
				createZoomBox();
			}
			
			if (null == _viewSelectorBox) {
				createViewSelectorBox();
			}
			
			if (null == _chartBox) {
				createChartBox();
			}
			
			if (null == _chartSummaryBox && _showChartSummaryBox) {
				createChartSummaryBox();
			}
			
			if (null == _viewStack) {
				createViewStack();
			}
			
			if (null == _chartAndSliderPanel) {
				createChartAndSliderPanel();
			}
			
			if (null == _chart) {
				createChart();
			}
			
			if (null == _table && _showTableView) {
				createTable();
			}
			
			if (null == _metadataPanel && _showMetadataView) {
				createMetadataPanel();
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
			(_controller as SDMXDataController).handleChartDragged(event);
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handleLeftDividerDragged(event:DataEvent):void 
		{
			_periodZoomBox.removeSelectedPeriodHighlight();
			(_controller as SDMXDataController).handleLeftDividerDragged(event);
			event.stopImmediatePropagation();
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handleRightDividerDragged(event:DataEvent):void 
		{
			_periodZoomBox.removeSelectedPeriodHighlight();
			(_controller as SDMXDataController).
				handleRightDividerDragged(event);
			event.stopImmediatePropagation();			
		}
		
		/**
		 * @inheritDoc
		 */ 
		protected function handlePeriodChanged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(_controller as SDMXDataController).handlePeriodChange(event);
		}
		
		protected function handleViewChanged(event:DataEvent):void
		{
			event.stopImmediatePropagation();
			_viewStack.displayPanel(uint(event.data));
			_periodSlider.visible = 
				(uint(event.data) == 0);			
			if (_table != null)
				_table.isHidden = (1 == uint(event.data)) ? false : true; 			
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
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitIsPercentage():void
		{
			super.commitIsPercentage();
			if (_chartSummaryBox != null) {
				//_chartSummaryBox.height = _isPercentage ? 25 : 40;
				_chartSummaryBox.showChange = !_isPercentage;
			}
			if (_seriesSummaryBox != null) {
				_seriesSummaryBox.showChange = !_isPercentage;
			}		
			_chart.showChange = !_isPercentage;
		}
		
		/**
		 * @private
		 */
		protected function createSeriesSummaryBox():void
		{
			_seriesSummaryBox = new SeriesSummaryBox();
			_seriesSummaryBox.showChange = _showChange;
			addView(_seriesSummaryBox);
		}
		
		/**
		 * @private
		 */
		protected function createFilterBox():void
		{
			_filterBox = new SDMXDataPanelAdapter("horizontal");
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
			_periodZoomBox.addEventListener("selectedPeriodChanged",
				handlePeriodChanged);
			_filterBox.addView(_periodZoomBox);
		}
		
		protected function createViewSelectorBox():void
		{
			_viewSelectorBox = new ViewSelector();
			_viewSelectorBox.addEventListener(
				ViewSelector.SELECTED_VIEW_CHANGED,	handleViewChanged);
			_filterBox.addView(_viewSelectorBox);
			_viewSelectorBox.views = new ArrayCollection([
					resourceManager.getString("flex_cb_mvc_lang", "chart_view")]);					
			if (_showTableView) {
				_viewSelectorBox.views.addItem(
					resourceManager.getString("flex_cb_mvc_lang", "table_view"));
			}
			if (_showMetadataView) {
				_viewSelectorBox.views.addItem(					 
					resourceManager.getString("flex_cb_mvc_lang", "md_view"));
			}
		}
		
		/**
		 * @private
		 */
		protected function createChartBox():void
		{
			_chartBox = new SDMXDataPanelAdapter();
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
			_chartSummaryBox.percentWidth = 100;
			_chartSummaryBox.showChange = _showChange;
			_chartBox.addView(_chartSummaryBox);
		}
		
		/**
		 * @private
		 */
		protected function createChart():void
		{
			_chart = new ECBLineChart();
			_chart.percentWidth = 100;
			_chart.showChange = _showChange;
			_chart.addEventListener(ECBChartEvents.CHART_DRAGGED, 
				handleDataChartDragged, false, 0, true);		
			_chartAndSliderPanel.addView(_chart);
		}
		
		/**
		 * @private
		 */
		protected function createPeriodSlider():void
		{
			_periodSlider = new PeriodSlider();
			_periodSlider.percentWidth = 100;
			_periodSlider.height = 70;
			_periodSlider.addEventListener(ECBChartEvents.CHART_DRAGGED, 
				handleDataChartDragged, false, 0, true);
			_periodSlider.addEventListener(
				ECBChartEvents.LEFT_DIVIDER_DRAGGED, 
				handleLeftDividerDragged, false, 0, true);	
			_periodSlider.addEventListener(
				ECBChartEvents.RIGHT_DIVIDER_DRAGGED,
				handleRightDividerDragged, false, 0, true);	
			_chartAndSliderPanel.addView(_periodSlider);
		}
		
		/**
		 * @private
		 */
		protected function createLegend():void
		{
			_legend = new ECBLegend();
			_chartBox.addView(_legend);
		}
		
		/**
		 * @private
		 */
		protected function createViewStack():void
		{
			_viewStack = new StackPanel();
			_viewStack.percentWidth  = 100;
			_viewStack.percentHeight = 100;
			_chartBox.addChild(_viewStack);
		}
		
		/**
		 * @private
		 */
		protected function createMetadataPanel():void
		{
			_metadataPanel = new MetadataPanel();
			_metadataPanel.percentWidth = 100;
			_viewStack.addView(_metadataPanel);
		}
		
		/**
		 * @private
		 */
		protected function createTable():void
		{
			_table = new Table();
			_table.percentWidth = 100;
			_table.createChangeColumn = true;
			_table.isHidden = true;
			_viewStack.addView(_table);
		}
		
		/**
		 * @private
		 */
		protected function createChartAndSliderPanel():void
		{
			_chartAndSliderPanel = new SDMXDataPanelAdapter();
			_chartAndSliderPanel.percentHeight = 100;
			_chartAndSliderPanel.percentWidth  = 100;
			_viewStack.addView(_chartAndSliderPanel);
		}
		
		protected function handleChangedWidth(event:Event):void
		{
			if (null != _periodSlider) {
				var w:int = width - 25;			
				_chart.width = _filterBox.width = _periodSlider.width = w;
				if (_table != null) 
					_table.width = w;
				if (_metadataPanel != null)
					_metadataPanel.width = w; 
			}
		}
	}
}