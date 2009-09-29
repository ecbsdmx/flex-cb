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
	import mx.controls.Label;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.math.MathHelper;
	import mx.containers.HBox;
	import mx.controls.Text;
	import eu.ecb.core.view.SDMXViewAdapter;

	/**
	 * This component displays a box containing the last observation value and 
	 * date and the change with the previous observation.
	 * 
	 * More specific display of information can be achieved by subclassing this
	 * component and overriding one of the formatting methods.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class SeriesSummaryBox extends SDMXViewAdapter
	{
		/*==============================Fields================================*/
		
		/** The UI components used by this component. */
		private var _latestObservationField:Text;
		
		/** The formatters */
		private var _dateFormatter:SDMXDateFormatter;
		
		private var _percentFormatter:ExtendedNumberFormatter;
		
		private var _numberFormatter:ExtendedNumberFormatter;
		
		/*===========================Constructor==============================*/
		
		public function SeriesSummaryBox(direction:String = "horizontal")
		{
			super(direction);
			_dateFormatter = new SDMXDateFormatter();
			_numberFormatter = new ExtendedNumberFormatter();
			_numberFormatter.forceSigned = true;
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.forceSigned = true;
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			_showChange = true;
			percentWidth = 100;
			styleName = "changeWithPreviousBox";
		}
		
		/*========================Protected methods===========================*/
		
		override protected function resourcesChanged():void {
			if (!initialized) return;
			super.resourcesChanged();
			
			_referenceSeriesChanged = true;//force update
			this.commitProperties();
			
		
		}		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _latestObservationField) {
				_latestObservationField = new Text();
				_latestObservationField.percentWidth = 100;
				_latestObservationField.styleName = "titleText";
				addChild(_latestObservationField);
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
			
			if (_referenceSeriesChanged) {
				_referenceSeriesChanged = false;
				if (_referenceSeries.timePeriods.length > 0) {
				//Get the latest observation and display the 1st line
				var latestObservation:TimePeriod = 
					_referenceSeries.timePeriods.getItemAt(
						_referenceSeries.timePeriods.length - 1) as TimePeriod;
				_latestObservationField.htmlText = "<b>" + 
					formatLatestFieldTitle(latestObservation.timeValue) +
					"<font color='#000000' verticalAlign='bottom'>" + 
					formatLatestFieldValue(latestObservation);
				if (_isPercentage) {
					_latestObservationField.htmlText = 
						_latestObservationField.htmlText + "%";
				}	
				_latestObservationField.htmlText = 
					_latestObservationField.htmlText + "</font>";
					
				//Get the number of decimals and set the formatter's precision	
				_numberFormatter.precision = 
					latestObservation.observationValue.indexOf(".") > -1 ? 
			    		latestObservation.observationValue.substring(
			    			latestObservation.observationValue.indexOf(".") + 1, 
			    			latestObservation.observationValue.length).length : 0;
			    			
			    //Displays the second line if there are at least 2 observations 				
				if (_showChange && _referenceSeries.timePeriods.length > 1) {
					var previousObservation:TimePeriod = 
						_referenceSeries.timePeriods.getItemAt(
							_referenceSeries.timePeriods.length - 2) 
								as TimePeriod;	
					var color:String;			
	             	if (Number(latestObservation.observationValue) > 
	             		Number(previousObservation.observationValue)) {
	            		color = "#009933";
		            } else if (Number(latestObservation.observationValue) < 
		            	Number(previousObservation.observationValue)) {
	    	        	color = "#CC0000";
	        		} else {
		        		color = "#000000";
	        		}
	           		_latestObservationField.htmlText = 
	           			_latestObservationField.htmlText + "</b> <font color='" 
	           			+ color + "' size='10'>" + _numberFormatter.format(
	           				Number(latestObservation.observationValue) - 
	           				Number(previousObservation.observationValue));		
	           		if (!_isPercentage) {		
	             		_latestObservationField.htmlText = 
	           				_latestObservationField.htmlText + " (" + 
	             			_percentFormatter.format(
	             				MathHelper.calculatePercentOfChange(
	             				Number(previousObservation.observationValue), 
	             				Number(latestObservation.observationValue))) + 
			             		"%)";	
	            	} else {
	            		_latestObservationField.htmlText = 
		           			_latestObservationField.htmlText + "%";
	            	}
	            	_latestObservationField.htmlText = 
	           			_latestObservationField.htmlText + "</font>";
				}
				}
			}	
		}
		
		/**
		 * @private
		 */
		protected function formatLatestFieldTitle(period:Date):String 
		{
			return resourceManager.getString("flex_cb_mvc_lang", "SeriesSummaryBox_latest") + " (" + _dateFormatter.format(period) + "): ";	
		}
		
		/**
		 * @private
		 */
		protected function formatLatestFieldValue(observation:TimePeriod):String
		{
			return observation.observationValue;
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