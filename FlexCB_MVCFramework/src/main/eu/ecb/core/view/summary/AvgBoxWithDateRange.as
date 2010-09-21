// Copyright (C) 2010 European Central Bank. All rights reserved.
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
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.util.math.MathHelper;
	import eu.ecb.core.view.BaseSDMXView;
	
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.Text;
	
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	
	/**
	 * This component displays a box containing the average value over a 
	 * specific date range.
	 * 
	 * @author Xavier Sosnovsky
	 */
	[ResourceBundle("flex_cb_mvc_lang")]
	public class AvgBoxWithDateRange extends BaseSDMXView
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */ 
		protected var _numberFormatter:ExtendedNumberFormatter;
		
		/**
		 * @private
		 */
		protected var _minMaxText:Text;
		
		private var _dateFormatter:SDMXDateFormatter;
		private var _autoHide:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function AvgBoxWithDateRange(direction:String = "vertical")
		{
			super(direction);
			_dateFormatter = new SDMXDateFormatter();
			_numberFormatter = new ExtendedNumberFormatter();
			_numberFormatter.forceSigned = true;
			_numberFormatter.thousandsSeparatorTo = 
				resourceManager.getString("flex_cb_mvc_lang", 
				"thousands_separator");
			_numberFormatter.decimalSeparatorTo = 
				resourceManager.getString("flex_cb_mvc_lang", 
				"decimal_separator");	
			styleName = "textBox";
			_isPercentage = false;
			percentWidth = 100;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Whether the component should automatically hide itself when the 
		 * dataset contains more than one series.
		 * 
		 * @param flag 
		 */
		public function set autoHide(flag:Boolean):void
		{
			_autoHide = flag;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void 
		{
			super.createChildren();

			if (null == _minMaxText) {
				_minMaxText = new Text();
				_minMaxText.percentWidth  = 100;
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
				_numberFormatter.precision = 
					obs1.observationValue.indexOf(".") > -1 ? 
			    		obs1.observationValue.substring(
		    				obs1.observationValue.indexOf(".") + 1, 
		    				obs1.observationValue.length).length : 0;				
           		
		    	var total:Number = 0;
		    	for each (var currentObs:TimePeriod in 
		    		_filteredReferenceSeries.timePeriods) {
		    		total = total + Number(currentObs.observationValue);
		    	}
		    	_minMaxText.htmlText =  
	    		resourceManager.getString("flex_cb_mvc_lang", 
	    		"ChartSummaryBox_average") + " (" + _dateFormatter.format(
	    		obs1.timeValue) + " - " + _dateFormatter.format(
	    		obs2.timeValue) + "): " + "<font color='#000000'>" + 
	    		_numberFormatter.format(
	    			total / _filteredReferenceSeries.timePeriods.length);
		    	if (_isPercentage) {
		    		_minMaxText.htmlText = _minMaxText.htmlText + 
		    			resourceManager.getString("flex_cb_mvc_lang", 
							"percentage_sign");
		    	}		
		    	_minMaxText.htmlText = _minMaxText.htmlText + "</font>";	
			}
			
			if (_filteredDataSetChanged) {
				_filteredDataSetChanged = false;
				invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, 
			unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_autoHide && null != _filteredDataSet && null != 
				_filteredDataSet.timeseriesKeys && 
				1 < _filteredDataSet.timeseriesKeys.length) {
				this.width  = 0;
				this.height = 0;
				this.visible = false;
			} else if (_autoHide && null != _filteredDataSet && null != 
				_filteredDataSet.timeseriesKeys && 
				1 == _filteredDataSet.timeseriesKeys.length) {
				this.percentWidth  = 100;
				this.height = _minMaxText.height;
				this.visible = true;
			}		
		}		
	}
}