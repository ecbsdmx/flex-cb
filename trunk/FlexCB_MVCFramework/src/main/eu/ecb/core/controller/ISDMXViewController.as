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
package eu.ecb.core.controller
{
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	
	import flash.events.DataEvent;
	
	/**
	 * Contract to be fullfilled by controllers that react to actions performed
	 * by the user on views (e.g.: dragging a period slider).
	 *  
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 */
	public interface ISDMXViewController extends ISDMXServiceController
	{
		/**
		 * Call this function when a view updates the currently selected period.
		 * The new period is passed to the model, which will update the list
		 * of periods and the filtered dataset.
		 * 
		 * @param event A DataEvent containing the new period (e.g.: "1y")
		 * 
		 * @see eu.ecb.core.model.SDMXDataModel#periods
		 * @see eu.ecb.core.model.SDMXDataModel#filteredDataSet
		 * @see eu.ecb.core.view.filter.PeriodZoomBox
		 */
		function handlePeriodChange(event:DataEvent):void; 
		
		/**
		 * Call this function when a chart is being dragged.
		 * 
		 * @param event A DataEvent containing an integer indicating by how many
		 * observations the filtered dataset should be moved to the left 
		 * (negative) or to the right (positive).
		 * 
		 * @see eu.ecb.core.model.SDMXDataModel#periods
		 * @see eu.ecb.core.model.SDMXDataModel#filteredDataSet
		 * @see eu.ecb.core.view.chart.ECBLineChart
		 */
		function handleChartDragged(event:DataEvent):void; 
		
		/**
		 * Call this function when the left thumb of a period slider is moved.
		 * 
		 * @param event A DataEvent containing an integer indicating by how many
		 * observations the filtered dataset should be moved to the left 
		 * (negative) or to the right (positive).
		 * 
		 * @see eu.ecb.core.model.SDMXDataModel#periods
		 * @see eu.ecb.core.model.SDMXDataModel#filteredDataSet
		 * @see eu.ecb.core.view.chart.PeriodSlider
		 */
		function handleLeftDividerDragged(event:DataEvent):void; 
		
		/**
		 * Call this function when the right thumb of a period slider is moved.
		 * 
		 * @param event A DataEvent containing an integer indicating by how many
		 * observations the filtered dataset should be moved to the left 
		 * (negative) or to the right (positive).
		 * 
		 * @see eu.ecb.core.model.SDMXDataModel#periods
		 * @see eu.ecb.core.model.SDMXDataModel#filteredDataSet
		 * @see eu.ecb.core.view.chart.PeriodSlider
		 */
		function handleRightDividerDragged(event:DataEvent):void; 
		
		/**
		 * Call this function when a legend item has been selected (after a 
		 * mouse click).
		 * 
		 * @param event The data event that contains the series key of the 
		 * selected legend item
		 */
		function handleLegendItemSelected(event:DataEvent):void;
		
		/**
		 * Call this function when a legend measure has been selected (after a 
		 * mouse click).
		 * 
		 * @param event The event that contains the selected measure
		 */
		function handleLegendMeasureSelected(event:XSMeasureSelectionEvent):void
		
		/**
		 * Call this function when a legend item has been highlighted (after a 
		 * mouse over).
		 * 
		 * @param event The data event that contains the series key of the 
		 * highlighted legend item
		 */
		function handleLegendItemHighlighted(event:DataEvent):void;
		
		/**
		 * Call this function when a legend measure has been highlighted (after 
		 * a mouse over).
		 * 
		 * @param event The vent that contains the highlighted measure
		 */
		function handleLegendMeasureHighlighted(
			event:XSMeasureSelectionEvent):void;
		
		/**
		 * Call this function when the currently selected date has been changed.
		 * This is important in a cross-sectional scenario, to retrieve the 
		 * proper slice of data for the selected period.
		 * 
		 * @param event The data event that contains the currently selected
		 * date
		 */
		function handleSelectedDateChanged(event:DataEvent):void;
		
		/**
		 * Changes the start date currently set in the model.
		 */ 
		function changeStartDate(date:Date):void;		
		
		/**
		 * Changes the end date currently set in the model.
		 */ 
		function changeEndDate(date:Date):void;
		
		/**
		 * Instructs the controller that a movie functionality has started
		 */ 
		function startMovie():void;
		
		/**
		 * Instructs the controller that a movie functionality has stopped
		 */ 
		function stopMovie():void;
	}
}