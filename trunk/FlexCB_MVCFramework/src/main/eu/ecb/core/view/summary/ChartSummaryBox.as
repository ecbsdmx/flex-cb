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
package eu.ecb.core.view.summary
{
	import mx.containers.VBox;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import mx.containers.HBox;
	import mx.controls.Label;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.math.MathHelper;
	import mx.controls.Text;
	import flash.events.Event;
	import eu.ecb.core.view.SDMXViewAdapter;
	
	/**
	 * This component displays a box containing:
	 * 1. On the first line, the change over the displayed period
	 * 2. On the second line, the minimum, maximum and average values
	 * 
	 * @author Xavier Sosnovsky
	 */
	[ResourceBundle("flex_cb_mvc_lang")]
	public class ChartSummaryBox extends SDMXViewAdapter
	{
		/*==============================Fields================================*/
		
		private var _dateFormatter:SDMXDateFormatter;
		
		private var _percentFormatter:ExtendedNumberFormatter;
		
		/**
		 * @private
		 */ 
		protected var _numberFormatter:ExtendedNumberFormatter;
		
		private var _changeBox:HBox;
		
		private var _changeText:Label;
		
		private var _changeValue:Label;
		
		/**
		 * @private
		 */
		protected var _minMaxText:Text;
		
		private var _showChange:Boolean;
		
		private var _showAverage:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function ChartSummaryBox(direction:String = "vertical")
		{
			super(direction);
			_dateFormatter = new SDMXDateFormatter();
			_numberFormatter = new ExtendedNumberFormatter();
			_numberFormatter.forceSigned = true;
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.forceSigned = true;
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			styleName = "textBox";
			_isPercentage = false;
			_showChange = true;
			_showAverage = true;
			percentWidth = 100;
		}
		
		/*========================Protected methods===========================*/
		
		override protected function resourcesChanged():void {
			if (!initialized) return;
			_filteredReferenceSeriesChanged = true; //force an update
			super.resourcesChanged();
			this.commitProperties();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether or not information about growth rates over time should be
		 * displayed in the panel.
		 *  
		 * @param showChange
		 */
		public function set showChange(flag:Boolean):void
		{
			_showChange = flag;
			if (null != _changeBox) {
				_changeBox.visible = _showChange;
				if (!_showChange) {
					_changeBox.height = 0;
				}
			}
		}
		
		/**
		 * Whether or not the average should be displayed.
		 *  
		 * @param showChange
		 */
		public function set showAverage(flag:Boolean):void
		{
			_showAverage = flag;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void 
		{
			super.createChildren();

			if (null == _changeBox) {
				_changeBox = new HBox();
				_changeBox.styleName = "changeWithPreviousBox";
				addChild(_changeBox);
			}
			
			if (null == _changeText) {
				_changeText = new Label();
				_changeBox.addChild(_changeText);
			}
			
			if (null == _changeValue) {
				_changeValue = new Label();
				_changeBox.addChild(_changeValue);
			}
			
			if (null == _minMaxText) {
				_minMaxText = new Text();
				_minMaxText.percentWidth  = 100;
				_minMaxText.percentHeight = 100;
				addChild(_minMaxText);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_referenceSeriesFrequencyChanged) {
				_dateFormatter.frequency = _referenceSeriesFrequency;
				_referenceSeriesFrequencyChanged = false;
			}
			
			if (_filteredReferenceSeriesChanged) {
				_filteredReferenceSeriesChanged = false;
				var obs1:TimePeriod = 
					_filteredReferenceSeries.timePeriods.getItemAt(0) 
						as TimePeriod;
				var obs2:TimePeriod = 	
					_filteredReferenceSeries.timePeriods.getItemAt(
					_filteredReferenceSeries.timePeriods.length - 1) 
						as TimePeriod;	
				//Get the number of decimals and set the formatter's precision	
				_numberFormatter.precision = 
					obs2.observationValue.indexOf(".") > -1 ? 
			    		obs2.observationValue.substring(
		    				obs2.observationValue.indexOf(".") + 1, 
		    				obs2.observationValue.length).length : 0;				
				if (_showChange) {	
					_changeText.text = resourceManager.getString("flex_cb_mvc_lang", "ChartSummaryBox_change_from") + " " + 
						_dateFormatter.format(obs1.timeValue) 
						+ " " +resourceManager.getString("flex_cb_mvc_lang", "ChartSummaryBox_to") + " " 
						+ _dateFormatter.format(obs2.timeValue) + " ";
			    	if (Number(obs2.observationValue) > 
	             		Number(obs1.observationValue)) {
	            		_changeValue.styleName = "greenColor";
		            } else if (Number(obs2.observationValue) < 
		            	Number(obs1.observationValue)) {
	    	        	_changeValue.styleName = "redColor";
	        		} else {
		        		_changeValue.styleName = "blackColor";
	        		}
	           		_changeValue.text =
	           			_numberFormatter.format(
	           				Number(obs2.observationValue) - 
	           				Number(obs1.observationValue));
	           		if (_isPercentage) {
		           		_changeValue.text = _changeValue.text + "%";
	           		} else {		
		           		_changeValue.text = _changeValue.text +		
		             		" (" + _percentFormatter.format(
		             			MathHelper.calculatePercentOfChange(
		             				Number(obs1.observationValue), 
		             				Number(obs2.observationValue))) + 
		             		"%)";
	           		}
	           		_changeBox.visible = true;
				} else {
					_changeBox.visible = false;
					_changeBox.height = 0;
				}
           		
		    	//Get min and max value;
		    	var minObs:TimePeriod = obs1;
		    	var maxObs:TimePeriod = obs1;
		    	var total:Number = 0;
		    	for each (var currentObs:TimePeriod in 
		    		_filteredReferenceSeries.timePeriods) {
		    		if (Number(currentObs.observationValue) <= 
		    			Number(minObs.observationValue)) {
		    			minObs = currentObs;
		    		} else if (Number(currentObs.observationValue) >= 
		    			Number(maxObs.observationValue)) {
		    			maxObs = currentObs;
		    		}
		    		total = total + Number(currentObs.observationValue);
		    	}
		    	_numberFormatter.forceSigned = false;
		    	_minMaxText.htmlText = resourceManager.getString("flex_cb_mvc_lang", "ChartSummaryBox_minimum") + " (" + 
		    		_dateFormatter.format(minObs.timeValue) + "): " + 
		    		"<font color='#000000'>" + 
		    		minObs.observationValue;
		    	if (_isPercentage) {
		    		_minMaxText.htmlText = _minMaxText.htmlText + "%"; 
		    	}	
		    	_minMaxText.htmlText = _minMaxText.htmlText +
		    		"</font> - "+resourceManager.getString("flex_cb_mvc_lang", "ChartSummaryBox_maximum") +" (" +
		    		_dateFormatter.format(maxObs.timeValue) + "): " + 
		    		"<font color='#000000'>" + 
		    		maxObs.observationValue;
		    	if (_isPercentage) {
		    		_minMaxText.htmlText = _minMaxText.htmlText + "%"; 
		    	}	
		    	if (_showAverage) { 
			    	calculateAverage(total);		
				}	
		    	_minMaxText.htmlText = _minMaxText.htmlText + "</font>";	
		    	_numberFormatter.forceSigned = true;	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected function calculateAverage(total:Number):void
		{
			_minMaxText.htmlText = _minMaxText.htmlText + "</font> - " + 
	    		resourceManager.getString("flex_cb_mvc_lang", "ChartSummaryBox_average") + ": " + "<font color='#000000'>" + 
	    		_numberFormatter.format(
	    			total / _filteredReferenceSeries.timePeriods.length);
	    	if (_isPercentage) {
	    		_minMaxText.htmlText = _minMaxText.htmlText + "%"; 
	    	}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			_minMaxText.width = _changeBox.width = width - 
				getStyle("paddingLeft") - getStyle("paddingRight");
		}
		
		/**
		 * @private
		 */ 
		internal function creationForTests():void {
			createChildren();
			commitProperties();
		}
	}
}