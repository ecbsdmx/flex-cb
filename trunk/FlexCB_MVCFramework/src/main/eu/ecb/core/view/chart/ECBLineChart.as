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
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.util.formatter.observation.IObservationFormatter;
	import eu.ecb.core.util.helper.SeriesColors;
	import eu.ecb.core.util.math.MathHelper;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.charts.AxisRenderer;
	import mx.charts.DateTimeAxis;
	import mx.charts.GridLines;
	import mx.charts.HitData;
	import mx.charts.LineChart;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.NumericAxis;
	import mx.charts.effects.SeriesInterpolate;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.LineSeries;
	import mx.collections.IViewCursor;
	import mx.effects.easing.Quadratic;
	import mx.formatters.DateFormatter;
	import mx.graphics.Stroke;
	import mx.managers.CursorManager;
	
	import org.sdmx.model.v2.reporting.dataset.AttributeValue;
	import org.sdmx.model.v2.reporting.dataset.CodedAttributeValue;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.UncodedAttributeValue;

	/**
	 * Event triggered when the chart is dragged in the left or right direction
	 * 
	 * @eventType eu.ecb.core.view.chart.ECBChartEvents.CHART_DRAGGED
	 */
	[Event(name="chartDragged", type="flash.events.DataEvent")]
	
	/**
	 * Base class to create line charts on the ECB website. 
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public class ECBLineChart extends ECBChart {
		
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 		
		protected var _chart:LineChart;
		
		private var _dateAxisFormatter:SDMXDateFormatter;
		
		private var _dataLength:uint;

		/** Fields needed for the tool tip*/		
		private var _innerCircle:Shape;

      	private var _outerCircle:Shape;

      	private var _axisCircle:Shape;

      	private var _dataTipBox:Sprite;
      	
      	private var _dataTipText:TextField;
      	
      	[Bindable]
      	private var _boxText:String;
      	
      	private var _latestTextBoxWidth:Number;

      	private var _isFirst:Boolean;
      	
      	/**
		 * @private
		 */ 
      	protected var _dateFormatter:DateFormatter;
      	
      	private var _isoDateFormatter:DateFormatter;
      	
      	private var _percentFormatter:ExtendedNumberFormatter;
      	
      	private var _numberFormatter:ExtendedNumberFormatter;
      	
      	private var _observationValueFormatter:IObservationFormatter;
      	
      	private var _isDragging:Boolean;
      	
      	private var _mouseXRef:Number;
      	
      	/**
		 * The id of the cursor used when dragging the chart
		 */
		private var _cursorId:Number;
		
		/**
		 * The icon for the cursor used when dragging the chart
		 */
		[Embed(source="../../../assets/images/fleur.png")] 
		private var _dragCursor:Class;
		
		private var _effect:SeriesInterpolate;
		
		private var _showECBToolTip:Boolean;
		
		/**
		 * @private
		 */ 
		protected var _showSeriesTitle:Boolean;
		
		private var _seriesTitleIndex:uint;
		
		private var _seriesTitleAttachmentLevel:uint;
		
		private var _baseAtZero:Boolean;
		
		private var _indexColor:Array;
		/*===========================Constructor==============================*/

		/**
		 * Creates an ECB line chart.
		 *  
		 * @param direction The layout of the items (chart, legend, summary, 
		 * 		etc.) in the box. By default, the items will be displayed
		 * 		vertically.
		 */
		public function ECBLineChart(direction:String = "vertical")
		{
			super(direction);
			_dateFormatter = new DateFormatter();
			_isoDateFormatter = new DateFormatter();
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.forceSigned = true;
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			_numberFormatter = new ExtendedNumberFormatter();
			_numberFormatter.forceSigned = true;
			_dateAxisFormatter = new SDMXDateFormatter();
			_dateAxisFormatter.isShortFormat = true;
			_referenceSeriesFrequency = "M";
			_isFirst = true;
			_showECBToolTip = true;
			_baseAtZero = true;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */ 
		public function set observationValueFormatter(
			formatter:IObservationFormatter):void 
		{
			_observationValueFormatter = formatter;
		}
		
		/**
		 * The class tasked with formatting obersvation values.
		 */ 
		public function get observationValueFormatter():IObservationFormatter 
		{
			return _observationValueFormatter;
		}
		
		/**
		 * Whether or not ECB tool tips should be displayed instead of standard
		 * Flex tool tips. 
		 */
		public function set showECBToolTip(flag:Boolean):void
		{
			_showECBToolTip = flag;
			if (!_showECBToolTip) {
				_chart.showDataTips = true;
				_chart.dataTipMode  = "multiple";
				_chart.dataTipFunction = customizeDataTip;
			}
		}
		
		/**
		 * Whether or not series titles should be displayed. 
		 */
		public function set showSeriesTitle(flag:Boolean):void
		{
			_showSeriesTitle = flag;
		}
		
		/**
		 * The index of the dimension or attribute to be used as series title.
		 */ 
		public function set seriesTitleIndex(index:uint):void
		{
			_seriesTitleIndex = index;
		}
		
		/**
		 * The attachment level (series, group) of the dimension or attribute to 
		 * be used as series title.
		 */ 
		public function set seriesTitleAttachmentLevel(level:uint):void
		{
			if (level != 1 && level != 2) {
				throw new ArgumentError("The attachement level must be 1 - " + 
						"series - or 2 - group.");
			}
			_seriesTitleAttachmentLevel = level;
		}
		
		/**
		 * Whether or not the vertical chart axis should be based at zero. 
		 * @param flag
		 */
		public function set baseAtZero(flag:Boolean):void
		{
			_baseAtZero = flag;
			if (null != _chart && _chart.verticalAxis is NumericAxis) {
				(_chart.verticalAxis as NumericAxis).baseAtZero = _baseAtZero;
			} 
		}
		
		/**
		 * An array containing an index of the colours to be used for the line
		 * chart
		 */ 
		public function set indexColor(index:Array):void
		{
			if (null == index) {
				_indexColor = new Array;
			}
			_indexColor = index;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void 
		{
			super.createChildren();
			if (null == _chart) {
				
				//Displaying the chart
				_chart = new LineChart();
				_chart.showDataTips = false;
				_chart.percentHeight = 100;
				_chart.percentWidth = 100;
				_chart.styleName = "ecbLineChart";
				
				_chart.addEventListener(MouseEvent.MOUSE_DOWN, setMouseDown, 
					false, 0, true);
				_chart.addEventListener(MouseEvent.MOUSE_UP, 
					cleanItemsOnChart, false, 0, true);
				_chart.addEventListener(MouseEvent.ROLL_OUT, 
					cleanItemsOnChart, false, 0, true);
				_chart.addEventListener(MouseEvent.MOUSE_MOVE, 
					moveOverChart, false, 0, true);
				_chart.addEventListener(ChartItemEvent.ITEM_CLICK,
					handleItemClicked);	
				
				//Removes the shadow of the lines
				_chart.seriesFilters = new Array();
				
				var verticalAxis:LinearAxis = new LinearAxis();
				verticalAxis.baseAtZero = false;
				_chart.verticalAxis = verticalAxis;
				
				var horizontalAxis:DateTimeAxis = new DateTimeAxis();
				horizontalAxis.labelFunction = formatDateAxisLabels;
				_chart.horizontalAxis = horizontalAxis;
				
				var stroke:Stroke = new Stroke();
				stroke.color = 0xEDEFF1;
				stroke.weight = 1;
				
				var gridLines:GridLines = new GridLines();
				gridLines.styleName = "ecbLineChartGridLines";
				gridLines.setStyle("horizontalOriginStroke", stroke);
				gridLines.setStyle("horizontalStroke", stroke);
				gridLines.setStyle("verticalOriginStroke", stroke);
				gridLines.setStyle("verticalStroke", stroke);												
				_chart.backgroundElements = [gridLines];
				
				var horizontalAxisRenderer:AxisRenderer = new AxisRenderer();	
				horizontalAxisRenderer.styleName = "ecbLineChartHorizontalAxis";
				horizontalAxisRenderer.setStyle("axisStroke", stroke);
				horizontalAxisRenderer.setStyle("minorTickStroke", stroke);
				horizontalAxisRenderer.setStyle("tickStroke", stroke);
				_chart.horizontalAxisRenderer = horizontalAxisRenderer;
				
				var verticalAxisRenderer:AxisRenderer = new AxisRenderer();
				verticalAxisRenderer.setStyle("axisStroke", stroke);
				verticalAxisRenderer.setStyle("tickStroke", stroke);
				_chart.verticalAxisRenderer = verticalAxisRenderer;
				
				addChild(_chart);
			}
		}
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void 
		{
			super.commitProperties();
			if (_filteredDataSetChanged) {
				_filteredDataSetChanged = false;
				
				_dataLength = 
					(_filteredDataSet.timeseriesKeys.getItemAt(0) as 
						TimeseriesKey).timePeriods.length;	
				if (_referenceSeriesFrequency == "B" || 
					_referenceSeriesFrequency == "D") {
		            if (_dataLength >= 1320) {
		            	_dateAxisFormatter.frequency = "A";
	        	    } else if (_dataLength <= 50) {
	        	    	_dateAxisFormatter.frequency = "D";
		            } else {
	    	            _dateAxisFormatter.frequency = "M";
	        	    }
	            } else if (_referenceSeriesFrequency == "M") {
	            	if (_dataLength < 130) {
		            	_dateAxisFormatter.frequency = "M";
	        	    } else {
	    	            _dateAxisFormatter.frequency = "A";
	        	    }
	            } else if (_referenceSeriesFrequency == "Q") {
	            	if (_dataLength < 60) {
		            	_dateAxisFormatter.frequency = "Q";
	        	    } else {
	    	            _dateAxisFormatter.frequency = "A";
	        	    }
	            } else if (_referenceSeriesFrequency == "A") {
	            	_dateAxisFormatter.frequency = "A";
	            }	
				
				var isChanged:Boolean = false
				var allLineSeries:Array = _chart.series;
				var availableLineSeries:int = allLineSeries.length - 
					_filteredDataSet.timeseriesKeys.length;
				if (availableLineSeries < 0) {
					createLineSeries(availableLineSeries, allLineSeries);
					isChanged = true;
				} else if (availableLineSeries > 0) {
					deleteLineSeries(availableLineSeries, allLineSeries);
					isChanged = true;
				}
				
				for (var i:uint = 0; i < _filteredDataSet.timeseriesKeys.length; 
					i++) {
					var isSeriesChanged:Boolean = true;	
					var periods:TimePeriodsCollection = (_filteredDataSet.
						timeseriesKeys.getItemAt(i) as TimeseriesKey).
						timePeriods; 	
					if (allLineSeries[i].dataProvider != periods) {
						allLineSeries[i].dataProvider = periods;
						isChanged = true;
						isSeriesChanged = true;
					} 
					
					if (isSeriesChanged) {	
						var axisStroke:Stroke = new Stroke();
						if (_indexColor != null){
							axisStroke.color = 
								(SeriesColors.getColors().length > i) ?
								SeriesColors.getColors().getItemAt(
								_indexColor[i])	as uint : Math.round(
								Math.random()*0xFFFFFF);
						} else {
							axisStroke.color = 
								(SeriesColors.getColors().length > i) ?
								SeriesColors.getColors().getItemAt(i) as uint : 
								Math.round( Math.random()*0xFFFFFF );
						}
						axisStroke.weight = 1;
						(allLineSeries[i] as LineSeries).setStyle("lineStroke", 
							axisStroke);
					
						if (_showSeriesTitle) {
							var title:String;
							var attribute:AttributeValue;
							if (1 == _seriesTitleAttachmentLevel && (
								_filteredDataSet.timeseriesKeys.getItemAt(i) as 
								TimeseriesKey).attributeValues.length > 
								_seriesTitleIndex) {
								attribute = (_filteredDataSet.timeseriesKeys.
									getItemAt(i) as	TimeseriesKey).
									attributeValues.getItemAt(_seriesTitleIndex) 
									as AttributeValue;
							} else if (2 == _seriesTitleAttachmentLevel && 
								(_filteredDataSet.groupKeys.
								getGroupsForTimeseries(_filteredDataSet.
								timeseriesKeys.getItemAt(i) as 
								TimeseriesKey).getItemAt(0) as GroupKey).
								attributeValues.length > _seriesTitleIndex) {
								attribute = (_filteredDataSet.groupKeys.
									getGroupsForTimeseries(_filteredDataSet.
									timeseriesKeys.getItemAt(i) as TimeseriesKey
									).getItemAt(0) as GroupKey).attributeValues.
									getItemAt(_seriesTitleIndex) as 
									AttributeValue;
							}
							if (attribute is CodedAttributeValue) {
								title = 
									(attribute as CodedAttributeValue).value.id;
							} else if (attribute is UncodedAttributeValue) {
								title = 
									(attribute as UncodedAttributeValue).value;
							}
							allLineSeries[i].displayName = title;
						}		
					}
				}
				if (isChanged) {
					_chart.series = allLineSeries;
				}
				setAxisTicksAndLabels();
			}
			
			if (_referenceSeriesFrequencyChanged) {
				_referenceSeriesFrequencyChanged = false;
				if (_referenceSeriesFrequency == "M" || 
					_referenceSeriesFrequency == "Q") {
		    		_isoDateFormatter.formatString = "YYYY-MM";
		    		_dateFormatter.formatString = "MMMM YYYY";
		    	} else if (_referenceSeriesFrequency == "B" || 
		    		_referenceSeriesFrequency == "D") {
		    		_isoDateFormatter.formatString = "YYYY-MM-DD";
		    		_dateFormatter.formatString = "D MMMM YYYY";
		    	} else if (_referenceSeriesFrequency == "A") {
			    	_isoDateFormatter.formatString = "YYYY";
			    	_dateFormatter.formatString = "YYYY";
		    	}
			}
			
			if (_isPercentageChanged) {
				_isPercentageChanged = false;
				if (_isPercentage && _baseAtZero) {
					(_chart.verticalAxis as LinearAxis).baseAtZero = true;
				} else {
					(_chart.verticalAxis as LinearAxis).baseAtZero = false;
				}
			}	
		}
		
		/**
		 * Formats the data tip to be displayed 
		 */
		protected function customizeDataTip(data:HitData):String
		{
			var obs:TimePeriod = data.item as TimePeriod;
			var dataTip:String = "";
			if (_showSeriesTitle && _filteredDataSet.timeseriesKeys.length > 1){
				dataTip = "<font face='Verdana, Arial, Helvetica, " + 
					"sans-serif' size='10' color='#707070'><b>" + (data.element 
					as LineSeries).displayName + " -</b></font>";
			}
			dataTip = dataTip + " <font face='Verdana, Arial, Helvetica, " + 
					"sans-serif' size='10' color='#707070'><b>" + 
					_dateFormatter.format(obs.timeValue) + ":</b> " + 
					"<font color='#000000'>";
			if (null != observationValueFormatter) {
				observationValueFormatter.series = 
					(data.element as LineSeries).dataProvider as TimeseriesKey;
				observationValueFormatter.group = 
					(_filteredDataSet.groupKeys.getGroupsForTimeseries(
					(data.element as LineSeries).dataProvider as TimeseriesKey)
					as GroupKeysCollection).getItemAt(0) as GroupKey;
					dataTip = dataTip + observationValueFormatter.format(
						obs.observationValue);		
			} else {
				dataTip = dataTip + obs.observationValue;
			}
			if (_isPercentage) {
				dataTip = dataTip + "%";
			}
			dataTip = dataTip + "</font>";
			return dataTip;		
		}
		
		/*=========================Private methods============================*/
		
		/**
         * This method formats the labels for the data chart, depending on the
         * frequency and the length of the longest series.
         */
        private function formatDateAxisLabels(labelValue:Object, 
            previousLabelValue:Object, axis:DateTimeAxis):String 
		{
            return _dateAxisFormatter.format(labelValue as Date);
        }
        
        private function setAxisTicksAndLabels():void 
        {
        	(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = true;
        	if (_referenceSeriesFrequency == "D" || 
        		_referenceSeriesFrequency == "B") {
        		(_chart.horizontalAxis as DateTimeAxis).dataUnits = "days";
        		(_chart.horizontalAxis as DateTimeAxis).dataInterval = 1;
	        	if (_dataLength <= 50) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "weeks";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "days";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = false;
				} else if (22 < _dataLength && _dataLength <= 150) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "weeks";
				} else if (150 < _dataLength && _dataLength <= 600) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "months";
				} else if (600 < _dataLength && _dataLength <= 1750) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = false;
				} else {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = false;
				}
        	} else if (_referenceSeriesFrequency == "M" || 
        		_referenceSeriesFrequency == "Q") {
       			(_chart.horizontalAxis as DateTimeAxis).dataUnits = "months";
       			(_chart.horizontalAxis as DateTimeAxis).dataInterval = 
       				(_referenceSeriesFrequency == "M") ?  1 : 3;
        		if (_dataLength <= 15) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = true;
				} else if (22 < _dataLength && _dataLength <= 125) {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "months";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = false;
				} else {
					(_chart.horizontalAxis as DateTimeAxis).labelUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).minorTickUnits = "years";
					(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = true;
				}
        	} else if (_referenceSeriesFrequency == "A") {
        		(_chart.horizontalAxis as DateTimeAxis).dataUnits = "years";
        		(_chart.horizontalAxis as DateTimeAxis).dataInterval = 1;
        		(_chart.horizontalAxis as DateTimeAxis).alignLabelsToUnits = true;
        	}
        }
        
        private function displayObsData(event:Event):void 
        {
        	event.stopImmediatePropagation();
        	var date:Date = new Date(event.currentTarget.localToData(
	    		new Point(event.currentTarget.mouseX, 
	    		event.currentTarget.mouseY))[0]);
			var observations:Array = 
				findObservations(_isoDateFormatter.format(date));

			if (observations.length == 0) {
				date.date = date.date - 1;
				observations = findObservations(_isoDateFormatter.format(date));
			}
			
			if (observations.length == 0) {
				date.date = date.date - 1;
				observations = findObservations(_isoDateFormatter.format(date));
			}
			
			if (0 < observations.length) {
		    	if (null == _dataTipText) {
		    		_dataTipText = new TextField();
		    		_boxText = "";
		    	}
				var selectedSeries:TimeseriesKey = 
					_filteredDataSet.timeseriesKeys.getItemAt(0)
						as TimeseriesKey;		    	
		    	var ratio:Number = 
		    		Math.round(selectedSeries.timePeriods.length /
					(_chart.width - _chart.computedGutters.left) - 1);
				var lastObs:TimePeriod;
				if (ratio > 0) {
					var index:uint = selectedSeries.timePeriods.
						getItemIndex(observations[0]);
					var firstHalf:Boolean = 
						index < selectedSeries.timePeriods.length / 2;
					if (firstHalf) {
						lastObs = (index - ratio > 0) ? 
							selectedSeries.timePeriods.getItemAt(index - ratio) 
								as TimePeriod: selectedSeries.timePeriods.
								getItemAt(0) as TimePeriod;
					} else {
						lastObs = (index + ratio < 
							selectedSeries.timePeriods.length) ? 
							selectedSeries.timePeriods.getItemAt(index + ratio)
								as TimePeriod :
							selectedSeries.timePeriods.getItemAt(
								selectedSeries.timePeriods.length - 1) 
								as TimePeriod;
					}
				} else {
			    	lastObs = observations[0] as TimePeriod;				
				}

				_boxText = " <font face='Verdana, Arial, Helvetica, " + 
					"sans-serif' size='10' color='#707070'><b>" + 
					_dateFormatter.format(lastObs.timeValue) + ":</b> " + 
					"<font color='#000000'>";
					
				if (observations.length == 1) {
					// Latest value
					if (null != observationValueFormatter) {
						observationValueFormatter.series = selectedSeries;
						observationValueFormatter.group = 
							(_filteredDataSet.groupKeys.getGroupsForTimeseries(
								selectedSeries) as GroupKeysCollection).getItemAt(0) 
									as GroupKey;
						_boxText = _boxText + observationValueFormatter.format(
							lastObs.observationValue);		
					} else {
						_boxText = _boxText + lastObs.observationValue;
					}
					if (_isPercentage) {
						_boxText = _boxText + "%";
					}
					_boxText = _boxText + "</font>";
					var position:uint = 
						selectedSeries.timePeriods.getItemIndex(lastObs);
						
					//Change	
					if (_showChange && 0 < position && 
						position - 1 < selectedSeries.timePeriods.length - 1) {
						var color:String = "#000000";
						var previousObs:TimePeriod = 
							selectedSeries.timePeriods.getItemAt(position - 1) 
								as TimePeriod;	
						if (Number(lastObs.observationValue) > 
							Number(previousObs.observationValue)) {
	                		color = "#009933";
			            } else if (Number(lastObs.observationValue) < 
			            	Number(previousObs.observationValue)) {
	        	        	color = "#CC0000";
	            		}
	            		//Get the number of decimals and set the formatter's precision	
						_numberFormatter.precision = 
							lastObs.observationValue.indexOf(".") > -1 ? 
					    		lastObs.observationValue.substring(
					    			lastObs.observationValue.indexOf(".") + 1, 
		    						lastObs.observationValue.length).length : 0;
	             		_boxText = _boxText + "\n Change: <font " + 
	             				"color='" + color + "'>" 
	             			+  _numberFormatter.format(
	             				Number(lastObs.observationValue) - 
	             				Number(previousObs.observationValue));
	             		if (_isPercentage) {		
	             			_boxText = _boxText + "%";
	             		} else {
	             			_boxText = _boxText + " (" + 
	             				_percentFormatter.format(
	             				MathHelper.calculatePercentOfChange(
	             					Number(previousObs.observationValue), 
	             					Number(lastObs.observationValue))) 
		             			+ "%)";	
	             		}
	             		_boxText = _boxText + "</font>";
	             		color = null;
	             		previousObs = null;
					}
					selectedSeries = null;
					
		    		_boxText = _boxText + "</font>";
				} else {
					//ToDo, tool tip for multiple observations
				}
				_dataTipText.htmlText = _boxText;
				_dataTipText.width = _dataTipText.textWidth + 5;
				var point:Point = 
					event.currentTarget.dataToLocal(lastObs.timeValue,
						lastObs.observationValue);
				lastObs = null;		
				var x:Number = Math.floor(point.x);
				var y:Number = Math.floor(point.y);
				point = null;
                if (_isFirst) {			
					_innerCircle = new Shape();
		            _outerCircle = new Shape();
		            _axisCircle = new Shape();
					_dataTipBox = new Sprite();
					_innerCircle.graphics.beginFill(0x2C70AA);
					_innerCircle.graphics.drawCircle(0, 0, 2.5);
					_chart.addChild(_innerCircle);
				
					_outerCircle.graphics.lineStyle(1, 0x2C70AA, 1);
					_outerCircle.graphics.drawCircle(0, 0, 5);
					_chart.addChild(_outerCircle);
				
					_axisCircle.graphics.beginFill(0x707070);
					_axisCircle.graphics.drawCircle(0, _chart.height - 28, 
						2);
					_chart.addChild(_axisCircle);

					_dataTipBox.graphics.lineStyle(1, 0xEDEFF1, 1);
					_dataTipBox.graphics.beginFill(0xFFFFFF, .7);
					_dataTipBox.graphics.drawRect(0, 0, 
						_dataTipText.textWidth + 10, _dataTipText.textHeight + 5);
					_dataTipBox.graphics.lineTo(0, _dataTipText.textHeight + 5);
					_dataTipBox.graphics.endFill();
					_dataTipBox.addChild(_dataTipText);
					_chart.addChild(_dataTipBox);
					_isFirst = false;
				} else if (_dataTipBox.width != _latestTextBoxWidth || 
					_dataTipBox.width < _dataTipText.textWidth || 
					_dataTipBox.height < _dataTipText.textHeight || 
					_dataTipBox.width > _dataTipText.textWidth + 10 || 
					_dataTipBox.height > _dataTipText.textHeight + 5) {
					_dataTipBox.graphics.clear();
					_dataTipBox.graphics.lineStyle(1, 0xEDEFF1, 1);
					_dataTipBox.graphics.beginFill(0xFFFFFF, .7);
					_dataTipBox.graphics.drawRect(0, 0, 
						_dataTipText.textWidth + 10, _dataTipText.textHeight + 5);
					_dataTipBox.graphics.lineTo(0, _dataTipText.textHeight + 5);	
					_dataTipBox.graphics.endFill();
				}
				event = null;
				_innerCircle.x = x;
				_innerCircle.y = y;
				_outerCircle.x = x;
				_outerCircle.y = y;
				_axisCircle.x = x;
				
				_dataTipBox.x = 
					(x + _dataTipText.textWidth - 5 < _chart.width) ? x + 5 : 
						x - (_dataTipText.textWidth + 5);
				_dataTipBox.y = 
					(y + _dataTipText.textHeight < _chart.height) ? y + 5 : 
						y - (_dataTipText.textHeight + 5);
				_latestTextBoxWidth = _dataTipBox.width;
			}
	    	observations.source = new Array();
			observations = null;
	    }
	    
	    /**
	     * Method to clean the tool tips
	     */
	    private function cleanDataTips():void 
	    {
	    	if (null != _dataTipBox) {
	    		if (_dataTipBox.contains(_dataTipText)) {
	    			_dataTipBox.removeChild(_dataTipText);
	    		}
	    		_boxText = null;
	    		_dataTipText = null;
		    	_dataTipBox.graphics.clear();
		    	if (_chart.contains(_dataTipBox)) {
	            	_chart.removeChild(_dataTipBox);
				}
				if (_chart.contains(_innerCircle)) {
	            	_chart.removeChild(_innerCircle);
				}
				if (_chart.contains(_outerCircle)) {
	            	_chart.removeChild(_outerCircle);
				}
				if (_chart.contains(_axisCircle)) {
	            	_chart.removeChild(_axisCircle);
				}
				_innerCircle.graphics.clear();
				_outerCircle.graphics.clear();
				_axisCircle.graphics.clear();
				_dataTipBox = null;
				_innerCircle = null;
				_outerCircle = null;
				_axisCircle = null;
				_isFirst = true;
		    }
        }
        
		private function setMouseDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
			event = null;
			_cursorId = CursorManager.setCursor(_dragCursor);
			_mouseXRef = this.mouseX;
			_isDragging = true;
			if (_showECBToolTip) {
				cleanDataTips();
			}
		}
        
        private function moveOverChart(event:MouseEvent):void 
        {
			if (_isDragging) {
				var mouseDiv:Number = this.mouseX - _mouseXRef;
				var remainder:Number = Math.round(mouseDiv / (_chart.width / 
					(_filteredDataSet.timeseriesKeys.getItemAt(0) 
						as TimeseriesKey).timePeriods.length));
				if (remainder != 0) {		
					dispatchEvent(new DataEvent(ECBChartEvents.CHART_DRAGGED, 
						false, false, String(remainder)));		
				}		
				_mouseXRef = this.mouseX;
			} else if (event.currentTarget == _chart && _showECBToolTip) {
				displayObsData(event);
			}
			/*event.stopImmediatePropagation();
			event = null;*/
		}
		
		/**
		 * This method is called at the end of the dragging operation or when
		 * the cursor goes out of the chart area. It will either remove the hand 
		 * cursor or the tool tip, if any.
		 */
		private function cleanItemsOnChart(event:MouseEvent):void 
		{
			if (_isDragging) {
				CursorManager.removeAllCursors();
				_isDragging = false;
			} else if (event.currentTarget == _chart && _showECBToolTip) {
				cleanDataTips();
			}
			event.stopImmediatePropagation();
			event = null;
		}
		
		private function createLineSeries(availableLineSeries:int, 
			allLineSeries:Array):void
		{
			if (null == _effect && _showEffect) {
				_effect = new SeriesInterpolate();
				_effect.duration = 800;
				_effect.minimumElementDuration = 1;
				_effect.easingFunction = Quadratic.easeOut;
				_effect.elementOffset = 1;
			}
			for (var i:int = availableLineSeries; i < 0; i++) {
				var lineSeries:LineSeries = new LineSeries();
				lineSeries.yField = "observationValue";
				lineSeries.xField = "timeValue";
				lineSeries.filterData = true;
				if (_showEffect) {
					lineSeries.setStyle("showDataEffect", _effect);
				}
				allLineSeries.push(lineSeries);
			}
		}
		
		
		private function deleteLineSeries(availableLineSeries:int, 
			allLineSeries:Array):void
		{
			while (availableLineSeries > 0) {
				allLineSeries.pop();	
				availableLineSeries--;
			}
		}
		
		private function findObservations(period:String):Array
		{
			var observations:Array = new Array();	
			if (null != _filteredDataSet && null != 
				_filteredDataSet.timeseriesKeys) {
				var cursor:IViewCursor;
				for each (var series:TimeseriesKey in 
					_filteredDataSet.timeseriesKeys) {
					cursor = series.timePeriods.createCursor();			 	
					if (cursor.findFirst({periodComparator: period})) {
					 	observations.push(cursor.current);		
					}
					series = null;
				}
				cursor = null;
        	}
        	return observations;
		}
		
		private function handleItemClicked(event:ChartItemEvent):void
		{
			dispatchEvent(event);
		}
	}
}