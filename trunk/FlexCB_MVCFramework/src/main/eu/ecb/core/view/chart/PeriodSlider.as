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
	import eu.ecb.core.view.SDMXViewAdapter;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;  
	
	import mx.binding.utils.ChangeWatcher;
	import mx.charts.AreaChart;
	import mx.charts.AxisRenderer;
	import mx.charts.DateTimeAxis;
	import mx.charts.LinearAxis;
	import mx.charts.series.AreaSeries;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.HDividedBox;
	import mx.controls.HSlider;
	import mx.controls.Spacer;
	import mx.events.DividerEvent;
	import mx.events.SliderEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	import mx.managers.CursorManager;
	
	/**
	 * Event triggered when the chart is dragged in the left or right direction
	 * 
	 * @eventType eu.ecb.core.view.chart.ECBChartEvents.CHART_DRAGGED
	 */
	[Event(name="chartDragged", type="mx.charts.events.ChartItemEvent")]
	
	/**
	 * Event triggered when the left thumb of the slider is dragged
	 * 
	 * @eventType eu.ecb.core.view.chart.ECBChartEvents.LEFT_DIVIDER_DRAGGED
	 */
	[Event(name="leftDividerDragged", type="mx.charts.events.ChartItemEvent")]
	
	/**
	 * Event triggered when the right thumb of the slider is dragged
	 * 
	 * @eventType eu.ecb.core.view.chart.ECBChartEvents.RIGHT_DIVIDER_DRAGGED
	 */
	[Event(name="rightDividerDragged", type="mx.charts.events.ChartItemEvent")]
	
	/**
	 * Displays a period slider that allows to precisely set the start and end
	 * date for data displayed on a chart. The slider offers functionalities
	 * similar to the ones available on web sites like Google Finance and 
	 * Yahoo Finance. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class PeriodSlider extends SDMXViewAdapter
	{
		
		/*==============================Fields================================*/
		
		private var _periodChart:AreaChart;
		
		private var _spacer:Spacer;
		
		private var _sliderBox:HBox;
		
		private var _slider:HSlider;
		
		private var _overlayCanvas:HDividedBox;
		
		private var _leftCanvasBox:Canvas;
		
		private var _middleCanvasBox:Canvas;
		
		private var _rightCanvasBox:Canvas;
		
		private var _rightIndex:uint;
		
		private var _leftIndex:uint;
		
		private var _isDragging:Boolean;
		      	
      	private var _mouseXRef:Number;

		private var _cursorId:Number;
		
		private var _previousRemainder:Number;
		
		[Embed(source="../../../assets/images/fleur.png")] 
		private var _dragCursor:Class;
		
		[Embed(source="../../../assets/images/blank.png")]
		private var _blankDividerClass:Class;
				
		/*===========================Constructor==============================*/
		
		public function PeriodSlider(direction:String = "vertical")
		{
			super(direction);
			styleName = "ecbPeriodChartBox";
			_previousRemainder = 0;
			ChangeWatcher.watch(this, "width", handleChangedWidth);
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (null == _periodChart) {
				_periodChart = new AreaChart();
				_periodChart.styleName = "ecbPeriodChart";
				_periodChart.height = 60;
				_periodChart.showDataTips = false;
				_periodChart.seriesFilters = new Array();
				_periodChart.percentWidth = 100	

				var verticalAxis:LinearAxis = new LinearAxis();
				verticalAxis.baseAtZero = false;
				_periodChart.verticalAxis = verticalAxis;
				
				var horizontalAxis:DateTimeAxis = new DateTimeAxis();
				horizontalAxis.alignLabelsToUnits = false;
				horizontalAxis.dataUnits = "days";
				horizontalAxis.labelFunction = formatHorizontalAxisLabels;
				horizontalAxis.labelUnits = "years";
				horizontalAxis.dataInterval = 1;
				_periodChart.horizontalAxis = horizontalAxis;
				
				var stroke:Stroke = new Stroke();
				stroke.color = 0xEDEFF1;
				stroke.weight = 1;
				
				var horizontalAxisRenderer:AxisRenderer = new AxisRenderer();	
				horizontalAxisRenderer.visible = true;
				horizontalAxisRenderer.styleName = "ecbHorizontalAxisRenderer";
				horizontalAxisRenderer.setStyle("axisStroke", stroke);
				horizontalAxisRenderer.setStyle("minorTickStroke", stroke);
				horizontalAxisRenderer.setStyle("tickStroke", stroke);				
				_periodChart.horizontalAxisRenderer = horizontalAxisRenderer;
				
				var verticalAxisRenderer:AxisRenderer = new AxisRenderer();
				verticalAxisRenderer.visible = false;
				verticalAxisRenderer.height = 0;
				_periodChart.verticalAxisRenderer = verticalAxisRenderer;
				
				_periodChart.backgroundElements = [];
				
				_overlayCanvas = new HDividedBox();
				_overlayCanvas.height = _periodChart.height - 2;
				_overlayCanvas.styleName = "ecbPeriodCanvas";
				_overlayCanvas.horizontalScrollPolicy = "off";
				_overlayCanvas.liveDragging = true;
				_overlayCanvas.setStyle("dividerSkin", _blankDividerClass);
				_overlayCanvas.addEventListener(DividerEvent.DIVIDER_DRAG, 
					handleDividerDrag, false, 0, true);
				_overlayCanvas.addEventListener(DividerEvent.DIVIDER_RELEASE,
					handleDividerRelease, false, 0, true);	
				
				_leftCanvasBox = new Canvas();
				_leftCanvasBox.height = _periodChart.height - 2;
				_overlayCanvas.addChild(_leftCanvasBox);
				
				_middleCanvasBox = new Canvas();
				_middleCanvasBox.height = _periodChart.height - 2;
				_middleCanvasBox.addEventListener(MouseEvent.MOUSE_DOWN, 
					handleMouseDown, false, 0, true);
				_overlayCanvas.addEventListener(MouseEvent.MOUSE_UP,
					handleMouseUp, false, 0, true);
				_overlayCanvas.addEventListener(MouseEvent.ROLL_OUT,
					handleMouseUp, false, 0, true);
				_overlayCanvas.addEventListener(MouseEvent.MOUSE_MOVE, 
					handleMiddleCanvasMoved, false, 0, true);				
				_overlayCanvas.addChild(_middleCanvasBox);
				
				_rightCanvasBox = new Canvas();
				_rightCanvasBox.height = _periodChart.height - 2;
				_overlayCanvas.addChild(_rightCanvasBox);
				
				_periodChart.annotationElements = [_overlayCanvas];
				addChild(_periodChart);
			}
			
			if (null == _spacer) {
				_spacer = new Spacer();
				_spacer.height = -14;
				addChild(_spacer);
			}
			
			if (null == _sliderBox) {
				_sliderBox = new HBox();
				_sliderBox.percentWidth = 100;
				_sliderBox.setStyle("horizontalAlign", "right");
				_sliderBox.setStyle("paddingRight", -5);
				addChild(_sliderBox);	
			}
			
			if (null == _slider) {
				_slider = new HSlider();
				_slider.height = 20;
				_slider.percentWidth = 100;
				_slider.allowTrackClick = true;
				_slider.allowThumbOverlap = true;
				_slider.liveDragging = true;
				_slider.showDataTip = false;
				_slider.thumbCount = 2;
				_slider.snapInterval = 1;
				_slider.minimum = 0;
				_slider.addEventListener("change", updateBoundariesFromSlider);
				_slider.setStyle("showTrackHighlight", true);
				_slider.setStyle("trackSkin", PeriodSliderTrackSkin);
				_slider.setStyle("trackHighlightSkin", 
					PeriodSliderHighlightSkin);
				_sliderBox.addChild(_slider);
			}
		}
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				var allSeries:Array = _periodChart.series;
				if (allSeries.length == 0) {
					var areaSeriesAll:AreaSeries = new AreaSeries();
					areaSeriesAll.yField = "observationValue";
					areaSeriesAll.xField = "timeValue";
					var axisStrokeAll:Stroke = new Stroke();
					axisStrokeAll.color = 0xCCCCCC;
					axisStrokeAll.weight = 1;
					axisStrokeAll.alpha = .7;
					areaSeriesAll.setStyle("areaStroke", axisStrokeAll);
					var solidColorAll:SolidColor = new SolidColor();
					solidColorAll.color = 0xCCCCCC;
					solidColorAll.alpha = .1;
					areaSeriesAll.setStyle("areaFill", solidColorAll);
					allSeries.push(areaSeriesAll);
					
					var areaSeriesSelected:AreaSeries = new AreaSeries();
					areaSeriesSelected.yField = "observationValue";
					areaSeriesSelected.xField = "timeValue";
					var axisStrokeSelected:Stroke = new Stroke();
					axisStrokeSelected.color = 0x2C70AA;
					axisStrokeSelected.weight = 1;
					areaSeriesSelected.setStyle("areaStroke", 
						axisStrokeSelected);
					var solidColorSelected:SolidColor = new SolidColor();
					solidColorSelected.color = 0x2C70AA;
					solidColorSelected.alpha = .1;
					areaSeriesSelected.setStyle("areaFill", solidColorSelected);
					allSeries.push(areaSeriesSelected);
				}
				if (allSeries[0].dataProvider != _referenceSeries.timePeriods) {	
					allSeries[0].dataProvider = _referenceSeries.timePeriods;
				}	
				_periodChart.series = allSeries;	
				_slider.maximum = _referenceSeries.timePeriods.length - 1;	
				_periodChart.width = Math.round(width);
				_overlayCanvas.width = Math.ceil( _periodChart.width + 
						_periodChart.computedGutters.width - 22);
				_slider.width = _overlayCanvas.width + 13;				
			}
			
			if (_filteredReferenceSeriesChanged) {
				_filteredReferenceSeriesChanged = false;
				if (_periodChart.series[1].dataProvider !=
					_filteredReferenceSeries.timePeriods) { 
					_periodChart.series[1].dataProvider = 
						_filteredReferenceSeries.timePeriods;
				}
				_leftIndex = _referenceSeries.timePeriods.getItemIndex(
					_filteredReferenceSeries.timePeriods.getItemAt(0));
				_rightIndex = _referenceSeries.timePeriods.getItemIndex(
					_filteredReferenceSeries.timePeriods.getItemAt(
					_filteredReferenceSeries.timePeriods.length - 1)); 
				var ratio:Number = (_referenceSeries.timePeriods.length / 
					_overlayCanvas.width);
				_leftCanvasBox.width = Math.round(_leftIndex / ratio);
				_rightCanvasBox.width = Math.round((_referenceSeries.timePeriods
					.length - 1 - _rightIndex)/ratio);
				_middleCanvasBox.width = Math.round(_overlayCanvas.width - 
					_leftCanvasBox.width - _rightCanvasBox.width) - (2 * 
					Number(_overlayCanvas.getStyle("dividerThickness")));
				_slider.values = [_leftIndex, _rightIndex];				
			}
		}
		
		/*=========================Private methods============================*/		
		
		private function handleMouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event = null;
			_cursorId = CursorManager.setCursor(_dragCursor);
			_mouseXRef = this.mouseX;
			_isDragging = true;
		}
		
		private function handleMouseUp(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			event = null;
			if (_isDragging) {
				CursorManager.removeAllCursors();
				_isDragging = false;
			}
		}
		
		private function handleMiddleCanvasMoved(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event = null;
			if (_isDragging) {
				var physicalDelta:Number = this.mouseX - _mouseXRef;
				var physicalSpacing:Number = _overlayCanvas.width /
						_referenceSeries.timePeriods.length;
				var logicalDelta:Number = 
					Math.round(physicalDelta / physicalSpacing);
				if (_rightIndex < _referenceSeries.timePeriods.length - 1 &&
					logicalDelta + _rightIndex > 
						_referenceSeries.timePeriods.length - 1) {
					logicalDelta = _referenceSeries.timePeriods.length - 1 - 
						_rightIndex;		
				}		
				if (Math.abs(logicalDelta) >= 1 && 
					logicalDelta + _leftIndex >= 0 &&
					logicalDelta + _rightIndex <= 
						_referenceSeries.timePeriods.length - 1) {
					_mouseXRef += logicalDelta * physicalSpacing;			
					dispatchEvent(new DataEvent(ECBChartEvents.CHART_DRAGGED, 
						false, false, String(logicalDelta)));
				} else if (_leftIndex > 0 && logicalDelta + _leftIndex < 0) {
					_mouseXRef += 1 * physicalSpacing;			
					dispatchEvent(new DataEvent(ECBChartEvents.CHART_DRAGGED, 
						false, false, String(logicalDelta)));
				}	
			}
		}        
		
        private function handleDividerDrag(event:DividerEvent):void
        {
        	var remainder:Number = Math.round(event.delta / 
				(_overlayCanvas.width / _referenceSeries.timePeriods.length));
			event.stopImmediatePropagation();	
			dispatchEvent(new DataEvent((0 == event.dividerIndex) ? 	
				ECBChartEvents.LEFT_DIVIDER_DRAGGED : 
				ECBChartEvents.RIGHT_DIVIDER_DRAGGED, false, false, 
				String(remainder - _previousRemainder)));
			event = null;
			_previousRemainder = remainder;
        }
        
        private function handleDividerRelease(event:DividerEvent):void 
        {
        	event.stopImmediatePropagation();
			event = null;
        	_previousRemainder = 0;
        }
        
        private function formatHorizontalAxisLabels(labelValue:Object, 
            previousLabelValue:Object, axis:DateTimeAxis):String 
        {
            return "           " + String((labelValue as Date).getFullYear());
        }
        
        private function updateBoundariesFromSlider(event:SliderEvent):void
        {
        	var returned:int = (0 == event.thumbIndex) ? 
        		event.value - _leftIndex : event.value - _rightIndex;
        	if (0 == event.thumbIndex) {
        		dispatchEvent(new DataEvent(ECBChartEvents.LEFT_DIVIDER_DRAGGED,
        			false, false, String(event.value - _leftIndex)));
        		_leftIndex = event.value;	
        	} else {
        		dispatchEvent(new DataEvent(ECBChartEvents.RIGHT_DIVIDER_DRAGGED,
        			false, false, String(event.value - _rightIndex)));
        		_rightIndex = event.value;	
        	}
        }
        
        private function handleChangedWidth(event:Event):void
		{
			if (null != _slider && null != _referenceSeries) {
				_periodChart.width = Math.round(width);
				_overlayCanvas.width = Math.ceil( _periodChart.width + 
					_periodChart.computedGutters.width - 22);
				_slider.width = _overlayCanvas.width + 13;
				var ratio:Number = (_referenceSeries.timePeriods.length / 
					_overlayCanvas.width);
				_leftCanvasBox.width = Math.round(_leftIndex / ratio);
				_rightCanvasBox.width = Math.round((_referenceSeries.timePeriods
					.length - 1 - _rightIndex)/ratio);
				_middleCanvasBox.width = Math.round(_overlayCanvas.width - 
					_leftCanvasBox.width - _rightCanvasBox.width) - (2 * 
					Number(_overlayCanvas.getStyle("dividerThickness")));
			} 
		}
	}
}