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
package eu.ecb.core.view
{
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	
	import mx.formatters.DateBase; 
	
	/**
	 * Basic implementation of the ISDMXView interface.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class SDMXViewAdapter extends Box implements ISDMXView
	{
		
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _fullDataSet:DataSet;
		
		/**
		 * @private
		 */
		protected var _fullDataSetChanged:Boolean;
		
		/**
		 * @private
		 */ 	
		protected var _dataSet:DataSet;
		
		/**
		 * @private
		 */
		protected var _dataSetChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _referenceSeriesFrequency:String;
		
		/**
		 * @private
		 */
		protected var _referenceSeriesFrequencyChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _isPercentage:Boolean;
		
		/**
		 * @private
		 */
		protected var _isPercentageChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _filteredDataSet:DataSet;
		
		/**
		 * @private
		 */
		protected var _filteredDataSetChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _referenceSeries:TimeseriesKey;
		
		/**
		 * @private
		 */
		protected var _referenceSeriesChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _filteredReferenceSeries:TimeseriesKey;
		
		/**
		 * @private
		 */
		protected var _filteredReferenceSeriesChanged:Boolean;
		
		/**
		 * @private
		 */
		protected var _periods:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _periodsChanged:Boolean;
		
		/*===========================Constructor==============================*/
				
		public function SDMXViewAdapter(direction:String = "vertical") 
		{
			super();
			this.direction = direction;
		}
		
		/*========================Protected methods===========================*/
		
		override protected function resourcesChanged():void {
			if (!initialized) return;
			super.resourcesChanged();
			
			DateBase.dayNamesLong=resourceManager.getStringArray("flex_cb_mvc_lang", "dayNamesLong");
			DateBase.monthNamesLong=resourceManager.getStringArray("flex_cb_mvc_lang", "monthNamesLong");
			DateBase.monthNamesShort=resourceManager.getStringArray("flex_cb_mvc_lang", "monthNamesShort");
		
		}		
		
		/*============================Accessors===============================*/
		
		/**
		 * @inheritDoc
		 */ 
		public function set fullDataSet(dataSet:DataSet):void
		{
			if (null != dataSet &&  null != dataSet.timeseriesKeys && 
				dataSet.timeseriesKeys.length > 0) {
				_fullDataSet = dataSet;
				_fullDataSetChanged = true;		
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set dataSet(dataSet:DataSet):void
		{
			if (null != dataSet &&  null != dataSet.timeseriesKeys && 
				dataSet.timeseriesKeys.length > 0) {
				_dataSet = dataSet;
				_dataSetChanged = true;		
				invalidateProperties();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function set filteredDataSet(dataSet:DataSet):void
		{
			if (null != dataSet && null != dataSet.timeseriesKeys && 
				dataSet.timeseriesKeys.length > 0){
				_filteredDataSet = dataSet;
				_filteredDataSetChanged = true;
				invalidateProperties();
			} 
		}
		
		/**
		 * @inheritDoc
		 */
		public function set referenceSeries(series:TimeseriesKey):void
		{
			if (null != series) {
				_referenceSeries = series;
				_referenceSeriesChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set filteredReferenceSeries(series:TimeseriesKey):void
		{
			if (null != series) {
				_filteredReferenceSeries = series;
				_filteredReferenceSeriesChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set periods(periods:ArrayCollection):void
		{
			if (null != periods) {
				_periods = periods;
				_periodsChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set referenceSeriesFrequency(freq:String):void
		{
			if (null != freq) {
				_referenceSeriesFrequency = freq;
				_referenceSeriesFrequencyChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set isPercentage(isPercentage:Boolean):void
		{
			_isPercentage = isPercentage;
			_isPercentageChanged = true;
			invalidateProperties();
		}
	}
}