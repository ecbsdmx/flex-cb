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
package eu.ecb.core.view.chart
{
	import mx.charts.AxisRenderer;
	import mx.charts.BarChart;
	import mx.charts.CategoryAxis;
	import mx.charts.ColumnChart;
	import mx.charts.HitData;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.CartesianChart;
	import mx.charts.chartClasses.IAxis;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.graphics.Stroke;

	/**
	 * Event triggered when an item is double-clicked on the chart.
	 * 
	 * @eventType eu.ecb.core.view.chart.ECBChartEvents.CHART_ITEM_DOUBLE_CLICKED
	 */
	[Event(name="itemDoubleClick", type="mx.charts.events.ChartItemEvent")]
	
	/**
	 * Base class to create column charts or bar charts on the ECB website. 
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ECBBarChart extends ECBChart
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 		
		protected var _chart:CartesianChart;
		
		/**
		 * @private
		 */
		protected var _chartLayout:String;
		
		[Embed(source="../../../assets/images/ZoomIn.png")]
		/**
		 * @private
		 */ 
		protected var _drillDownCursor:Class;
		
		/*===========================Constructor==============================*/
		
		/**
		 * Creates an ECB bar or column chart.
		 *  
		 * @param direction The layout of the items (chart, legend, summary, 
		 * 		etc.) in the box. By default, the items will be displayed
		 * 		vertically.
		 * @param chartLayout Whether the bars in the chart should be organised
		 * 		vertically (Flex ColumnChart) or horizontally (Flex BarChart).
		 */
		public function ECBBarChart(direction:String = "vertical", 
			chartLayout:String = "vertical")
		{
			super(direction);
			_chartLayout = chartLayout;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (null == _chart) {
				_chart = ("vertical" == _chartLayout)	? 
					new ColumnChart() : new BarChart();
				_chart.styleName = "ecbBarChart";
				_chart.percentWidth = 100;
				_chart.percentHeight = 100;
				_chart.showDataTips = true;
				_chart.dataTipFunction = formatDataTip;
				
				_chart.seriesFilters = new Array();
				
				var verticalAxis:LinearAxis = new LinearAxis();
				verticalAxis.baseAtZero = true;
				verticalAxis.labelFunction = formatYAxisLabel;
				_chart.verticalAxis = verticalAxis;
				
				var horizontalAxis:CategoryAxis = new CategoryAxis();
				_chart.horizontalAxis = horizontalAxis;
				
				var stroke:Stroke = new Stroke();
				stroke.color = 0xEDEFF1;
				stroke.weight = 1;
				
				var verticalAxisRenderer:AxisRenderer = new AxisRenderer();
				verticalAxisRenderer.setStyle("axisStroke", stroke);
				verticalAxisRenderer.setStyle("tickStroke", stroke);
				_chart.verticalAxisRenderer = verticalAxisRenderer;
				
				var horizontalAxisRenderer:AxisRenderer = new AxisRenderer();	
				horizontalAxisRenderer.setStyle("axisStroke", stroke);
				horizontalAxisRenderer.setStyle("tickStroke", stroke);
				_chart.horizontalAxisRenderer = horizontalAxisRenderer;
				
				addChild(_chart);
			}
		}
		
		/**
		 * Formats the data tip when hovering over a chart item.
		 */ 
		protected function formatDataTip(data:HitData):String 
		{
    		return String(ColumnSeriesItem(data.chartItem).yValue);
		}
		
		protected function formatYAxisLabel(labelValue:Object, 
			previousValue:Object, axis:IAxis):String {
	        return String(labelValue);
		}
	}
}