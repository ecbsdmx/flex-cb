// Copyright (C) 2009 European Central Bank. All rights reserved.
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
package eu.ecb.core.model
{
	import flash.events.DataEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	
	/**
	 * Interface for SDMX Data model classes.
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public interface ISDMXDataModel extends ISDMXServiceModel
	{
		/**
		 * The SDMX data set, after all its series have been filtered
		 * in order to display only observations falling within the defined
		 * time frame.
		 */ 
		function get filteredDataSet():DataSet;
		
		/**
		 * @private
		 */ 
		function set filteredDataSet(dataSet:DataSet):void;
		
		/**
		 * The reference series. 
		 * 
		 * <p>This is typically used in case mulitple series are plotted on a 
		 * chart. In this case, certain views, like the period slider or the 
		 * series summary box, need to know which series must act as the 
		 * reference series.</p>
		 */ 
		function get referenceSeries():TimeseriesKey;
		
		/**
		 * @private
		 */ 
		function set referenceSeries(referenceSeries:TimeseriesKey):void; 
		
		/**
		 * The filtered reference series. 
		 * 
		 * <p>It is basically the same as the reference series but, after being
		 * filtered to only include data within the selected period. It is 
		 * used in case mulitple series are plotted on a chart. In this case, 
		 * certain views, like the period slider or the chart summary box, need 
		 * to know which series must act as the reference series.</p>
		 */ 
		function get filteredReferenceSeries():TimeseriesKey;
		
		/**
		 * @private
		 */ 
		function set filteredReferenceSeries(filteredReferenceSeries:
			TimeseriesKey):void; 
		
		/**
		 * The frequency of the currently selected series. 
		 * 
		 * <p>This is typically used for formatting purposes</p>
		 * 
		 * @throws An ArgumentError will be thrown if no frequency can be found 
		 * in the dimensions of the selected time series.
		 */ 
		function get referenceSeriesFrequency():String;
		
		/**
		 * @private
		 */
		function set referenceSeriesFrequency(freq:String):void;
		
		/**
		 * The collection of periods that can used by a user to filter the data.
		 * 
		 * <p>This collection is generated automatically, based on the range of
		 * periods covered by the data set, and the frequency.</p>
		 * 
		 * <p>The collection contains objects, that will have the following
		 * properties:</p>
		 * <ul>
		 * <li>label: The label for the period (e.g.: 1Y)</li>
		 * <li>tooltip: The text for the period (e.g.: Display data for the last
		 *  year)</li>
		 * <li>selected: Whether or not the period is the one currently 
		 * selected</li>
		 * </ul>
		 * (e.g.: last month, last quarter, last year, etc).
		 */ 
		function get periods():ArrayCollection;
		
		/**
		 * @private
		 */
		function set periods(periods:ArrayCollection):void
		
		/**
		 *  Whether or not the data being displayed represent percentage
		 */
		function get isPercentage():Boolean;
		
		/**
		 * @private
		 */
		function set isPercentage(isPercentage:Boolean):void
		
		/**
		 * Updates the model when the currently selected period is changed by a
		 * view.
		 * 
		 * @param event A DataEvent containing the new period (e.g.: "1y")
		 * 
		 **/
		function handlePeriodChange(event:DataEvent):void;
		
		/**
		 * Updates the model when a chart is being dragged.
		 * 
		 * @param event A DataEvent containing an integer indicating by how many
		 *  observations the filtered dataset should be moved to the left 
		 *  (negative) or to the right (positive).
		 */
		function handleChartDragged(event:DataEvent):void;
		
		/**
		 * Updates the model when a thumb of a period slider is moved.
		 * 
		 * @param event A DataEvent containing an integer indicating by how many
		 * 			observations the filtered dataset should be moved to the 
		 * 			left (negative) or to the right (positive).
		 * @param dividerPosition right or left, depending on the thumb being
		 * 			moved.
		 */
		function handleDividerDragged(event:DataEvent, 
			dividerPosition:String):void;
	}
}