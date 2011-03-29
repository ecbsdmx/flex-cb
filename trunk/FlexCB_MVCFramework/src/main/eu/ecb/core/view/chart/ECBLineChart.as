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
	import eu.ecb.core.util.formatter.series.AttributesSeriesTitleFormatter;
	import eu.ecb.core.util.formatter.series.ISeriesTitleFormatter;
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
	import mx.charts.chartClasses.IAxis;
	import mx.charts.chartClasses.NumericAxis;
	import mx.charts.effects.SeriesInterpolate;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.LineSeries;
	import mx.collections.IViewCursor;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.effects.easing.Quadratic;
	import mx.formatters.DateFormatter;
	import mx.graphics.Stroke;
	import mx.managers.CursorManager;
	
	import org.sdmx.model.v2.base.type.AttachmentLevel;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimePeriodsCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

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
	[ResourceBundle("flex_cb_mvc_lang")] 
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
      	protected var _dateFormatter:SDMXDateFormatter;
      	
      	protected var _isoDateFormatter:DateFormatter;
      	
      	protected var _percentFormatter:ExtendedNumberFormatter;
      	
      	protected var _numberFormatter:ExtendedNumberFormatter;
      	
      	protected var _observationValueFormatter:IObservationFormatter;
      	
      	private var _isDragging:Boolean;
      	
      	private var _mouseXRef:Number;
      	
      	private var _dragFilteredStartDate:Date;
      	
      	private var _dragFilteredEndDate:Date;
      	
      	/**
		 * The id of the cursor used when dragging the chart
		 */
		private var _cursorId:Number;
		
		/**
		 * The icon for the cursor used when dragging the chart
		 */
		[Embed(source="/assets/images/fleur.png")] 
		private var _dragCursor:Class;
		
		private var _effect:SeriesInterpolate;
		
		protected var _showECBToolTip:Boolean;
		
		/**
		 * @private
		 */ 
		protected var _showSeriesTitle:Boolean;
		
		private var _baseAtZero:Boolean;
		private var _indexColor:Array;
		private var _effects:Object = new Object();
		private var _minimized:Object = new Object();
		private var _formatter:ISeriesTitleFormatter;
		private var _lineSeriesData:Object;
		private var _lineSeriesIndex:uint;
		private var _colorBySeriesKeys:Boolean;
		
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
			_dateFormatter = new SDMXDateFormatter();
			_isoDateFormatter = new DateFormatter();
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.forceSigned = true;
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			_percentFormatter.decimalSeparatorTo = 
				resourceManager.getString("flex_cb_mvc_lang", 
				"decimal_separator");
			_numberFormatter = new ExtendedNumberFormatter();
			_numberFormatter.forceSigned = true;
			_numberFormatter.thousandsSeparatorTo = 
				resourceManager.getString("flex_cb_mvc_lang", 
				"thousands_separator");
			_numberFormatter.decimalSeparatorTo = 
				resourceManager.getString("flex_cb_mvc_lang", 
				"decimal_separator");	
			_dateAxisFormatter = new SDMXDateFormatter();
			_dateAxisFormatter.isShortFormat = true;
			_referenceSeriesFrequency = "M";
			_isFirst = true;
			_showECBToolTip = true;
			_baseAtZero = true;
			_formatter = new AttributesSeriesTitleFormatter();
			(_formatter as AttributesSeriesTitleFormatter).attribute = 
				"TITLE_COMPL";
			(_formatter as AttributesSeriesTitleFormatter).attachmentLevel = 
				AttachmentLevel.GROUP;
			_lineSeriesData = new Object(); 	
			_lineSeriesIndex = 0;
		}
		
		/*========================Protected methods===========================*/
		
		override protected function resourcesChanged():void {
			if (!initialized) return;
			super.resourcesChanged();
			_filteredDataSetChanged = true;//force update
			invalidateProperties();	
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
			if (!flag && null != _chart) {
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
		
		/**
		 * The AS3 line chart used by this class 
		 */
		public function get chart():LineChart {
			return _chart;
		}
		
		public function set titleFormatter(formatter:ISeriesTitleFormatter):void
		{
			if (null != formatter) {
				_formatter = formatter;
			}
		}
		
		public function set colorBySeriesKeys(flag:Boolean):void 
		{
			_colorBySeriesKeys = flag; 
		}
		
		/*==========================Public methods============================*/
		
		public function handleMovieStarted(event:Event):void
		{
			_maxValueChanged = true;
			invalidateProperties();	
		}
		
		public function handleMovieStopped(event:Event):void
		{
			if (null != _chart) { 
				(_chart.verticalAxis as LinearAxis).maximum = NaN; 	
			}
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
				
				if (_showECBToolTip) {
					_chart.showDataTips = false;
				} else {
					_chart.showDataTips = true;
					_chart.dataTipMode  = "multiple";
					_chart.dataTipFunction = customizeDataTip;
				} 
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
				
				//Configure the tool tips					
				if (!_showECBToolTip) {
					_chart.showDataTips = true;
					_chart.dataTipMode  = "multiple";
					_chart.dataTipFunction = customizeDataTip;
				}	
				
				//Removes the shadow of the lines
				_chart.seriesFilters = new Array();
				
				var verticalAxis:LinearAxis = new LinearAxis();
				verticalAxis.baseAtZero = false;
				verticalAxis.labelFunction = formatVerticalAxisLabels;
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
		            	_dateFormatter.frequency = "A";
	        	    } else if (_dataLength <= 50) {
	        	    	_dateAxisFormatter.frequency = "D";
	        	    	_dateFormatter.frequency = "D";
		            } else {
	    	            _dateAxisFormatter.frequency = "M";
	    	            _dateFormatter.frequency = "M";
	        	    }
	            } else if (_referenceSeriesFrequency == "M") {
	            	if (_dataLength < 130) {
		            	_dateAxisFormatter.frequency = "M";
		            	_dateFormatter.frequency = "M";
	        	    } else {
	    	            _dateAxisFormatter.frequency = "A";
	    	            _dateFormatter.frequency = "A";
	        	    }
	            } else if (_referenceSeriesFrequency == "Q") {
	            	if (_dataLength < 60) {
		            	_dateAxisFormatter.frequency = "Q";
		            	_dateFormatter.frequency = "Q";
	        	    } else {
	    	            _dateAxisFormatter.frequency = "A";
	    	            _dateFormatter.frequency = "A";
	        	    }
	            } else if (_referenceSeriesFrequency == "A") {
	            	_dateAxisFormatter.frequency = "A";
	            	_dateFormatter.frequency = "A";
	            } else if (_referenceSeriesFrequency == "H") {	            	
    	            _dateAxisFormatter.frequency = "H";
    	            _dateFormatter.frequency = "H";
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
					var curSeries:TimeseriesKey = 
						_filteredDataSet.timeseriesKeys.getItemAt(i) 
						as TimeseriesKey;	
					var periods:TimePeriodsCollection = curSeries.timePeriods; 	
					
					if (allLineSeries[i].dataProvider != periods) {
						allLineSeries[i].dataProvider = periods;
						_lineSeriesData[(allLineSeries[i] as LineSeries).id] = 
							curSeries;
						isChanged = true;
						isSeriesChanged = true;
					} 
					
					if (isSeriesChanged) {	
						var axisStroke:Stroke = new Stroke();
						if (_indexColor != null) {
							axisStroke.color = 
								(SeriesColors.getColors().length > i) ?
								SeriesColors.getColors().getItemAt(
								_indexColor[i])	as uint : Math.round(
								Math.random()*0xFFFFFF);
						} else {
							if (_colorBySeriesKeys) {
								axisStroke.color = SeriesColors.
									getColorForSeriesKey(curSeries.seriesKey);
							} else {
								axisStroke.color = 
									(SeriesColors.getColors().length > i) ?
									SeriesColors.getColors().getItemAt(i) 
										as uint :
										Math.round( Math.random()*0xFFFFFF );
							}
						}
						if (null != _selectedDataSet &&	(_selectedDataSet as
							DataSet).timeseriesKeys.contains(curSeries)) 
						{
							axisStroke.weight = 2;	
						} else { 
							axisStroke.weight = 1;
						}
						(allLineSeries[i] as LineSeries).setStyle("lineStroke", 
							axisStroke);
					
						if (_showSeriesTitle) {
							if (_formatter is AttributesSeriesTitleFormatter && 
								(_formatter as AttributesSeriesTitleFormatter).
								attachmentLevel == AttachmentLevel.GROUP) {
								(_formatter as AttributesSeriesTitleFormatter).
									titleSupplier = _filteredDataSet.groupKeys.
									getGroupsForTimeseries(curSeries).
									getItemAt(0) as GroupKey;
							}	
							allLineSeries[i].displayName = 
								_formatter.getSeriesTitle(curSeries);	
						}
					}
				}
				if (isChanged) {
					_chart.series = allLineSeries;
				}
				setAxisTicksAndLabels();
			}

			if (_selectedDataSetChanged) {
				_selectedDataSetChanged = false;
				_highlightedDataSet = null;
				drawLineSeries();
			}
			
			if (_highlightedDataSetChanged) {
				_highlightedDataSetChanged = false;
				drawLineSeries();
			}
			
			if (_referenceSeriesFrequencyChanged) {
				_referenceSeriesFrequencyChanged = false;
				if (_referenceSeriesFrequency == "M" || 
					_referenceSeriesFrequency == "Q") {
		    		_isoDateFormatter.formatString = "YYYY-MM";
		    		_dateFormatter.formatString = resourceManager.getString(
		    			"flex_cb_mvc_lang", "monthly_date_format_long");
		    	} else if (_referenceSeriesFrequency == "B" || 
		    		_referenceSeriesFrequency == "D") {
		    		_isoDateFormatter.formatString = "YYYY-MM-DD";
		    		_dateFormatter.formatString = "D MMMM YYYY";
		    	} else if (_referenceSeriesFrequency == "A") {
			    	_isoDateFormatter.formatString = "YYYY";
			    	_dateFormatter.formatString = "YYYY";
		    	} else if (_referenceSeriesFrequency == "H") {
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
			
			if (_maxValueChanged) {
				_maxValueChanged = false;
				(_chart.horizontalAxis as DateTimeAxis).maximum =
					new Date((_chart.horizontalAxis as DateTimeAxis).
						computedMaximum);
				(_chart.verticalAxis as LinearAxis).maximum = 
					(_chart.verticalAxis as LinearAxis).computedMaximum;	 
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
				var ts:TimeseriesKey = _lineSeriesData[(data.element as 
					LineSeries).id] as TimeseriesKey;
				observationValueFormatter.series = ts;
				if ((_filteredDataSet.groupKeys.getGroupsForTimeseries(ts)
					as GroupKeysCollection).length > 0) {
					observationValueFormatter.group = 
						(_filteredDataSet.groupKeys.getGroupsForTimeseries(ts)
						as GroupKeysCollection).getItemAt(0) as GroupKey;
				}
				dataTip = dataTip + observationValueFormatter.format(
						obs.observationValue);		
			} else {
				_numberFormatter.precision = 
					obs.observationValue.indexOf(".") > -1 ? 
			    		obs.observationValue.substring(
		    				obs.observationValue.indexOf(".") + 1, 
		    				obs.observationValue.length).length : 0;	
		    	_numberFormatter.forceSigned = false;			
				dataTip = dataTip + _numberFormatter.format(Number(
					obs.observationValue));
				_numberFormatter.forceSigned = true;	
			}
			if (_isPercentage) {
				dataTip = dataTip + 
					resourceManager.getString("flex_cb_mvc_lang", 
					"percentage_sign");
			}
			dataTip = dataTip + "</font>";
			return dataTip;		
		}
		
		protected function setMouseDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
			event = null;
			_cursorId = CursorManager.setCursor(_dragCursor);
			_mouseXRef = this.mouseX;
			_isDragging = true;
			_dragFilteredStartDate = new Date((_filteredReferenceSeries.
				timePeriods.getItemAt(0) as TimePeriod).timeValue);
			_dragFilteredEndDate = new Date((_filteredReferenceSeries.
				timePeriods.getItemAt(_filteredReferenceSeries.timePeriods.
				length-1) as TimePeriod).timeValue);
			if (_showECBToolTip) {
				cleanDataTips();
			}
		}
		
		/**
         * This method formats the labels for the data chart, depending on the
         * frequency and the length of the longest series.
         */
        protected function formatDateAxisLabels(labelValue:Object, 
            previousLabelValue:Object, axis:DateTimeAxis):String 
		{
            return _dateAxisFormatter.format(labelValue as Date);
        }
        
        /**
         * This method formats the labels for the data chart, depending on the
         * frequency and the length of the longest series.
         */
        protected function formatVerticalAxisLabels(labelValue:Object, 
        	previousValue:Object, axis:IAxis):String {
        	_numberFormatter.forceSigned = false;
        	var value:String = _numberFormatter.format(labelValue) + 
        		(_isPercentage ? "%" : ""); 	
        	_numberFormatter.forceSigned = true;
        	return value;
        }
        
        /*=========================Private methods============================*/

        
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
        	} else if (_referenceSeriesFrequency == "H") {
        		(_chart.horizontalAxis as DateTimeAxis).dataUnits = "months";
        		(_chart.horizontalAxis as DateTimeAxis).dataInterval = 6;
        		(_chart.horizontalAxis as DateTimeAxis).labelUnits = "months";
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
						if ((_filteredDataSet.groupKeys.getGroupsForTimeseries(
							selectedSeries) as GroupKeysCollection).length > 0 ) {
								observationValueFormatter.group = 
									(_filteredDataSet.groupKeys.getGroupsForTimeseries(
										selectedSeries) as GroupKeysCollection).
										getItemAt(0) as GroupKey;
						}
						_boxText = _boxText + observationValueFormatter.format(
							lastObs.observationValue);		
					} else {
						_numberFormatter.precision = 
							lastObs.observationValue.indexOf(".") > -1 ? 
			    				lastObs.observationValue.substring(
		    					lastObs.observationValue.indexOf(".") + 1, 
		    					lastObs.observationValue.length).length : 0;
		    			_numberFormatter.forceSigned = false;			
						_boxText = _boxText + _numberFormatter.format(
							Number(lastObs.observationValue));
						_numberFormatter.forceSigned = true;	
					}
					if (_isPercentage) {
						_boxText = _boxText + resourceManager.getString(
							"flex_cb_mvc_lang", "percentage_sign");
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
	             			_boxText = _boxText + resourceManager.getString(
	             				"flex_cb_mvc_lang", "percentage_sign");
	             		} else {
	             			_boxText = _boxText + " (" + 
	             				_percentFormatter.format(
	             				MathHelper.calculatePercentOfChange(
	             					Number(previousObs.observationValue), 
	             					Number(lastObs.observationValue))) 
		             			+ resourceManager.getString("flex_cb_mvc_lang", 
								"percentage_sign") + ")";	
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
        
        protected function moveOverChart(event:MouseEvent):void 
        {
			if (_isDragging) {
					
				 var delta:Number = (this.mouseX - _mouseXRef)/_chart.width;
				
				 var fullFirstMillis:Number=(_referenceSeries.timePeriods.getItemAt(0) as TimePeriod).timeValue.time;
				 var fullLastMillis:Number=(_referenceSeries.timePeriods.getItemAt(_referenceSeries.timePeriods.length-1) as TimePeriod).timeValue.time;
				 var fullPeriodMillis:Number = fullLastMillis - fullFirstMillis;
			 
			 	 var filteredPeriodMillis:Number = _dragFilteredEndDate.time - _dragFilteredStartDate.time;
			 
				 var currentPercentage:Number = filteredPeriodMillis/fullPeriodMillis;
				 var finalPercentage:Number=-delta*currentPercentage+((_dragFilteredEndDate.time-fullFirstMillis)/fullPeriodMillis) ;
				 dispatchEvent(new DataEvent(ECBChartEvents.CHART_DRAGGED,false, false, String(finalPercentage*100)));
			} else if (event.currentTarget == _chart && _showECBToolTip) {
				displayObsData(event);
			}
			event.stopImmediatePropagation();
			event = null;
		}
		
		/**
		 * This method is called at the end of the dragging operation or when
		 * the cursor goes out of the chart area. It will either remove the hand 
		 * cursor or the tool tip, if any.
		 */
		protected function cleanItemsOnChart(event:MouseEvent):void 
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
				lineSeries.id = "lineSeriesChart"+_lineSeriesIndex;
				lineSeries.yField = "observationValue";
				lineSeries.xField = "timeValue";
				lineSeries.filterData = true;
				if (_showEffect) {
					lineSeries.setStyle("showDataEffect", _effect);
				}
				allLineSeries.push(lineSeries);
				_lineSeriesIndex++;
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
		
		protected function handleItemClicked(event:ChartItemEvent):void
		{
			dispatchEvent(event);
		}
		
		private function drawLineSeries():void
		{
			var allLineSeries:Array = _chart.series;				
			for (var i:uint = 0; i < _filteredDataSet.timeseriesKeys.length; 
				i++) {
				var series:TimeseriesKey = _filteredDataSet.timeseriesKeys.
					getItemAt(i) as	TimeseriesKey; 
				if (
					//Series belong to the list of selected series
					(null != _selectedDataSet && null != (_selectedDataSet as 
					DataSet).timeseriesKeys.getTimeseriesKey(series.seriesKey))
					||
					//Series belong to the list of highlighted series
					(null != _highlightedDataSet && null != 
					(_highlightedDataSet as DataSet).timeseriesKeys.
					getTimeseriesKey(series.seriesKey)) 
					|| 
					//There are no series being selected or highlighted
					((null == 
					_selectedDataSet || (null != _selectedDataSet && 0 == 
					(_selectedDataSet as DataSet).timeseriesKeys.length)) &&
					(null == _highlightedDataSet || (null != _highlightedDataSet 
					&& 0 == (_highlightedDataSet as DataSet).timeseriesKeys.
					length)))) {
					//If the conditions above hold true and the series is 
					//currently dimmed, put the right color back	
					if (_minimized.hasOwnProperty(series.seriesKey) && 
						_minimized[series.seriesKey] == true) {	
						playEffect(allLineSeries[i] as LineSeries, true);
						_minimized[series.seriesKey] = false;
					}
				} else if (!(_minimized.hasOwnProperty(series.seriesKey)) || 
					_minimized[series.seriesKey] == false) {
						playEffect(allLineSeries[i] as LineSeries, false);
						_minimized[series.seriesKey] = true;
				}
			}
		}
		
		private function createEffect():Effect {
	    	var z:Fade = new Fade();
	    	z.alphaFrom = 1;
	    	z.alphaTo   = 0.3; 
	    	z.duration  = 600;
	    	return z;
	    } 
    
	    private function playEffect(target:LineSeries, reverse:Boolean):void {      
	    	var effect:Effect = _effects[target];
	    	if (effect == null) {
	        	effect = createEffect();         
	        	_effects[target] = effect;
	      	}
	      	if (effect.isPlaying) {
		        effect.reverse();
		    } else {
	    	    effect.play([target], reverse);
			}
	    }
	}
}