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
package eu.ecb.core.controller
{
	import eu.ecb.core.event.ProgressEventMessage;
	import eu.ecb.core.model.IModel;
	import eu.ecb.core.model.ISDMXDataModel;
	import eu.ecb.core.model.SDMXDataModel;
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	
	import org.sdmx.model.v2.reporting.dataset.DataSet;

	/**
	 * The passive SDMX data controller is being passed the dataset, and does
	 * not perform any task such as fetching the data himself.
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class PassiveSDMXDataController extends ControllerAdapter
	{
		/*===========================Constructor==============================*/
		
		public function PassiveSDMXDataController(model:IModel)
		{
			super(model);
		}
		
		/*============================Accessors===============================*/
		
		public function set dataSet(ds:DataSet):void
		{
			(model as SDMXDataModel).fullDataSet = ds;		
		}
				
		/*==========================Public methods============================*/
		
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
		public function handlePeriodChange(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXDataModel).handlePeriodChange(event);
		}
		
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
		public function handleChartDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXDataModel).handleChartDragged(event);
		}
		
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
		public function handleLeftDividerDragged(event:DataEvent):void 
		{
			event.stopImmediatePropagation();
			(model as ISDMXDataModel).handleDividerDragged(event, "left");
		}
		
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
		public function handleRightDividerDragged(event:DataEvent):void 
		{
			(model as ISDMXDataModel).handleDividerDragged(event, "right");
			event.stopImmediatePropagation();
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * Handle errors related to loading the SDMX-ML data files. 
		 * 
		 * <p>By default, the method will call the default Flex error box.</p>
		 * 
		 * @param event The event containing the error message.
		 */
		protected function handleError(event:ErrorEvent):void {
			dispatchEvent(new ErrorEvent(TASK_ERROR, false, false, event.text));
		}
		
		/**
		 * Handle the progress activity of the loading task. 
		 * 
		 * <p>By default, this method silently suppresses the event.</p>
		 * 
		 * @param event The event containing the progress information
		 */
		protected function handleProgress(event:ProgressEventMessage):void {
		}
	}
}