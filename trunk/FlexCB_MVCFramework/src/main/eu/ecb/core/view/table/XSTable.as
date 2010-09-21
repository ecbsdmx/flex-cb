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
package eu.ecb.core.view.table
{
	import eu.ecb.core.event.HierarchicalItemSelectedEvent;
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.util.formatter.section.ISectionTitleFormatter;
	import eu.ecb.core.util.formatter.xsobs.IXSObsTitleFormatter;
	import eu.ecb.core.util.helper.XSSortOrder;
	import eu.ecb.core.view.BaseSDMXView;
	import eu.ecb.core.view.IHierarchicalView;
	import eu.ecb.core.view.util.LinkUp;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	
	import org.sdmx.model.v2.reporting.dataset.CodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSObservation;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.model.v2.structure.keyfamily.XSMeasure;

	/**
	 * A table containing cross-sectional data.
	 *  
	 * @author Xavier Sosnovsky
	 * @author Rok Povse
	 */
	public class XSTable extends BaseSDMXView implements IHierarchicalView
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _measureMap:Object;
		
		/**
		 * @private
		 */
		protected var _dispatchedEvent:XSMeasureSelectionEvent;
		
		/**
		 * @private
		 */
		protected var _sortField:String;
		
		/**
		 * @private
		 */
		protected var _sortMeasure:String;
		
		/**
		 * @private
		 */
		protected var _sortDescending:Boolean;
		
		/**
		 * @private
		 */
		protected var _hierarchy:Hierarchy;
		
		/**
		 * @private
		 */
		protected var _selectedAssociation:CodeAssociation;
		
		/**
		 * @private
		 */
		protected var _observations:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _dataGrid:DataGrid;
		
		/**
		 * @private
		 */
		protected var _isHidden:Boolean;
		private var _sectionFormatter:ISectionTitleFormatter;
		private var _obsFormatter:IXSObsTitleFormatter;
		private var _referenceColumn:DataGridColumn;
		private var _sort:Sort;
		private var _upLink:LinkUp;
		private var _parentsAssoc:Object; 
		[Embed(source="../../../assets/images/ZoomIn.png")]
		private var _drillDownCursor:Class;
		private var _headerPressed:Boolean;
		private var _fullWidth:Boolean;
		
		/*===========================Constructor==============================*/
		
		public function XSTable(direction:String="vertical")
		{
			super(direction);
			_parentsAssoc = new Object();
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * Sets the formatter for the section title.
		 */ 
		public function set titleFormatter(
			formatter:ISectionTitleFormatter):void
		{
			if (null != formatter) {
				_sectionFormatter = formatter;
			}
		}
		
		/**
		 * Sets the formatter for the observations.
		 */ 
		public function set obsFormatter(
			formatter:IXSObsTitleFormatter):void
		{
			if (null != formatter) {
				_obsFormatter = formatter;
			}
		}
		
		/**
		 * Sets the field to be used for sorting.
		 */ 
		public function set sortField(field:String):void
		{
			_sortField = field;
		}
		
		/**
		 * Sets the sort algorithm for sorting the observations
		 */ 
		public function set sortOrder(order:String):void
		{
			setSortOrder(order);
			if (null == _sort) {
				_sort = new Sort();
			}
		}
		
		/**
		 * @inheritDoc
	     */
		public function set hierarchy(h:Hierarchy):void
		{
			_hierarchy = h;
		}
		
		/**
		 * @inheritDoc
	     */
		public function get hierarchy():Hierarchy
		{
			return _hierarchy;
		}
		
		/**
		 * @inheritDoc
	     */
		public function set selectedHierarchyItem(code:CodeAssociation):void
		{
			_selectedAssociation = code;
			if (!(_parentsAssoc.hasOwnProperty(
				_selectedAssociation.code.id))) {
				_parentsAssoc[_selectedAssociation.code.id] = null;	
			}
			if (_parentsAssoc[_selectedAssociation.code.id] == null) {
				_upLink.visible = false;
				_upLink.height = 0;
			} else {
				_upLink.visible = true;
				_upLink.height = 18;
			}
		}

		/**
		 * @inheritDoc
	     */
		public function get selectedHierarchyItem():CodeAssociation
		{
			return _selectedAssociation;
		}
		
		/**
		 * @inheritDoc
	     */
		public function set isHidden(value:Boolean):void
		{
			_isHidden=value;
			invalidateProperties();
		}
		
		/**
		 * Whether the width of the datagrid should expand to the full width of
		 * the parent.
		 */ 
		public function set fullWidth(flag:Boolean):void
		{
			_fullWidth = flag;
			if (null != _dataGrid) {
				if (flag) {
					_dataGrid.percentWidth = 100;
				} else {
					_dataGrid.percentWidth = NaN;
				}
			}
		}
		
		/*=========================Public methods=============================*/
		
		/**
		 * Handles the event triggering the sorting mechanism.
		 */ 
		public function handleSortUpdated(event:DataEvent):void {
			setSortOrder(event.data);
			triggerSort();
		}
		
		/**
		 * @inheritDoc
	     */
		public function handleDrillDown(event:Event):void 
		{
			event.stopImmediatePropagation();
			if (event is ListEvent) {
				var measure:String = 
					(event as ListEvent).itemRenderer.data.measure;
				for each (var assoc:CodeAssociation in 
					_selectedAssociation.children) {
					if (assoc.code.id == measure) {
						if (assoc.children.length > 0) {
							_parentsAssoc[assoc.code.id] = 
								_selectedAssociation;
							selectedHierarchyItem = assoc;
							dispatchEvent(new HierarchicalItemSelectedEvent(
								"drillDown", selectedHierarchyItem));
								
						}
						break;
					}	
				}	
			} else if (event is HierarchicalItemSelectedEvent) {
				var eventCodeId:String = (event as 
					HierarchicalItemSelectedEvent).codeAssocation.code.id;
				var isRootElement:Boolean = false;
				for each (var rootAssoc:CodeAssociation in _hierarchy.children){
					if (rootAssoc.code.id == eventCodeId) {
						isRootElement = true;
					}
				}	
				if (!isRootElement) {	 
					_parentsAssoc[eventCodeId] = _selectedAssociation;
				}
				selectedHierarchyItem = 
					(event as HierarchicalItemSelectedEvent).codeAssocation;
			}
			event = null;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createChildren():void 
		{
			if (null == _upLink) {
				_upLink = new LinkUp();
				_upLink.visible = false;
				_upLink.height = 0;
				_upLink.addEventListener(MouseEvent.CLICK, handleUpLinkClicked,
					false, 0, true);
				addChild(_upLink);
			}
			
			if (null == _dataGrid) {
				_dataGrid = new DataGrid();
				_dataGrid.allowMultipleSelection = true;
				_dataGrid.percentHeight = 100;
				if (_fullWidth) {
					_dataGrid.percentWidth = 100;
				}
				_dataGrid.addEventListener(ListEvent.ITEM_CLICK, 
					handleItemSelected);
				_dataGrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, 
					handleDrillDown);
				_dataGrid.addEventListener(ListEvent.ITEM_ROLL_OVER, 
					handleRollOver);
				_dataGrid.addEventListener(ListEvent.ITEM_ROLL_OUT, 
					handleRollOut);
				_dataGrid.addEventListener(MouseEvent.CLICK, 
					handleCheckCtrlClick);
				_dataGrid.addEventListener("headerRelease", 
					handleColumnHeaderReleased);
				addChild(_dataGrid);
			}
			
			super.createChildren();
		}
		
		/**
		 * Handles the creation of a data column (not the indicator column).
		 */ 
		protected function createDataColumn(section:Section, 
			group:XSGroup):DataGridColumn
		{
			var sectionId:String =  group.keyValues.seriesKey.replace("\.", "_")
				+ "_" + section.keyValues.seriesKey.replace("\.", "_");
			_sortField = sectionId;
			if (null == _sortMeasure) {
				_sortMeasure = _sortField;
			}	
			for (var i:uint = 0; i < section.observations.length; i++) {
				var obs:XSObservation = 
					section.observations.getItemAt(i) as XSObservation;	
				var measure:XSMeasure = (obs is UncodedXSObservation) ? 
					(obs as UncodedXSObservation).measure :
					(obs as CodedXSObservation).measure;
				if (null == _selectedAssociation || null == _hierarchy || 
					!isSelectedMeasure(measure)) {		
					var newObs:Object;	
					if (!(_measureMap.hasOwnProperty(measure.code.id))) {
						newObs = new Object();
						newObs["measure"] = measure.code.id;
						newObs["measureDescription"] = measure.code.description.
							localisedStrings.getDescriptionByLocale("en");
						newObs["dataSetOrder"] = i;	
						
						var holder:Object = new Object();
						holder["obsData"] = newObs;
						holder["xsMeasure"] = measure;
						holder["xsObs"] = obs;
						_measureMap[measure.code.id] = holder;
						_observations.addItem(newObs);
					} else {
						newObs = _measureMap[measure.code.id]["obsData"];
					}	
					newObs[sectionId] = 
						(obs is UncodedXSObservation) ? 
							(obs as UncodedXSObservation).value : 
							(obs as CodedXSObservation).value.id;
				}														
			}
			
			var col:DataGridColumn = new DataGridColumn();
			col.dataField = sectionId;
			col.headerText = getHeaderText(section);
			col.labelFunction = formatValue;
			col.setStyle("textAlign", "right");
			col.headerWordWrap = true;
			col.width = 100;
			return col;	
		}	
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_dataSetChanged && !_isHidden) {
				if (!(_dataSet is XSDataSet)) {
					throw new ArgumentError("This cross-sectional view " + 
						"only accepts a XSDataSet as input");
				} else if ((_dataSet as XSDataSet).groups.length == 0) {
					throw new ArgumentError("No data to be displayed");
				}
				_dataSetChanged = false;
				
				var allColumns:Array = new Array();
				_observations = new ArrayCollection();
				_measureMap = new Object();
				
				var obs:XSObservation = (((_dataSet as XSDataSet).groups.
					getItemAt(0) as XSGroup).sections.getItemAt(0) as Section).
					observations.getItemAt(0) as XSObservation;
				var measure:XSMeasure = (obs is UncodedXSObservation) ? 
					(obs as UncodedXSObservation).measure : 
					(obs as CodedXSObservation).measure;
				allColumns.push(createReferenceColumn(measure));
				
				for each (var group:XSGroup in (_dataSet as XSDataSet).groups) {
					for each (var section:Section in group.sections) {
						var newColumn:DataGridColumn =createDataColumn(section,group);
						if (newColumn!=null) {
							allColumns.push(newColumn);
						}
					}
				}
				
				if (null != _sort) {
					triggerSort();
				}
				
				_dataGrid.columns = allColumns;
				_dataGrid.dataProvider = _observations;
			}
			super.commitProperties();
		}
		
		/**
		 * Formats the indicator (label for the row).
		 */ 
		protected function formatIndicator(item:Object, 
			column:DataGridColumn):String 
		{
			var rowLabel:String;
			if (null != _obsFormatter) {
				rowLabel = _obsFormatter.getXSObsTitle(
					_measureMap[item.measure]["xsObs"] as XSObservation);
			} else {
				rowLabel = item.measureDescription; 
			}
			return rowLabel;
		}
		
		/**
		 * Format the cross-sectional observation.
		 */ 
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
		
		/**
		 * Handles the selection of a cross-sectional measure.
		 */ 
		protected function handleItemSelected(event:ListEvent):void
		{
			event.stopImmediatePropagation();
			if (_measureMap.hasOwnProperty(event.itemRenderer.data.measure)) {
				_dispatchedEvent = new XSMeasureSelectionEvent(
					_measureMap[event.itemRenderer.data.measure]["xsMeasure"],
					(event.currentTarget as DataGrid).
					selectedItems.length > 1, "measureSelected");
			} else {
				_dispatchedEvent = null;
			}
			event = null;
		}
		
		/**
		 * Triggers the sorting mechanism on the data displayed in the table. 
		 */ 
		protected function triggerSort():void 
		{
			if (null == _sort) {
				_sort = new Sort();
			}
			var isNumber:Boolean = 
				(_sortField == "measureDescription") ? false : true; 
			_sort.fields = 
				[new SortField(_sortField, true, _sortDescending, isNumber)];
			_observations.sort = _sort;
			_observations.refresh();
		}
		
		/**
		 * Returns the section header text.
		 */ 
		protected function getHeaderText(section:Section):String
		{
			var title:String;
			if (null != _sectionFormatter) {
				title = _sectionFormatter.getSectionTitle(section);
			} else if (section.keyValues.length == 1) {
				title = (section.keyValues.getItemAt(0) as KeyValue).value.
					description.localisedStrings.getDescriptionByLocale("en");			
			} else {
				title = "Value";
			}
			return title;
		}
		
		/**
		 * Whether the supplied measure is the currently selected association.
		 */ 
		protected function isSelectedMeasure(measure:XSMeasure):Boolean
		{
			var contains:Boolean = false;
			if ((measure.measureDimension.localRepresentation as CodeList).id ==
				_selectedAssociation.codeList.id && measure.code.id ==
				_selectedAssociation.code.id) {
				contains = true;
			}
			return contains; 
		}	
		
		protected function createReferenceColumn(measure:XSMeasure):DataGridColumn
		{
			var col:DataGridColumn = new DataGridColumn();
			col.width = 100;
			col.dataField = "measureDescription";
			col.headerText = measure.conceptIdentity.name.localisedStrings.
				getDescriptionByLocale("en");
			col.labelFunction = formatIndicator;
			return col;
		}
		
		/*=========================Private methods============================*/
		
		private function handleRollOver(event:ListEvent):void
		{
			var measure:String = event.itemRenderer.data.measure;
			var hasChildren:Boolean = false;
			if (null != _selectedAssociation) {
				for each (var assoc:CodeAssociation in 
					_selectedAssociation.children) {
					if (assoc.code.id == measure) {
						if (assoc.children.length > 0) {
							hasChildren = true						
						}
						break;
					}	
				}	
			}
			if (hasChildren) {
				CursorManager.setCursor(_drillDownCursor);
			}
		}
		
		private function handleRollOut(event:ListEvent):void
		{
			if (null != _selectedAssociation) {
				CursorManager.removeAllCursors();
			}
		}
		
		private function handleColumnHeaderReleased(
			event:DataGridEvent):void
		{
			event.preventDefault();
			_headerPressed = true;
			event.stopImmediatePropagation();
			_sortField = event.dataField;
			event = null;
			_sortDescending = (_sortDescending) ? false : true;
			triggerSort();
		}
		
		private function handleCheckCtrlClick(event:MouseEvent):void {
			event.stopImmediatePropagation();
			if (!_headerPressed) {
				var ev:XSMeasureSelectionEvent;
				if (null != _dispatchedEvent) {
					if (event.ctrlKey) {
						ev = new XSMeasureSelectionEvent(_dispatchedEvent.
							measure, true, _dispatchedEvent.type, 
							_dispatchedEvent.bubbles, _dispatchedEvent.
							cancelable);
					} else {
						ev = _dispatchedEvent;
					}
					dispatchEvent(ev);
				}
			} else {
				_headerPressed = false;
			}
		}
		
		private function handleUpLinkClicked(event:Event):void
		{
			selectedHierarchyItem = 
				_parentsAssoc[_selectedAssociation.code.id];
			dispatchEvent(new HierarchicalItemSelectedEvent("drillDown", 
				selectedHierarchyItem));
			event.stopImmediatePropagation();
			event = null;
		}
		
		private function setSortOrder(order:String):void
		{
			switch (order) {
				case XSSortOrder.SORT_SECTION_ORDER:
					_sortField = "dataSetOrder";
					_sortDescending = false; 
					break;
				case XSSortOrder.SORT_ASC_ORDER:
					_sortDescending = false;
					break;
				case XSSortOrder.SORT_DESC_ORDER: 
					_sortDescending = true;		
					break;
				default:
					throw new ArgumentError("Unknown sort order: " + order);
					break;	
			}	
		}	
	}
}