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
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.view.BaseSDMXViewComposite;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexlib.controls.HSlider;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.NumericStepper;
	import mx.controls.Spacer;
	import mx.events.SliderEvent;
	
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;

	/**
	 * Event triggered when the selected start date has changed
	 * 
	 * @eventType eu.ecb.core.view.filter.RangeSelectorBox.START_DATE_CHANGED
	 */
	[Event(name="startDateChanged", type="flash.events.DataEvent")]
	
	/**
	 * Event triggered when the selected end date has changed
	 * 
	 * @eventType eu.ecb.core.view.filter.RangeSelectorBox.END_DATE_CHANGED
	 */ 
	[Event(name="endDateChanged", type="flash.events.DataEvent")]
	
	/**
	 * Event triggered when the currently selected date (for example, when the
	 * movie is playing) has been changed
	 * 
	 * @eventType eu.ecb.core.view.filter.RangeSelectorBox.SELECTED_DATE_CHANGED
	 */ 
	[Event(name="selectedDateChanged", type="flash.events.DataEvent")]
	
	/**
	 * Event triggered when the movie over the selected period starts
	 * playing
	 * 
	 * @eventType eu.ecb.core.view.filter.RangeSelectorBox.MOVIE_STARTED
	 */
	[Event(name="movieStarted", type="flash.events.Event")]
	
	/**
	 * Event triggered when the movie over the selected period has stopped 
	 * playing 
	 * 
	 * @eventType eu.ecb.core.view.filter.RangeSelectorBox.MOVIE_STOPPED
	 */
	[Event(name="movieStopped", type="flash.events.Event")]
	
	/**
	 * This component displays a slider in the form time line, that allows
	 * setting the precise start and end dates of a data collection.
	 * 
	 * The component also allows playing a "movie" over the data collection by
	 * changing the selected date every 3 seconds. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class RangeSelectorBox extends BaseSDMXViewComposite
	{
		/*=============================Constants==============================*/
		
		/**
		 * The RangeSelectorBox.START_DATE_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>startDateChanged</code> event.
		 * 
		 * @eventType startDateChanged
		 */  
		public static const START_DATE_CHANGED:String = "startDateChanged";
			
		/**
		 * The RangeSelectorBox.END_DATE_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>endDateChanged</code> event.
		 * 
		 * @eventType endDateChanged
		 */  
		public static const END_DATE_CHANGED:String = "endDateChanged";
			
		/**
		 * The RangeSelectorBox.SELECTED_DATE_CHANGED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>selectedDateChanged</code> event.
		 * 
		 * @eventType selectedDateChanged
		 */  
		public static const SELECTED_DATE_CHANGED:String = "selectedDateChanged"
			
		/**
		 * The RangeSelectorBox.MOVIE_STARTED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>movieStarted</code> event.
		 * 
		 * @eventType movieStarted
		 */  
		public static const MOVIE_STARTED:String = "movieStarted";
			
		/**
		 * The RangeSelectorBox.MOVIE_STOPPED constant defines the value 
		 * of the <code>type</code> property of the event object for a 
		 * <code>movieStopped</code> event.
		 * 
		 * @eventType movieStopped
		 */  
		public static const MOVIE_STOPPED:String = "movieStopped";
			
		/*==============================Fields================================*/
		
		private var _label:Label;
		
		private var _slider:HSlider;
		
		private var _button:LinkButton;
		
		private var _stopButton:LinkButton;
		
		private var _speedSelector:NumericStepper;
		
		private var _row1:HBox;
		
		private var _dateFormatter:SDMXDateFormatter;
		
		private var _initialStartValue:uint;
		
		private var _initialEndValue:uint;
		
		[Embed(source="eu/ecb/assets/images/icon_play.png")]
		private var _playIcon:Class;
		
		[Embed(source="eu/ecb/assets/images/icon_stop.png")]
		private var _stopIcon:Class;
		
		[Embed(source="eu/ecb/assets/images/icon_pause.png")]
		private var _pauseIcon:Class;
		
		private var _timer:Timer;
		
		private var _wasPaused:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function RangeSelectorBox(direction:String = "vertical")
		{
			super(direction);
			styleName = "textBox";
			setStyle("verticalAlign", "top");
			_dateFormatter = new SDMXDateFormatter();
			_dateFormatter.isShortFormat = true;
			_dateFormatter.frequency = "M";
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * inheritDoc
		 */ 
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _row1) {
				_row1 = new HBox();
				_row1.percentWidth = 100;
				_row1.setStyle("horizontalGap", 0);
				_row1.setStyle("horizontalAlign", "center");
				addChild(_row1);
			}
			
			if (null == _label) {
				_label = new Label();
				_label.width = 80;
				_label.text = "Date range:";
				_label.setStyle("paddingRight", 0);
				_row1.addChild(_label);
			}
			
			if (null == _slider) {
				_slider = new HSlider();
				_slider.thumbCount = 2;
				_slider.snapInterval = 1;
				_slider.minimum = 0;
				_slider.liveDragging = true;
				_slider.setStyle("trackSkin", ECBSliderTrackSkin);
				_slider.setStyle("trackHighlightSkin", ECBSliderHighlightSkin);
				_slider.setStyle("dataTipStyleName", "dataTip");
				_slider.setStyle("labelOffset", 0);
				_slider.dataTipFormatFunction = formatDataTip;
				_slider.addEventListener(SliderEvent.CHANGE, 
					handleSliderChanged);
				_row1.addChild(_slider);
			}
			
			if (null == _button) {
				_button = new LinkButton();
				_button.id = "b1";
				_button.labelPlacement = "right";
				_button.styleName = "movieButton";
				_button.toolTip = "Play the animation";
				_button.setStyle("paddingTop", 5);
				_button.setStyle("icon", _playIcon);
				_button.setStyle("rollOverColor", 0xFFFFFF);
				_button.setStyle("selectionColor", 0xFFFFFF);
				_button.setStyle("textRollOverColor", 0xFFFFFF);
				_button.setStyle("textSelectedColor", 0xFFFFFF);
				_button.addEventListener(MouseEvent.CLICK, handleButtonClicked);
				_row1.addChild(_button);
			}		
			
			if (null == _stopButton) {
				_stopButton = new LinkButton();
				_stopButton.toolTip = "Stop the animation";
				_stopButton.labelPlacement = "right";
				_stopButton.styleName = "movieButton";
				_stopButton.setStyle("paddingTop", 5);
				_stopButton.setStyle("rollOverColor", 0xFFFFFF);
				_stopButton.setStyle("selectionColor", 0xFFFFFF);
				_stopButton.setStyle("textRollOverColor", 0xFFFFFF);
				_stopButton.setStyle("textSelectedColor", 0xFFFFFF);
				_stopButton.setStyle("icon", _stopIcon);
				_stopButton.visible = false;
				_stopButton.enabled = false;
				_stopButton.addEventListener(MouseEvent.CLICK, 
					handleStopButtonClicked);
				_row1.addChild(_stopButton);
			}	
			
			if (null == _speedSelector) {
				var spacer:Spacer = new Spacer();
				spacer.width = 10;
				_row1.addChild(spacer);
				_speedSelector = new NumericStepper();
				_speedSelector.minimum = 0.1;
				_speedSelector.maximum = 5;
				_speedSelector.stepSize = 0.1;
				_speedSelector.value = 1.5;
				_speedSelector.visible = false;
				_speedSelector.toolTip = "Set the animation speed (in seconds)";
				_speedSelector.addEventListener(MouseEvent.MOUSE_UP,
					handleSpeedChanged);
				_speedSelector.width = 50;
				_row1.addChild(_speedSelector);
			}
		}
		
		/**
		 * inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				_slider.maximum = _referenceSeries.timePeriods.length - 1;
				var count:uint = 0;
				var j:uint = 0;
				var years:ArrayCollection = new ArrayCollection();
				var ticks:Array = new Array();
				for each (var period:TimePeriod in _referenceSeries.timePeriods) 
				{
					var year:Number = period.timeValue.fullYear;
					if (!(years.contains(year))) {
						years.addItem(year);
						ticks.push(count);
					}
					count++;
				}
				_slider.values  = [0, count];
				ticks.push(count--);
				if ((_referenceSeries.timePeriods.getItemAt(_referenceSeries.
					timePeriods.length - 1) as TimePeriod).timeValue.
					month < 8) {
					years.setItemAt("", years.length - 1);	
				}
				_slider.tickValues = ticks;
				_slider.labels = years.toArray();
				_slider.width = 4.5 * _referenceSeries.timePeriods.length;
			}
			
			super.commitProperties();
		}
		
		/*=========================Private methods============================*/
		
		private function formatDataTip(value:Number):String 
		{ 
        	return _dateFormatter.format((_referenceSeries.timePeriods.
        		getItemAt(value) as TimePeriod).timeValue);
      	}
      	
      	private function handleSliderChanged(event:SliderEvent):void
      	{
      		event.stopImmediatePropagation();
      		if (event.thumbIndex == 0) {
      			dispatchEvent(new DataEvent(START_DATE_CHANGED, false, false, 
					(_referenceSeries.timePeriods.getItemAt(event.value) as 
					TimePeriod).periodComparator));
      		} else if (event.thumbIndex == 1) {
      			dispatchEvent(new DataEvent(END_DATE_CHANGED, false, false, 
					(_referenceSeries.timePeriods.getItemAt(event.value) as 
					TimePeriod).periodComparator));
      		}
      		event = null;
      	}
      	
      	private function handleButtonClicked(event:MouseEvent):void
      	{
			if (_playIcon == _button.getStyle("icon")) {
				_button.toolTip = "Pause the animation";
				_button.setStyle("icon", _pauseIcon);
				_timer = new Timer(_speedSelector.value * 1000, 0);
				_timer.addEventListener(TimerEvent.TIMER, handleTimerTick);
				_timer.start();
				if (!_wasPaused) {
					_slider.thumbCount = 1;
					_slider.enabled = false;
					_slider.setStyle("showTrackHighlight", false);
					_initialStartValue = _slider.values[0];
					_initialEndValue   = _slider.values[1];
					_slider.values = [_initialStartValue, _initialEndValue];
					_stopButton.visible = true;
					_stopButton.enabled = true;
					_speedSelector.visible = true;
					dispatchEvent(new Event(MOVIE_STARTED));
				}
			} else {
				_timer.stop();
				_button.toolTip = "Play the animation";
				_button.setStyle("icon", _playIcon);
				_wasPaused = true;				
			}
      	}
      	
      	private function handleStopButtonClicked(event:MouseEvent):void
      	{
			_timer.stop();
			_button.toolTip = "Play the animation";
			_button.setStyle("icon", _playIcon);
			_slider.setStyle("showTrackHighlight", true);
			_slider.thumbCount = 2;
			_slider.enabled = true;
			_slider.values = [_initialStartValue, _initialEndValue];
			_stopButton.visible = false;
			_stopButton.enabled = false;
			_speedSelector.visible = false;
			_wasPaused = false;
			dispatchEvent(new Event(MOVIE_STOPPED));				
      	}
      	
      	private function handleTimerTick(event:TimerEvent):void
      	{
      		if (_slider.values[0] < _slider.values[1]) {
      			dispatchEvent(new DataEvent("selectedDateChanged", false, false, 
					(_referenceSeries.timePeriods.getItemAt(_slider.values[0]) 
					as TimePeriod).periodComparator));
      			_slider.values = [_slider.values[0] + 1, _slider.values[1]];
      		} else if (_slider.values[0] == _slider.values[1]) {
      			dispatchEvent(new DataEvent("selectedDateChanged", false, false, 
					(_referenceSeries.timePeriods.getItemAt(_slider.values[0]) 
					as TimePeriod).periodComparator));
      			_timer.stop();
      			_button.toolTip = "Play the animation";
				_button.setStyle("icon", _playIcon);
				_slider.setStyle("showTrackHighlight", true);
				_slider.thumbCount = 2;
				_slider.enabled = true;
				_stopButton.visible = false;
				_stopButton.enabled = false;
				_speedSelector.visible = false;
				_slider.values = [_initialStartValue, _initialEndValue];
				dispatchEvent(new Event(MOVIE_STOPPED));
      		}
      	}
      	
      	private function handleMouseDown(event:MouseEvent):void
      	{
      		_slider.handleMouseDown(event);
      	}
      	
      	private function handleSpeedChanged(event:MouseEvent):void
      	{
      		if (!_wasPaused) {
	      		_timer.stop();
	      		_timer = new Timer(_speedSelector.value * 1000, 0);
				_timer.addEventListener(TimerEvent.TIMER, handleTimerTick);
				_timer.start();
      		}
      	}
	}
}