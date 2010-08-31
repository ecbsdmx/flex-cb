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
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	
	import flash.events.DataEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	
	/**
	 * Interface for SDMX Data model classes. Compared to the ISDMXServiceModel
	 * this interface offers:
	 * <ul>
	 * <li>Access to data optimized for certain views (such as filtered
	 * datasets)</li>
	 * <li>Offers methods to modify data, following actions performed by the
	 * users in certain views (like dragging a thumb of a period slider)</li>
	 * </ul>
	 * 
	 * @author Xavier Sosnovsky
	 */ 
	public interface ISDMXViewModel extends ISDMXServiceModel
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
		 * The data set containing all series and groups stored in the model,
		 * after filtering has been applied. 
		 * 
		 * @return The data set containing all series and groups stored in the 
		 * model after filtering has been applied. 
		 */
		function get allFilteredDataSets():DataSet;
		
		/**
		 * The SDMX data set containing the series which have been selected,
		 * using, for example, the Legend control.
		 */ 
		function get selectedDataSet():DataSet;
		
		/**
		 * @private
		 */ 
		function set selectedDataSet(dataSet:DataSet):void;
		
		/**
		 * The SDMX data set containing the series which have been highlighted,
		 * using, for example, the Legend control.
		 */ 
		function get highlightedDataSet():DataSet;
		
		/**
		 * @private
		 */ 
		function set highlightedDataSet(dataSet:DataSet):void;
		
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
		 * The series key of the series to be used as reference series. 
		 */ 
		function get referenceSeriesKey():String;
		
		/**
		 * @private
		 */ 
		function set referenceSeriesKey(seriesKey:String):void;  
		
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
		 * The currently selected date (by default, this will correspond to 
		 * the latest period for which data is available). Specially useful in 
		 * a cross-sectional scenario.
		 */ 
		function get selectedDate():String;
		
		/**
		 * @private
		 */
		function set selectedDate(date:String):void;
		
		/**
		 * Sets the desired start date, for the filtering method. This should
		 * be used to bypass the default settings for creating the filtered
		 * data set, for instance, when a range slider is used.
		 */ 
		function set startDate(date:Date):void;
		
		/**
		 * Sets the desired end date, for the filtering method. This should
		 * be used to bypass the default settings for creating the filtered
		 * data set, for instance, when a range slider is used.
		 */
		function set endDate(date:Date):void;
		
		/**
		 * By default, the model will filter series, based on the frequency of 
		 * the data (for example, for a series with daily data, containing 
		 * observations for the last 5 years, it will display only observations
		 * for the last year). Set this flag to true, to disable this behavior.
		 */ 
		function set disableDefaultPeriodFiltering(flag:Boolean):void;
		
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
			
		/**
		 * Updates the model when a legend item has been selected (after a 
		 * mouse click). If the series is already selected, it will be removed
		 * from the selection. Else, it will be added to the list of selected 
		 * series.
		 * 
		 * @param event The data event that contains the series key of the 
		 * selected legend item
		 */
		function handleLegendItemSelected(event:DataEvent):void;
		
		/**
		 * Updates the model when a legend item has been selected (after a 
		 * mouse click). At the difference with handleLegendItemSelected, this
		 * method receives a XSMeasure as input. If the series is already 
		 * selected, it will be removed from the selection. Else, it will be 
		 * added to the list of selected series.
		 * 
		 * @param event The event that contains the selected measure
		 */
		function handleLegendMeasureSelected(
			event:XSMeasureSelectionEvent):void;
		
		/**
		 * Updates the model when a legend item has been highlighted (after a 
		 * mouse over).
		 * 
		 * @param event The data event that contains the series key of the 
		 * highlighted legend item
		 */
		function handleLegendItemHighlighted(event:DataEvent):void;	
		
		/**
		 * Updates the model when a legend measure has been highlighted (after a 
		 * mouse over).
		 * 
		 * @param event The event that contains the highlighted measure
		 */
		function handleLegendMeasureHighlighted(
			event:XSMeasureSelectionEvent):void;	
		
		/**
		 * Updates the model when the currently selected date has been changed.
		 * This is important in a cross-sectional scenario, to retrieve the 
		 * proper slice of data for the selected period.
		 * 
		 * @param event The data event that contains the currently selected
		 * date
		 */
		function handleSelectedDateChanged(event:DataEvent):void;
			
		/**
		 * Returns a dataset containing the series corresponding to the
		 * supplied series keys, after filtering has been applied.
		 * 
		 * @param seriesKeys The keys of the series to be returned
		 * 
		 * @return The dataset containing the series corresponding to the
		 * supplied series keys, after filtering has been applied.
		 */
		function getFilteredDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet;	
			
		/**
		 * Returns the dataset containing the series selected in the legend.
		 * 
		 * @param seriesKeys The keys of the series to be returned
		 * 
		 * @return The dataset containing the series selected in the legend.
		 */
		function getSelectedDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet;	
			
		/**
		 * Returns the dataset containing the series highlighted in the legend.
		 * 
		 * @param seriesKeys The keys of the series to be returned
		 * 
		 * @return The dataset containing the series highlighted in the legend.
		 */
		function getHighlightedDataSetWithSeries(
			seriesKeys:ArrayCollection):DataSet;	
			
		/**
		 * Returns the minimum and maximum values available in the supplied set
		 * of series.
		 * 
		 * @param seriesKeys The keys of the series
		 * 
		 * @return An object containing the minimum and maximum values available
		 * in the supplied set of series.
		 */
		function getMinAndMaxValues(seriesKeys:ArrayCollection):Object;	
			
		/**
		 * Instructs the model that the movie functionality has started.
		 */ 	
		function startMovie():void;		
		
		/**
		 * Instructs the model that the movie functionality has stopped.
		 */ 	
		function stopMovie():void;
		
		/**
		 * Whether or not a movie is currently being played.
		 */ 
		function isPlayingMovie():Boolean
	}
}