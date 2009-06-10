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
package eu.ecb.core.view.table
{
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.view.SDMXViewAdapter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.formatters.DateBase;
	
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;

	[ResourceBundle("flex_cb_mvc_lang")]
	/**
	 * A table containing statistical data.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class Table extends SDMXViewAdapter
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _dateFormatter:SDMXDateFormatter;
		
		/**
		 * @private
		 */
		protected var _numberFormatter:ExtendedNumberFormatter;
		
		/**
		 * @private
		 */
		protected var _percentFormatter:ExtendedNumberFormatter;
		
		/**
		 * @private
		 */
		protected var _selectedView:uint;
		
		/**
		 * @private
		 */
		protected var _selectedData:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _dataGrid:DataGrid;
		
		/**
		 * @private
		 */
		protected var _dimensionCode:String;
		
		/**
		 * @private
		 */
		protected var _allObservationsMap:Object;
		
		/**
		 * @private
		 */
		protected var _allObservations:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _referenceColumn:String;
		
		/**
		 * @private
		 */
		protected var _sortDimension:String;
		
		/*===========================Constructor==============================*/
		
		public function Table(direction:String = "horizontal")
		{
			super();
			_dateFormatter = new SDMXDateFormatter();
			_dateFormatter.isShortFormat = true;
			_numberFormatter = new ExtendedNumberFormatter();
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			DateBase.monthNamesLong = resourceManager.getStringArray(
				"flex_cb_mvc_lang", "monthNamesLong");
			DateBase.monthNamesShort = resourceManager.getStringArray(
				"flex_cb_mvc_lang", "monthNamesShort");	
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The code for the dimension to be used for data columns (not the
		 * reference column). For example, REF_AREA.
		 * @param dimensionCode
		 * 
		 */
		public function set dimensionCode(dimensionCode:String):void 
		{
			_dimensionCode = dimensionCode;
		}
				
		/**
		 * The code for the dimension to be used in the reference column (the 
		 * 1st column of the table).
		 *  
		 * @param dimensionCode
		 */
		public function set referenceColumn(dimensionCode:String):void
		{
			_referenceColumn = dimensionCode;	
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (null == _dataGrid) {
				_dataGrid = new DataGrid();
				_dataGrid.allowMultipleSelection = true;
				_dataGrid.percentHeight = 100;
				_dataGrid.percentWidth = 100;
				_dataGrid.addEventListener("headerRelease", 
					handleColumnHeaderReleased);
				addChild(_dataGrid);
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if (_referenceSeriesFrequencyChanged) {
				_referenceSeriesFrequencyChanged = false;
				_dateFormatter.frequency = _referenceSeriesFrequency;
			}
			
			if (_dataSetChanged) {
				_dataSetChanged = false;
				
				//Create reference column
				var columns:Array = new Array();
				var dateColumn:DataGridColumn = new DataGridColumn();
				dateColumn.width = 100;
				dateColumn.dataField = "rowDimension";

				if (null == _referenceColumn) {
					dateColumn.headerText = "Date";
					dateColumn.labelFunction = formatDate;
				} else {
					dateColumn.headerText = "Indicator";
					dateColumn.labelFunction = formatIndicator;
				}
				columns.push(dateColumn);
				_dataGrid.columns = columns;
				
				//Need to fetch the position of column dimension (and row 
				//dimension as well, if reference column is set.
				var keyValues:KeyValuesCollection = (_dataSet.timeseriesKeys.
					getItemAt(0) as TimeseriesKey).keyValues;
				var colDimensionPosition:uint;	
				var rowDimensionPosition:uint;
				for each (var key:KeyValue in keyValues) {
					if (key.valueFor.conceptIdentity.id == _dimensionCode) {
						colDimensionPosition = keyValues.getItemIndex(key);
					} else if (null != _referenceColumn && 
						key.valueFor.conceptIdentity.id == _referenceColumn) {
						rowDimensionPosition = keyValues.getItemIndex(key);
					}
				}
				
				//Need to populate the collection
				_allObservations = new ArrayCollection();
				_allObservationsMap = new Object();
				var dimensionsMap:ArrayCollection = new ArrayCollection();
				var dimensionsMapLabel:ArrayCollection = new ArrayCollection();
				var colDimensions:ArrayCollection = new ArrayCollection();
				for each (var series:TimeseriesKey in _dataSet.timeseriesKeys) {
					var objectKey:String = (series.keyValues.getItemAt(
						colDimensionPosition) as KeyValue).value.id;
					if (!(colDimensions.contains(objectKey))) {
						colDimensions.addItem(objectKey);
					}	
					var objectKeyLabel:String = (series.keyValues.getItemAt(
						colDimensionPosition) as KeyValue).value.description.
						localisedStrings.getDescriptionByLocale("en");	
					if (!(dimensionsMap.contains(objectKey))) {
						dimensionsMap.addItem(objectKey);
						dimensionsMapLabel.addItem(objectKeyLabel);
					}
					for each (var obs:TimePeriod in series.timePeriods) {
						var rowKey:String = (null == _referenceColumn) ? 
							obs.periodComparator : (series.keyValues.getItemAt(
							rowDimensionPosition) as KeyValue).value.id;
						if (!(_allObservationsMap.hasOwnProperty(rowKey))) {
							var object:Object = new Object();
							object["rowDimension"] = 
								(null == _referenceColumn) ? 
									obs.timeValue : (series.keyValues.
									getItemAt(rowDimensionPosition) as 
									KeyValue).value.id;
							object[objectKey] = obs.observationValue;
							_allObservationsMap[rowKey] = object;	
							_allObservations.addItem(object);
						} else if (!(_allObservationsMap[rowKey].
							hasOwnProperty(objectKey))) {
							_allObservationsMap[rowKey][objectKey]
								= obs.observationValue;
						}
					}
				}
				
				//Need to add missing values
				for each (var finalObs:Object in _allObservations) {
					for each (var colKey:String in colDimensions) {
						if (!(finalObs.hasOwnProperty(colKey))) {
							var obsNumber:Number;
							finalObs[colKey] = obsNumber;
						}
					}
				}
				
				//Need to create missing columns or remove supernumerary ones
				var allColumns:Array = _dataGrid.columns;
				var rows:uint;
				var diff:int = 
					allColumns.length - dimensionsMap.length - 1;
				if (diff < 0) {
					createColumns(diff, allColumns);
				} else if (diff > 0) {
					deleteColumns(diff, allColumns);
				}
				
				for (var i:uint = 0; i < dimensionsMap.length; i++) {
					(allColumns[i + 1] as DataGridColumn).dataField = 
						dimensionsMap.getItemAt(i) as String;
					(allColumns[i + 1] as DataGridColumn).headerText = 
						dimensionsMapLabel.getItemAt(i) as String;	
				}
				_dataGrid.columns = allColumns;
				_dataGrid.dataProvider = _allObservations;
			}
		}
		
		/**
		 * @private
		 */ 
		protected function formatIndicator(item:Object, 
			column:DataGridColumn):String 
		{
			return item.rowDimension;
		}
		
		/**
		 * @private
		 */ 
		protected function handleColumnHeaderReleased(event:DataGridEvent):void
		{
			_sortDimension = event.dataField;
		}
		
		protected function sortValues(obj1:Object, obj2:Object):int {
			for (var property:String in obj1) {
				if (property != "rowDimension" && property != "mx_internal_uid")
				{
					_sortDimension = property;
					break;
				}
			}
			var returnValue:int;
			var value1:Number = Number(obj1[_sortDimension]);
			var value2:Number = Number(obj2[_sortDimension]);
			if (value1 > value2) {
				returnValue = 1;
			} else if (value1 < value2) {
				returnValue = -1;
			} else {
				returnValue = 0;
			}
			return returnValue;
		}
		
		protected function formatDate(item:Object, column:DataGridColumn):String 
		{
			return _dateFormatter.format(item.rowDimension);
		}
		
		protected function formatValue(item:Object, 
			column:DataGridColumn):String
		{
			var returnedValue:String = "";
			if (item.hasOwnProperty(column.dataField) && 
				!isNaN(Number(item[column.dataField]))) {
				returnedValue = (_isPercentage) ? 
					item[column.dataField] + "%" : item[column.dataField]; 
			} else {
				returnedValue = "-";
			}
			return returnedValue;
		}
		
		protected function createColumns(missingColumns:int, 
			allColumns:Array):void
		{
			for (var i:int = missingColumns; i < 0; i++) {
				var valueColumn:DataGridColumn = new DataGridColumn();
				valueColumn.labelFunction = formatValue;
				valueColumn.width = 100;
				valueColumn.setStyle("textAlign", "right");
				valueColumn.sortCompareFunction = sortValues;
				valueColumn.headerWordWrap = true;
				allColumns.push(valueColumn);
			}
		}
		
		protected function deleteColumns(supernumeraryColumns:int, 
			allColumns:Array):void
		{
			while (supernumeraryColumns > 0) {
				allColumns.pop();	
				supernumeraryColumns--;
			}
		}
	}
}