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
package eu.ecb.core.view.chart
{
	import eu.ecb.core.event.HierarchicalItemSelectedEvent;
	import eu.ecb.core.event.XSMeasureSelectionEvent;
	import eu.ecb.core.util.formatter.datatip.IXSDataTipFormatter;
	import eu.ecb.core.util.formatter.section.ISectionTitleFormatter;
	import eu.ecb.core.util.formatter.xsobs.IXSObsTitleFormatter;
	import eu.ecb.core.util.helper.SeriesColors;
	import eu.ecb.core.view.IHierarchicalView;
	import eu.ecb.core.view.util.LinkUp;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.charts.AxisRenderer;
	import mx.charts.BarChart;
	import mx.charts.CategoryAxis;
	import mx.charts.ColumnChart;
	import mx.charts.HitData;
	import mx.charts.Legend;
	import mx.charts.LegendItem;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.charts.effects.SeriesInterpolate;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.renderers.CircleItemRenderer;
	import mx.charts.series.ColumnSeries;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.HBox;
	import mx.core.ClassFactory;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	import mx.managers.CursorManager;
	
	import org.sdmx.model.v2.reporting.dataset.CodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.KeyValue;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.SectionsCollection;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSObservation;
	import org.sdmx.model.v2.structure.code.CodeList;
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	import org.sdmx.model.v2.structure.keyfamily.XSMeasure;
	
	import qs.charts.effects.DrillDownEffect;
	import qs.charts.effects.DrillUpEffect;
	
	/**
	 * A bar chart containing cross-sectional data.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class XSBarChart extends ECBBarChart implements IHierarchicalView
	{
		/*==============================Fields================================*/
		
		/**
		 * @private
		 */
		protected var _obsFormatter:IXSObsTitleFormatter;
		
		/**
		 * @private
		 */
		protected var _dataTipFormatter:IXSDataTipFormatter;
		
		/**
		 * @private
		 */
		protected var _observationsMap:Object;
		
		/**
		 * @private
		 */
		protected var _measureMap:Object;
		
		/**
		 * @private
		 */ 
		protected var _groups:Object;
		 
		/**
		 * @private
		 */ 
		protected var _sections:Object; 
		
		/**
		 * @private
		 */
		protected var _observations:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _sortField:String;
		
		/**
		 * @private
		 */
		protected var _sortDescending:Boolean;
		
		/**
		 * @private
		 */
		protected var _dataCanvas:CartesianDataCanvas;
		
		/**
		 * @private
		 */
		protected var _sortMeasure:String;
		
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
		protected var _averageLines:ArrayCollection;
		
		/**
		 * @private
		 */
		protected var _legend:Legend;
		
		/**
		 * @private
		 */
		protected var _loadEffect:SeriesInterpolate;
		
		/**
		 * @private
		 */
		protected var _columns:Object;
		
		/**
		 * @private
		 */
		protected var _isVerticalMove:Boolean;
		
		/**
		 * @private
		 */
		protected var _drillDownEffect:DrillDownEffect;
		
		/**
		 * @private
		 */
		protected var _drillUpEffect:DrillUpEffect;

		private var _sectionFormatter:ISectionTitleFormatter;
		private var _upLink:LinkUp;
		private var _parentsAssoc:Object; 
		private var _effects:Object;
		private var _minimized:Object;
		private var _sort:Sort;
				
		/*===========================Constructor==============================*/
		
		public function XSBarChart(direction:String="vertical", 
			chartLayout:String="vertical")
		{
			super(direction, chartLayout);
			_parentsAssoc = new Object();
			_effects = new Object();
			_minimized = new Object();
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
		 * Sets the formatter for the data tip, when hovering over a column.
		 */
		public function set dataTipFormatter(
			formatter:IXSDataTipFormatter):void
		{
			if (null != formatter) {
				_dataTipFormatter = formatter;
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
		 * Whether or not the sort should follow the descending order.
		 */ 
		public function set sortDescending(flag:Boolean):void
		{
			_sortDescending = flag;
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
		
		/*==========================Public methods============================*/
		
		/**
		 * Adds an (horizontal) average line, with the yField value and color
		 * supplied.
		 */ 
		public function addAverageLine(value:String, color:uint):void {
			_dataCanvas.lineStyle(1, color);
	        _dataCanvas.moveTo(_observations.getItemAt(0)["measure"], value);
	        _dataCanvas.lineTo(_observations.getItemAt(_observations.length - 1)
	        	["measure"], value);
		}
		
		/**
		 * Handles the event triggering the sorting mechanism.
		 */ 
		public function handleSortUpdated(event:DataEvent):void 
		{
			switch (event.data) {
				case "sort0":
					_sortField = "dataSetOrder";
					_sortDescending = false; 
					break;
				case "sort1":
					_sortDescending = false;
					break;
				case "sort2": 
					_sortDescending = true;		
					break;
				default:
					break;	
			}	
			triggerSort();
		}
		
		/**
		 * @inheritDoc
	     */
		public function handleDrillDown(event:Event):void 
		{
			event.stopImmediatePropagation();
			if (event is ChartItemEvent) {
				_isVerticalMove = true;
				if (null == _drillDownEffect) {
					_drillDownEffect = new DrillDownEffect();
					_drillDownEffect.duration = 800;
				}
				_drillDownEffect.addEventListener(EffectEvent.EFFECT_END, 
					handleEffectEnd);
				_drillDownEffect.addEventListener(EffectEvent.EFFECT_END, 
					handleEffectEnd, true, 0, true);
				_drillDownEffect.drillFromIndex = 
					(event as ChartItemEvent).hitData.chartItem.index;
			
				for each (var column:ColumnSeries in _chart.series) {
					column.setStyle("showDataEffect", _drillDownEffect);
				}
				var measure:String = 
					(event as ChartItemEvent).hitData.item.measure;
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
					_parentsAssoc[(event as HierarchicalItemSelectedEvent).
						codeAssocation.code.id] = _selectedAssociation;
				}
				selectedHierarchyItem = 
					(event as HierarchicalItemSelectedEvent).codeAssocation;
			}
			event = null;
		}	
		
		/**
		 * Handles the event triggered when a movie functionality has started.
		 */ 
		public function handleMovieStarted(event:Event):void
		{
			dispatchEvent(new Event("minMaxValuesNeeded"));
		}
		
		/**
		 * Handles the even when a movie is stopped.
		 */ 
		public function handleMovieStopped(event:Event):void
		{
			minValue = NaN;
			maxValue = NaN;
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
	     */
		override protected function createChildren():void {
			if (null == _upLink) {
				_upLink = new LinkUp();
				_upLink.visible = false;
				_upLink.height = 0;
				_upLink.addEventListener(MouseEvent.CLICK, handleUpLinkClicked,
					false, 0, true);
				addChild(_upLink);
			}
			
			var box:HBox = new HBox();
			box.percentHeight = 100;
			box.percentWidth = 100;
			addChild(box);
			
			if (null == _chart) {
				_chart = ("vertical" == _chartLayout)	? 
					new ColumnChart() : new BarChart();
				_chart.styleName = "ecbBarChart";
				_chart.percentWidth = 100;
				_chart.percentHeight = 100;
				_chart.showDataTips = true;
				_chart.dataTipFunction = formatDataTip;
				_chart.selectionMode = "multiple";
				
				_chart.seriesFilters = new Array();
				
				var verticalAxis:LinearAxis = new LinearAxis();
				verticalAxis.baseAtZero = true;
				verticalAxis.labelFunction = formatYAxisLabel;
				_chart.verticalAxis = verticalAxis;
				
				var horizontalAxis:CategoryAxis = new CategoryAxis();
				horizontalAxis.labelFunction = formatAxisLabel;
				_chart.horizontalAxis = horizontalAxis;
				
				var stroke:Stroke = new Stroke();
				stroke.color = 0xEDEFF1;
				stroke.weight = 1;
				
				var verticalAxisRenderer:AxisRenderer = new AxisRenderer();
				verticalAxisRenderer.setStyle("axisStroke", stroke);
				verticalAxisRenderer.setStyle("tickStroke", stroke);
				verticalAxisRenderer.axis = verticalAxis;
				_chart.verticalAxisRenderers = [verticalAxisRenderer];
				
				var horizontalAxisRenderer:AxisRenderer = new AxisRenderer();	
				horizontalAxisRenderer.setStyle("axisStroke", stroke);
				horizontalAxisRenderer.setStyle("tickStroke", stroke);
				horizontalAxisRenderer.axis = horizontalAxis;
				horizontalAxisRenderer.styleName = "columnChartHorizontalAxis";	
				_chart.horizontalAxisRenderers = [horizontalAxisRenderer];
				
				
				(_chart.horizontalAxis as CategoryAxis).categoryField = 
					"measure";
				_chart.addEventListener(ChartItemEvent.ITEM_CLICK, 
					handleItemClicked);	
				_chart.addEventListener(ChartItemEvent.ITEM_DOUBLE_CLICK, 
					handleDrillDown);	
				_chart.addEventListener(ChartItemEvent.ITEM_ROLL_OVER, 
					handleRollOver);
				_chart.addEventListener(ChartItemEvent.ITEM_ROLL_OUT, 
					handleRollOut);	
			
				_dataCanvas = new CartesianDataCanvas();
				_dataCanvas.includeInRanges = true;
				_chart.annotationElements = [_dataCanvas];	
				
				box.addChild(_chart);
			}
			
			if (null == _legend) {
				_legend = new Legend();
				_legend.direction = "vertical";
				box.addChild(_legend);
			}
			
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override protected function commitProperties():void
		{
			if (_dataSetChanged) {
				if (!(_dataSet is XSDataSet)) {
					throw new ArgumentError("This cross-sectional view " + 
						"only accepts a XSDataSet as input");
				} else if ((_dataSet as XSDataSet).groups.length > 1) {
					throw new ArgumentError("This cross-sectional view cannot" + 
						" handle more than one period at a time");
				} else if ((_dataSet as XSDataSet).groups.length == 0) {
					throw new ArgumentError("No data to be displayed");
				} else if (((_dataSet as XSDataSet).groups.getItemAt(0) as 
					XSGroup).sections.length == 0 || (((_dataSet as XSDataSet).
					groups.getItemAt(0) as XSGroup).sections.getItemAt(0) as 
					Section).observations.length == 0) {
					throw new ArgumentError("No data to be displayed");	
				}
				_dataSetChanged = false;
				
				_observations = new ArrayCollection();
				_observationsMap = new Object();
				_measureMap = new Object();	
				_groups = new Object();
				_sections = new Object();
				_averageLines = new ArrayCollection();	
				_dataCanvas.clear();
				_legend.removeAllChildren();
				
				var group:XSGroup = (_dataSet as XSDataSet).groups
					.getItemAt(0) as XSGroup;	
					
				if (null != _columns) {
					for (var key:String in _columns) {
						var found:Boolean;
						for each (var section:Section in group.sections) {
							if (section.keyValues.seriesKey == key) {
								found = true;
								break;
							}
						}		
						if (!found && null != _columns[key]) {
							_columns[key] = null; 
						}
					}
				} else {
					_columns = new Object();
				}	
				
				var series:Array = new Array();		
				for each (var section:Section in group.sections) {
					series.push(createColumn(section, group));
				}						
				_chart.series = series;
				
				if (null != _sort) {
					triggerSort();
				}
				
				_chart.dataProvider = _observations;
				
				for each (var line:Object in _averageLines) {
					addAverageItem(line);
				}
			}
			
			if (_selectedDataSetChanged) {
				_selectedDataSetChanged = false;
				if (null != _selectedDataSet && 
					!(_selectedDataSet is XSDataSet)) {
					throw new ArgumentError("Should be a cross-sectional" + 
						" dataset");					
				}
				drawColumns();
			}
			
			if (_highlightedDataSetChanged) {
				_highlightedDataSetChanged = false;
				if (null != _highlightedDataSet && 
					!(_highlightedDataSet is XSDataSet)) {
					throw new ArgumentError("Should be a cross-sectional" + 
						" dataset");					
				}
				drawColumns();
			}
			
			if (_minValueChanged) {
				_minValueChanged = false;
				(_chart.verticalAxis as LinearAxis).minimum = _minValue;
			}
			
			if (_maxValueChanged) {
				_maxValueChanged = false;
				(_chart.verticalAxis as LinearAxis).maximum = _maxValue;
			}
		}
		
		/**
		 * Handles the creation of a column.
		 */ 
		protected function createColumn(section:Section, 
			group:XSGroup):ColumnSeries
		{
			var dataSetKey:String = (null == (_dataSet as XSDataSet).keyValues)?
				"" : (_dataSet as XSDataSet).keyValues.seriesKey.
				replace("\.", "_");
			var groupKey:String = (null == group.keyValues)? 
				"" : group.keyValues.seriesKey.replace("\.", "_");
			if (!(_groups.hasOwnProperty("group_" + groupKey))) {
				_groups["group_" + groupKey] = group;
			}				
			var sectionKey:String = (null == section.keyValues)? 
				"" : section.keyValues.seriesKey.replace("\.", "_");
			if (!(_sections.hasOwnProperty("section_" + sectionKey))) {
				_sections["section_" + sectionKey] = section;
			}	
			var sectionId:String = "value_" + sectionKey;	
			if (null == _sortMeasure) {
				_sortField = sectionId;
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
					if (displayData(obs)) {	
						var value:String = 	(obs is UncodedXSObservation) ? 
							(obs as UncodedXSObservation).value :
							(obs as CodedXSObservation).value.id;
						
						var o:Object;						
						if (!(_measureMap.hasOwnProperty(measure.code.id))) {	
							o = new Object();
							o["measure"] = measure.code.id;
							o["measureDescription"] = measure.code.description.
								localisedStrings.getDescriptionByLocale("en");
							_measureMap[measure.code.id] = o;
							o["dataSetOrder"] = i;
							_observations.addItem(o);	
						} else {
							o = _measureMap[measure.code.id];
						}		
						o[sectionId] = value;	
						
						var holder:Object = new Object();
						holder["obsData"] = o;
						holder["xsMeasure"] = measure;
						holder["xsObs"] = obs;
						holder["section"] = sectionKey;
						holder["group"] = groupKey;
						var obsKey:String = (obs.keyValues == null) ? 
							"" : obs.keyValues.seriesKey.replace("\.", "_");
						holder["obsKey"] = dataSetKey + "_" + groupKey + "_" + 
							sectionKey + "_" + obsKey;
						_observationsMap[sectionId + "_" + measure.code.id] = 
							holder;
					}
				} else if (isSelectedMeasure(measure)) {
					if (null == _averageLines) {
						_averageLines = new ArrayCollection();
					}
					_averageLines.addItem({"value": value, 
						"color": solidColorSelected.color, 
						"label": (section.keyValues.getItemAt(0) as 
							KeyValue).value.description.localisedStrings
							.getDescriptionByLocale("en")});
				}
			}
			
			var solidColorSelected:SolidColor = new SolidColor();
			var sectionIndex:int = ((_dataSet as XSDataSet).groups.getItemAt(0)
				as XSGroup).sections.getItemIndex(section); 
			solidColorSelected.color = 
				(SeriesColors.getColors().length > sectionIndex) ?
					SeriesColors.getColors().getItemAt(sectionIndex) as uint : 
					Math.round( Math.random()*0xFFFFFF );
			solidColorSelected.alpha = .9;
			
			var column:ColumnSeries;
			if (!(_columns.hasOwnProperty(sectionKey)) || 
				null == _columns[sectionKey]) {
				if (null == _loadEffect) {
					_loadEffect = new SeriesInterpolate();
					_loadEffect.duration = 800;
					_loadEffect.minimumElementDuration = 200;
					_loadEffect.elementOffset = 0;
				}
				column = new ColumnSeries();
				column.xField = "measure";
				column.yField = sectionId;
				column.displayName = getHeaderText(section);
				column.setStyle("fill", solidColorSelected);
				column.setStyle("showDataEffect", _loadEffect);
				_columns[sectionKey] = column;
			} else {
				column = _columns[sectionKey];
				column.displayName = getHeaderText(section);
				column.setStyle("fill", solidColorSelected);
				if (!_isVerticalMove) {
					column.setStyle("showDataEffect", null);
				}
			}	
			column.dataProvider = _observations;
			return column;
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
				title = "Series " + ((_dataSet as XSDataSet).groups.getItemAt(0) 
					as XSGroup).sections.getItemIndex(section);
			}
			return title;
		}
		
		/**
		 * Formats the data tip when hovering over a chart item.
		 */ 
		override protected function formatDataTip(data:HitData):String 
		{
			var dataTip:String;
			if ((null == _drillDownEffect || (null != _drillDownEffect && 
				!(_drillDownEffect.isPlaying))) && (null == _drillUpEffect || (
				_drillUpEffect != null && !(_drillUpEffect.isPlaying)))) {
				var sectionId:String = (data.element as ColumnSeries).yField;
				if (null != _dataTipFormatter) {
					var obs:Object = _observationsMap[sectionId + "_" + 
						data.item["measure"]];
					_dataTipFormatter.group = _groups["group_" + obs.group];
					_dataTipFormatter.section = 
						_sections["section_" + obs.section];
					_dataTipFormatter.observation = obs.xsObs; 
					dataTip = _dataTipFormatter.format();
				} else {
					dataTip = data.item["measureDescription"] + ": " + String(
		    			ColumnSeriesItem(data.chartItem).yValue) + 
		    			((_isPercentage) ? "%" : "");
				}
			}
    		return dataTip;
		}
		
		/**
		 * Formats the labels for the horizontal axis.
		 */
		protected function formatAxisLabel(labelValue:Object, 
			previousLabelValue:Object, axis:CategoryAxis, 
			labelItem:Object):String
		{
			var axisLabel:String;
			var sectionId:String;
			for (var key:String in labelItem) {
				if (key != "measure" && key != "measureDescription" && 
					key != "dataSetOrder") {
					sectionId = key;
					break;
				}
			} 
			if (null != _obsFormatter) {
				axisLabel = _obsFormatter.getXSObsTitle(
					_observationsMap[sectionId + "_" + labelValue as String]
						["xsObs"] as XSObservation);
			} else {
				axisLabel = _observationsMap[sectionId + "_" + labelValue as 
					String]["obsData"]["measureDescription"] + " "; 
			}
			return axisLabel;
		}	
		
		/**
		 * This method allows subclasses to filter out data. As not filters are
		 * applied in the base class, the method simply returns true. 
		 */
		protected function displayData(obs:XSObservation):Boolean
		{
			return true;
		}
		
		/**
		 * Handles the selection of a cross-sectional measure.
		 */
		protected function handleItemClicked(event:ChartItemEvent):void
		{
			event.stopImmediatePropagation();
			var sectionId:String = 
				(event.hitData.element as ColumnSeries).yField;
			dispatchEvent(new XSMeasureSelectionEvent(
				_observationsMap[sectionId + "_" + event.hitData.
				item["measure"]]["xsMeasure"], event.ctrlKey || (event.
				currentTarget as ColumnChart).selectedChartItems.length > 1, 
				"measureSelected"));
			event = null;
		}
		
		/**
		 * Triggers the sorting mechanism on the data displayed in the graph. 
		 */ 
		protected function triggerSort():void 
		{
			if (null == _sort) {
				_sort = new Sort();
			}
			_sort.fields = 
				[new SortField(_sortField, true, _sortDescending, true)];
			_observations.sort = _sort;
			_observations.refresh();
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
		
		/**
		 * Adds an item in the collection of average lines displayed on the 
		 * graph.
		 */ 
		protected function addAverageItem(avg:Object):void
		{
			addAverageLine(avg.value, avg.color);	
			var item:LegendItem = new LegendItem();
			item.setStyle("legendMarkerRenderer", 
				new ClassFactory(mx.charts.renderers.CircleItemRenderer));
			var color:SolidColor = new SolidColor(avg.color);				
			item.setStyle("fill", color);
			item.label = avg.label + " (" + avg.value + 
				(_isPercentage ? "%" : "") + ")";
			_legend.addChild(item);
		}	
		
		/**
		 * Gets the selected sections in the cross-sectional dataset.
		 */ 
		protected function getSelectedSections(ds:XSDataSet, 
	    	sections:ArrayCollection):void
	    {
	       	if (null != ds) {
	    		var coll:SectionsCollection = 
	    			(ds.groups.getItemAt(0) as XSGroup).sections;
				for each (var section:Section in coll) {
					var sectionKey:String = (null == section.keyValues)? 
						"" : section.keyValues.seriesKey.replace("\.", "_");
					var sectionId:String = "value_" + sectionKey;	
					if (!(sections.contains(sectionId))) {
						sections.addItem(sectionId);
					}
				}
	       	}
	    }	
	    
	    /*=========================Private methods============================*/
		
		private function handleRollOver(event:ChartItemEvent):void
		{
			var measure:String = event.hitData.item.measure;
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
		
		private function handleRollOut(event:ChartItemEvent):void
		{
			if (null != _selectedAssociation) {
				CursorManager.removeAllCursors();
			}
		}
		
		private function handleUpLinkClicked(event:Event):void
		{
			_isVerticalMove = true;
			if (null == _drillUpEffect) {
				_drillUpEffect = new DrillUpEffect();
				_drillUpEffect.duration = 800;
			}
			_drillUpEffect.addEventListener(EffectEvent.EFFECT_END, 
				handleEffectEnd);
			_drillUpEffect.addEventListener(EffectEvent.EFFECT_END, 
				handleEffectEnd, true, 0, true);	
			if (null != _drillDownEffect) {
				_drillUpEffect.drillToIndex = _drillDownEffect.drillFromIndex;
				for each (var column:ColumnSeries in _chart.series) {
					column.setStyle("showDataEffect", _drillUpEffect);
				}
			}
			
			selectedHierarchyItem = 
				_parentsAssoc[_selectedAssociation.code.id];
			dispatchEvent(new HierarchicalItemSelectedEvent("drillDown", 
				selectedHierarchyItem));
			event.stopImmediatePropagation();
			event = null;
		}
		
		private function drawColumns():void
		{
			var selSections:ArrayCollection = new ArrayCollection();
			getSelectedSections(_selectedDataSet as XSDataSet, selSections);
			getSelectedSections(_highlightedDataSet as XSDataSet, selSections);
			
			for each (var col:ColumnSeries in _chart.series) {
				if (selSections.length > 0 &&
					!(selSections.contains(col.yField))) {
					if (!(_minimized.hasOwnProperty(col.yField)) || 
						!_minimized[col.yField]) {	
						playEffect(col, false);
						_minimized[col.yField] = true;
					}
				} else if (selSections.length > 0) {
					if (_minimized.hasOwnProperty(col.yField) 
						&& _minimized[col.yField]) {
						playEffect(col, true);
						_minimized[col.yField] = false;
					}
				} else {
					if (_minimized.hasOwnProperty(col.yField) && 
						_minimized[col.yField]) {
						playEffect(col, true);
						_minimized[col.yField] = false;
					}
				}
			}
		}
		
		private function createEffect():Effect {
	    	var z:Fade = new Fade();
	    	z.alphaFrom = 1;
	    	z.alphaTo   = 0.3; 
	    	z.duration  = 600;
	    	return z;
	    } 
    
	    private function playEffect(target:ColumnSeries, reverse:Boolean):void {      
	    	var effect:Effect = _effects[target];
	    	if (effect == null) {
	        	effect = createEffect();         
	        	_effects[target] = effect;
	      	}
	      	if (effect.isPlaying) {
		        effect.reverse();
		    } else {
	    	    effect.play([target], reverse);
			}
	    }
	    
	    private function handleEffectEnd(event:EffectEvent):void
		{
			_isVerticalMove = false;
			for each (var column:ColumnSeries in _chart.series) {
				column.setStyle("showDataEffect", _loadEffect);
			}
		}	
	}
}