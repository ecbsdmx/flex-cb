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
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.util.formatter.ExtendedNumberFormatter;
	import eu.ecb.core.util.formatter.SDMXDateFormatter;
	import eu.ecb.core.util.formatter.series.ISeriesTitleFormatter;
	import eu.ecb.core.util.math.MathHelper;
	import eu.ecb.core.view.BaseSDMXView;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.formatters.DateBase;
	
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.KeyValuesCollection;
	import org.sdmx.model.v2.reporting.dataset.TimePeriod;
	import org.sdmx.model.v2.reporting.dataset.TimeseriesKey;
	import org.sdmx.util.date.SDMXDate;

	[ResourceBundle("flex_cb_mvc_lang")]
	/**
	 * A table containing statistical data.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class Table extends BaseSDMXView
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
		protected var _changeNumberFormatter:ExtendedNumberFormatter;
		
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
		protected var _referenceColumn:String;
		
		/**
		 * @private
		 */
		protected var _sortDimension:String;
		
		/**
		 * @private
		 */
		protected var _createChangeColumn:Boolean;
		
		protected var _obsDisplaySort:Sort;
		
		private var _dateConverter:SDMXDate;
		
		private var _isHidden:Boolean;
		
		private var _formatter:ISeriesTitleFormatter;
		
		private var _descending:Boolean;
		
		private var _rowDimensionSort:Sort;
		
		private var _showChangePercentage:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function Table(direction:String = "horizontal", 
			showChangePercentage:Boolean = true)
		{
			super();
			_dateFormatter = new SDMXDateFormatter();
			_dateFormatter.isShortFormat = true;
			_numberFormatter = new ExtendedNumberFormatter();
			_changeNumberFormatter = new ExtendedNumberFormatter();
			_changeNumberFormatter.forceSigned = true;	
			_percentFormatter = new ExtendedNumberFormatter();
			_percentFormatter.precision = 1;
			_percentFormatter.forceSigned = true;
			DateBase.monthNamesLong = resourceManager.getStringArray(
				"flex_cb_mvc_lang", "monthNamesLong");
			DateBase.monthNamesShort = resourceManager.getStringArray(
				"flex_cb_mvc_lang", "monthNamesShort");	
			_dateConverter = new SDMXDate();
			_showChangeChanged = showChangePercentage;
			
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The code for the dimension to be used for data columns (not the
		 * reference column). For example, REF_AREA. If no dimension is passed,
		 * and there is only one series in the dataset, the class will use the 
		 * measure for the 2nd column. If no dimension is passed, and there are
		 * more than one series in the dataset, the class will try to figure out
		 * which dimension to use for distinguishing columns.
		 * 
		 * @param dimensionCode
		 * 
		 */
		public function set dimensionCode(dimensionCode:String):void 
		{
			_dimensionCode = dimensionCode;
		}
				
		/**
		 * The code for the dimension to be used in the reference column (the 
		 * 1st column of the table). If no dimension is passed as reference
		 * column, the class will use the time dimension as reference column
		 * (it will be a list of reference periods).
		 *  
		 * @param dimensionCode
		 */
		public function set referenceColumn(dimensionCode:String):void
		{
			_referenceColumn = dimensionCode;	
		}
		
		
		/**
		 * Whether or not a column displaying the changes with the previous
		 * period should be created.
		 *  
		 * @param flag
		 */
		public function set createChangeColumn(flag:Boolean):void
		{
			_createChangeColumn = flag;
		}
		
		public function set isHidden(flag:Boolean):void
		{
			_isHidden = flag;
			invalidateProperties();
		}
		
		public function handleMeasureSelected(
			event:XSMeasureSelectionEvent):void 
		{
			dimensionCode = event.measure.conceptIdentity.id;	
		}
		
		public function set titleFormatter(formatter:ISeriesTitleFormatter):void
		{
			if (null != formatter) {
				_formatter = formatter;
			}
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
			
			if (_filteredDataSetChanged && !_isHidden) {
				_filteredDataSetChanged = false;
				
				//Create reference column
				var columns:Array = new Array();
				var refCol:DataGridColumn = new DataGridColumn();
				refCol.width = 100;
				refCol.dataField = "rowDimension";

				if (null == _referenceColumn) {
					refCol.headerText = "Date";
					refCol.labelFunction = formatDate;
				} else {
					refCol.headerText = "Indicator";
					refCol.labelFunction = formatIndicator;
				}
				columns.push(refCol);
				_dataGrid.columns = columns;
				
				//Need to fetch the position of column dimension (and row 
				//dimension as well, if reference column is set).
				var keyValues:KeyValuesCollection = (_filteredDataSet.
					timeseriesKeys.getItemAt(0) as TimeseriesKey).keyValues;
				var colDimensionPosition:Number = -1;	
				var rowDimensionPosition:Number = -1;
				for each (var key:KeyValue in keyValues) {
					if (key.valueFor.conceptIdentity.id == _dimensionCode) {
						colDimensionPosition = keyValues.getItemIndex(key);
					} else if (null != _referenceColumn && 
						key.valueFor.conceptIdentity.id == _referenceColumn) {
						rowDimensionPosition = keyValues.getItemIndex(key);
					}
				}
				
				if (null != _referenceColumn && rowDimensionPosition == -1) {
					throw new ArgumentError("Could not find the dimension to " + 
						" be used as row dimension");
				}
				
				if (null != _dimensionCode && colDimensionPosition == -1) {
					throw new ArgumentError("Could not find the dimension to " + 
						"be used as column dimension");
				} else if (null == _dimensionCode && colDimensionPosition == -1
					&& _filteredDataSet.timeseriesKeys.length == 1) {
					colDimensionPosition = 0;	
				} else if (null == _dimensionCode && colDimensionPosition == -1
					&& _filteredDataSet.timeseriesKeys.length > 1) {
					var dimensions:ArrayCollection = new ArrayCollection();
					for each (var s:TimeseriesKey in 
						_filteredDataSet.timeseriesKeys) {
						for (var l:int = 0; l < s.keyValues.length; l++) {
							var tKey:KeyValue = 
								s.keyValues.getItemAt(l) as KeyValue;
							var dimCodes:ArrayCollection;
							if (l > dimensions.length -1) {
								dimCodes = new ArrayCollection();
								dimensions.addItem(dimCodes);
							} else {
								dimCodes = dimensions.getItemAt(l) as
									ArrayCollection;
							}
							if (!(dimCodes.contains(tKey.value.id))) {
								dimCodes.addItem(tKey.value.id);
							}
						}	
					}
					
					for (var m:int = 0; m < dimensions.length; m++) {
						if ((dimensions.getItemAt(m) as ArrayCollection).length
							> 1) {
							colDimensionPosition = m;
							break;	
						}
					}
				} 
				
				// Set the sort fields
				var sortCol:Sort = new Sort();
				sortCol.fields = [new SortField("key")];	
				var sortObs:Sort = new Sort();
				sortObs.fields = [new SortField("rowDimension")];	
				
				// This variable holds the observations
				var observations:ArrayCollection = new ArrayCollection();
				observations.sort = sortObs;
				observations.refresh();
				var obsCursor:IViewCursor = observations.createCursor();
				
				// This variable holds the dimensions used for the columns.
				var colDimensions:ArrayCollection = new ArrayCollection();
				colDimensions.sort = sortCol;
				colDimensions.refresh();
				var colCursor:IViewCursor = colDimensions.createCursor();
				
				//Need to populate the two collections
				var quickMode:Boolean = (null == _dimensionCode && 
					1 == _filteredDataSet.timeseriesKeys.length); 
				for each (var series:TimeseriesKey in 
					_filteredDataSet.timeseriesKeys) {
					var colKeyCode:String = (quickMode) ? "value" : 
						(series.keyValues.getItemAt(
						colDimensionPosition) as KeyValue).value.id;
					var colKeyDesc:String = (quickMode) ? "Value" :
						(null == _formatter) ? 
						(series.keyValues.getItemAt(
						colDimensionPosition) as KeyValue).value.description.
						localisedStrings.getDescriptionByLocale("en") :
						_formatter.getSeriesTitle(series);	
					if (!(colCursor.findAny({key: colKeyCode}))) {
						colDimensions.addItem({key: colKeyCode, 
						desc: colKeyDesc});
					}
					for (var j:uint = 0; j < series.timePeriods.length; j++) {
						var obs:TimePeriod = 
							series.timePeriods.getItemAt(j) as TimePeriod;
						if (j == 0) { 	
							_changeNumberFormatter.precision = 
								obs.observationValue.indexOf(".") > -1 ? 
					    			obs.observationValue.substring(
					    				obs.observationValue.indexOf(".") + 1, 
		    							obs.observationValue.length).length : 0;
		    			}
						var rowKey:String = (null == _referenceColumn) ? 
							obs.periodComparator : (series.keyValues.getItemAt(
							rowDimensionPosition) as KeyValue).value.id;
						if (!(obsCursor.findAny({rowDimension: rowKey}))) {
							var object:Object = new Object();
							object["rowDimension"] = rowKey;
							object[colKeyCode] = obs.observationValue;
							if (_createChangeColumn && 0 < j) {
								createChangeObs(series.timePeriods.
								getItemAt(j - 1) as TimePeriod, obs, object, 
								colKeyCode);
							} 
							observations.addItem(object);
						} else if (!quickMode && !(obsCursor.current.
							hasOwnProperty(colKeyCode))) {
							obsCursor.current[colKeyCode] = 
								obs.observationValue;
							if (_createChangeColumn && 0 < j) {
								createChangeObs(series.timePeriods.getItemAt(
								j + 1) as TimePeriod, obs, obsCursor.current, 
								colKeyCode);
							} 	
						}
					}
				}
				
				//Need to add missing values
				for each (var finalObs:Object in observations) {
					for each (var col:Object in colDimensions) {
						if (!(finalObs.hasOwnProperty(col.key))) {
							var obsNumber:Number;
							finalObs[col.key] = obsNumber;
						}
						if (_createChangeColumn && !(finalObs.hasOwnProperty(
							col.key + "_change"))) {
							var obsChange:Number;
							finalObs[col.key + "_change"] = null;
						}
					}
				}
				
				//Need to create missing columns or remove supernumerary ones
				var allColumns:Array = _dataGrid.columns;
				var rows:uint;
				var diff:int = 
					allColumns.length - colDimensions.length - 1;
				if (_createChangeColumn) {
					diff = diff * 2;
				}	
				if (diff < 0) {
					createColumns(diff, allColumns);
				} else if (diff > 0) {
					deleteColumns(diff, allColumns);
				}
				
				var foundSortDimension:Boolean = false;
				for (var i:uint = 0; i < colDimensions.length; i++) {
					(allColumns[i + 1] as DataGridColumn).dataField = 
						colDimensions.getItemAt(i).key;
					(allColumns[i + 1] as DataGridColumn).headerText = 
						colDimensions.getItemAt(i).desc;
					if (_sortDimension == colDimensions.getItemAt(i).key) {
						foundSortDimension = true;
					}		
					if (_createChangeColumn) {
						(allColumns[i + 2] as DataGridColumn).dataField = 
							colDimensions.getItemAt(i).key + "_change";
						(allColumns[i + 2] as DataGridColumn).headerText = 
							"Change";
						(allColumns[i + 2] as DataGridColumn).labelFunction = 
							null;
						(allColumns[i + 2] as DataGridColumn).
							sortCompareFunction = sortChanges;
						(allColumns[i + 2] as DataGridColumn).itemRenderer = 
							new ClassFactory(ChangeRenderer);
						i++;
					}	
				}
				_dataGrid.columns = allColumns;
				
				if (!foundSortDimension) {
					_sortDimension = null;
				}
				_obsDisplaySort = new Sort();
				_descending = (_descending) ? false : true;
				_obsDisplaySort.fields = (null == _sortDimension) ?
					[new SortField("rowDimension", false, _descending, false)] :
					[new SortField(_sortDimension, false, _descending, true)];
				_dataGrid.dataProvider = observations;
				_dataGrid.dataProvider.sort = _obsDisplaySort;
				_dataGrid.dataProvider.refresh();
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
			event.preventDefault();
			_descending = (_descending) ? false : true;
			var isNumber:Boolean = 
				(event.dataField == "rowDimension") ? false : true; 
			_sortDimension = event.dataField;			
			_dataGrid.dataProvider.sort.fields = 
				[new SortField(_sortDimension, true, _descending, isNumber)];
			_dataGrid.dataProvider.refresh();
		}
		
		protected function sortValues(obj1:Object, obj2:Object):int {
			for (var property:String in obj1) {
				if (property != "rowDimension" && property != "mx_internal_uid"
					&& property != "value_change")
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
			return _dateFormatter.format(
				_dateConverter.getDate(item.rowDimension));
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
		
		private function createChangeObs(currentObs:TimePeriod, 
			nextObs:TimePeriod, object:Object, key:String):void
		{
             	object[key + "_change"] = _changeNumberFormatter.format(Number(
             		nextObs.observationValue) - Number(currentObs.
             		observationValue));
             	if (!_isPercentage && _showChangePercentage) {
             		object[key + "_change"] = object[key + "_change"] + " (" + 
             		((Number(currentObs.observationValue) != 0) ? (
             		_percentFormatter.format(MathHelper.calculatePercentOfChange
             		(Number(currentObs.observationValue), Number(nextObs.
             		observationValue)))) + "%)" : "-)");
             	}	
		}
		
		private function sortChanges(obj1:Object, obj2:Object):int 
		{
			var returnValue:int;
			var change1:String = obj1.value_change;
			var change2:String = obj2.value_change;
			if (null == change1 || 0 == change1.length) {
				returnValue = -1;
			} else if (null == change2 || 0 == change2.length) {
				returnValue = 1;
			} else {
				var end1:int = (change1.indexOf(" ") > -1) ? 
					change1.indexOf(" ") : change1.length;
				var end2:int = (change2.indexOf(" ") > -1) ? 
					change2.indexOf(" ") : change2.length;
				var start1:uint = 
					(change1.charAt(0) == "+") ? 1 : 0; 
				var start2:uint = 
					(change2.charAt(0) == "+") ? 1 : 0;
				var value1:Number = Number(change1.substring(start1, end1));	 
				var value2:Number = Number(change2.substring(start2, end2));	
				
				if (value1 > value2) {
					returnValue = 1;
				} else if (value1 < value2) {
					returnValue = -1;
				} else {
					returnValue = 0;
				}
			}	
			return returnValue;
		}
	}
}