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
	import eu.ecb.core.command.CommandAdapter;
	import eu.ecb.core.command.IInvoker;
	import eu.ecb.core.command.InvokerAdapter;
	import eu.ecb.core.command.LoadSDMXData;
	import eu.ecb.core.event.ProgressEventMessage;
	import eu.ecb.core.model.ISDMXDataModel;
	import eu.ecb.core.model.SDMXDataModel;
	import eu.ecb.core.util.net.XMLLoader;
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.sdmx.event.SDMXDataEvent;
	import org.sdmx.model.v2.reporting.dataset.DataSet;
	import org.sdmx.model.v2.reporting.dataset.GroupKey;
	import org.sdmx.model.v2.reporting.dataset.GroupKeysCollection;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKeysCollection;

	/**
	 * This controller will extract statistical data and metadata from
	 * an SDMX-ML data file and an SDMX-ML structure file.
	 * 
	 * In addition, it implements methods commonly needed by views, such 
	 * as handling changes of periods, or handling dragging a data chart.
	 * 
	 * @author Xavier Sosnovsky
	 * @author Karine Feraboli
	 * 
	 * @todo
	 * 		1. Add the possibility to have multiple commands, tackling
	 * 		   different data files.
	 * 		2. Implement the Strategy pattern to enable changing the SDMX-ML
	 * 		   loader, based on the format of the SDMX-ML data file (e.g.: 
	 * 		   Compact, Generic, etc).
	 */
	public class SDMXDataController extends ControllerAdapter
	{	
		/*==============================Fields================================*/
		
		/**
		 * @private 
		 */
		protected var _dataFile:String;
		
		/**
		 * @private 
		 */
		protected var _structureFile:String;
		
		/**
		 * @private 
		 */
		protected var _seriesKeys:ArrayCollection;
		
		/**
		 * @private 
		 */
		protected var _command:LoadSDMXData;
		
		/**
		 * @private 
		 */
		protected var _invoker:IInvoker;
		
		/**
		 * @private 
		 */
		protected var _nrOfFilesToFetch:uint;
		
		/**
		 * @private 
		 */
		protected var _filesToFetch:ArrayCollection;
		
		/**
		 * @private
		 */ 
		protected var _totalNrOfFiles:uint;
		
		/**
		 * @private 
		 */
		protected var _tmpDataSet:DataSet;
			
		/*===========================Constructor==============================*/
		
		/**
		 * Instantiates an SDMXDataController. 
		 * 
		 * @param model The SDMX model that will be affected by the actions of 
		 * the controller
		 * @param dataFile The SDMX-ML data file to be loaded
		 * @param structureFile The SDMX-ML structure file, containing the data
		 * 		structure definintion for the data to be fetched
		 * @param disableObservationAttribute Whether the loader should extract
		 * 		observation level attributes. By default, it is disabled, as 
		 * 		this task can negatively affect performance, depending on the 
		 * 		number of observations available in the data file.
		 */
		public function SDMXDataController(model:ISDMXDataModel, 
			dataFile:String, structureFile:String, 
			disableObservationAttribute:Boolean = true)
		{
			super(model);
			_dataFile = dataFile;
			_structureFile = structureFile;
			_nrOfFilesToFetch = 0;
			
			_command = 
				new LoadSDMXData(dataFile, structureFile, new XMLLoader());
			_command.addEventListener(CommandAdapter.COMMAND_COMPLETED, 
				handleData);
			_command.addEventListener(CommandAdapter.COMMAND_ERROR, 
				handleError);
			_command.disableObservationAttribute = disableObservationAttribute;	
			
			_invoker = new InvokerAdapter();
			_invoker.addCommand(_command);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The keys of the series to be extracted from the data file. By 
		 * default, all series are extracted out of the SDMX-ML data file. In
		 * case of large data files, it may be more efficient to just extract 
		 * the series needed for the initial state of the application.
		 */
		public function get seriesKeys():ArrayCollection {
			return _seriesKeys;
		}
		
		/**
		 * @private
		 */
		public function set seriesKeys(seriesKeys:ArrayCollection):void {
			_seriesKeys = seriesKeys;
			_command.seriesKeys = seriesKeys;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Extracts the statistical data and metadata from the SDMX-ML data file 
		 * and the SDMX-ML structure file. If seriesKeys is empty, all series
		 * will be extracted.
		 * 
		 * @see #seriesKeys
		 */
		public function loadData():void 
		{
			_invoker.invokeCommands();
		}
		
		
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
		
		/**
		 * Fetches and process the data of all the SDMX data files supplied in
		 * the collection. 
		 * @param files The list of SDMX data files to fetch
		 */
		public function fetchFiles(files:ArrayCollection):void
		{
			dispatchEvent(new Event(TASK_STARTED));
			var isFetching:Boolean = false;
			if (null != _filesToFetch && _filesToFetch.length > 0) {
				isFetching = true;
				for each (var file:String in files) {
					_filesToFetch.addItem(file);
				}
				_nrOfFilesToFetch = _filesToFetch.length + 1;
				_totalNrOfFiles = _filesToFetch.length + 1;
			} else {
				_filesToFetch = files;
				_nrOfFilesToFetch = _filesToFetch.length;
				_totalNrOfFiles = _filesToFetch.length;
			}
			if (null != _tmpDataSet && !isFetching) {
				_tmpDataSet.timeseriesKeys = null;
				_tmpDataSet.groupKeys = null;
				_tmpDataSet.attributeValues = null;
			}
			
			if (!isFetching) {
				_command.dataFile = _filesToFetch.removeItemAt(0) as String;
				dispatchEvent(new ProgressEventMessage(TASK_PROGRESS, false, 
					false, 0, 0, "Please wait: Loading data (" + 
					Math.round( (1 /_totalNrOfFiles) * 100) + "%)"));
				_invoker.invokeCommands();
			}	
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * This method is called when the command responsible for loading the
		 * SDMX-ML files has finished executing. 
		 * 
		 * At this poing, the statistical data and metadata available in the 
		 * SDMX-ML files has been processed and the data set is passed to the
		 * model.
		 * 
		 * @param event The event containing the data set
		 * 
		 * @see eu.ecb.core.model.SDMXDataModel#dataSet
		 * @see org.sdmx.model.v2.reporting.dataset.DataSet
		 * @see eu.ecb.core.command.LoadSDMXData
		 */
		protected function handleData(event:SDMXDataEvent):void 
		{
			if (_nrOfFilesToFetch > 0) {
				_nrOfFilesToFetch--;
			}
			if (null == _tmpDataSet) {
				_tmpDataSet = event.data as DataSet;
			} else {
				if (null == _tmpDataSet.timeseriesKeys) {
					_tmpDataSet.timeseriesKeys = new TimeseriesKeysCollection();
				}
				for each (var s:TimeseriesKey in (event.data as 
					DataSet).timeseriesKeys) {		            
					_tmpDataSet.timeseriesKeys.addItem(s);
				}
			
				if (null == _tmpDataSet.groupKeys) {
					_tmpDataSet.groupKeys = new GroupKeysCollection();
				}
				for each (var group:GroupKey in (event.data as 
					DataSet).groupKeys) {
					_tmpDataSet.groupKeys.addItem(group);
				}
			}
			if (0 == _nrOfFilesToFetch) {
				dispatchEvent(new Event(TASK_COMPLETED));
				(model as SDMXDataModel).fullDataSet = _tmpDataSet;
			} else {
				dispatchEvent(new ProgressEventMessage(TASK_PROGRESS, false, 
					false, _totalNrOfFiles - _filesToFetch.length + 1, 
					_totalNrOfFiles, "Please wait: Loading data (" + 
					Math.round(((_totalNrOfFiles -	_filesToFetch.length + 1) /
						_totalNrOfFiles) * 100) + "%)"));
				_command.dataFile = _filesToFetch.removeItemAt(0) as String;
				_invoker.invokeCommands();	
			}
		}
		
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