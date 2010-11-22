// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
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
	import eu.ecb.core.util.helper.EUCountries;
	
	import flash.events.DataEvent;
	
	import mx.charts.ChartItem;
	import mx.charts.LegendItem;
	import mx.charts.renderers.CircleItemRenderer;
	import mx.charts.series.ColumnSeries;
	import mx.containers.HBox;
	import mx.core.ClassFactory;
	import mx.graphics.IFill;
	import mx.graphics.SolidColor;
	
	import org.sdmx.model.v2.reporting.dataset.CodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.Section;
	import org.sdmx.model.v2.reporting.dataset.SectionsCollection;
	import org.sdmx.model.v2.reporting.dataset.UncodedXSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSDataSet;
	import org.sdmx.model.v2.reporting.dataset.XSGroup;
	import org.sdmx.model.v2.reporting.dataset.XSGroupsCollection;
	import org.sdmx.model.v2.reporting.dataset.XSObservation;
	import org.sdmx.model.v2.reporting.dataset.XSObservationsCollection;
	import org.sdmx.model.v2.structure.keyfamily.XSMeasure;
	
	/**
	 * A column chart containing cross-sectional data, with one column per 
	 * country of the European Union.
	 *  
	 * @author Xavier Sosnovsky
	 */
	public class EuropeanUnionXSBarChart extends XSBarChart
	{
		/*==============================Fields================================*/
		/**
		 * @private
		 */ 		
		protected var _euroAreaOnlyChanged:Boolean;
		
		private var _euCountries:EUCountries;
		private var _euroAreaLegend:LegendItem;
		private var _eUnionLegend:LegendItem;
		private var _sectionId:String;
		private var _euroAreaCode:String;
		private var _euCode:String;
		private var _euroAreaOnly:Boolean;
		private var _fullXSDataSet:XSDataSet;
		
		/*===========================Constructor==============================*/
		
		public function EuropeanUnionXSBarChart(direction:String="vertical", 
			chartLayout:String="vertical")
		{
			super(direction, chartLayout);
			_euCountries = new EUCountries();
			_euroAreaCode = "U2";	
			_euCode = "D0";
			_sortDescending = true;
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * The code used for the euro area (U2, I5, etc).
		 * 
		 * @param code 
		 */
		public function set euroAreaCode(code:String):void
		{
			_euroAreaCode = code;
		}
		
		/**
		 * The code used for the European Union (D0, V1, etc).
		 * 
		 * @param code 
		 */
		public function set euCode(code:String):void
		{
			_euCode = code;
		}
		
		/**
		 * Whether the chart should display euro area countries only.
		 */ 
		public function set euroAreaOnly(flag:Boolean):void
		{
			_euroAreaOnly = flag;
			if (null != _dataSet) {
				_dataSetChanged = true;
				commitProperties();
			}
		}
		
		/**
		 * Whether the fixed euro area composition should be used.
		 */ 
		public function set useFixedEuroAreaComposition(flag:Boolean):void
		{
			_euCountries.useFixedEuroAreaComposition = flag;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Handles the event that specifies whether only the euro area countries
		 * should be displayed. 
		 * 
		 * @param event 
		 */
		public function handleEuroAreaOnlyUpdated(event:DataEvent):void
		{
			var flag:Boolean = (event.data == "true") ? true : false;
			_euroAreaOnly = flag;
			_euroAreaOnlyChanged = true;
			commitProperties();
		}
		
		/*========================Protected methods===========================*/
		
		/**
		 * @inheritDoc
		 */ 
		override protected function createColumn(section:Section, 
			group:XSGroup):ColumnSeries
		{
			var column:ColumnSeries = super.createColumn(section, group);
			column.fillFunction = setColumnColor;
			return column;
		}		
		
		/**
		 * @inheritDoc
		 */
		override protected function displayData(obs:XSObservation):Boolean
		{
			var measure:XSMeasure = (obs is UncodedXSObservation) ? 
				(obs as UncodedXSObservation).measure :
				(obs as CodedXSObservation).measure;
			return _euCountries.belongsToEuropeanUnion(measure.code.id);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if (null == _legend) {
				var box:HBox = new HBox();
				box.percentWidth = 100;
				box.setStyle("horizontalAlign", "center");
				box.setStyle("paddingTop", 0);
				box.setStyle("paddingBottom", -10);
				box.setStyle("color", "#707070");
				addChild(box);
			
				_euroAreaLegend = new LegendItem();
				_euroAreaLegend.setStyle("legendMarkerRenderer", 
					new ClassFactory(mx.charts.renderers.CircleItemRenderer));
				var color1:SolidColor = new SolidColor(0x2C70AA);				
				_euroAreaLegend.setStyle("fill", color1);
				_euroAreaLegend.setStyle("fontWeight", "normal");
				_euroAreaLegend.visible = false;
				_euroAreaLegend.label = "euro area";
				box.addChild(_euroAreaLegend);
				
				_eUnionLegend = new LegendItem();
				_eUnionLegend.setStyle("legendMarkerRenderer", 
					new ClassFactory(mx.charts.renderers.CircleItemRenderer));
				var color2:SolidColor = new SolidColor(0xa6bddb);				
				_eUnionLegend.setStyle("fill", color2);
				_eUnionLegend.setStyle("fontWeight", "normal");
				_eUnionLegend.visible = false;
				box.addChild(_eUnionLegend);				
			}
			
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			var addAverageLines:Boolean = false;
			var section:Section;
			if (_dataSetChanged) {
				addAverageLines = true;
				if (_dataSet is XSDataSet && (_dataSet as XSDataSet).groups.
					length == 1 && ((_dataSet as XSDataSet).groups.getItemAt(0) 
					as XSGroup).sections.length == 1) {
					section = ((_dataSet as XSDataSet).groups.getItemAt(0) as 
						XSGroup).sections.getItemAt(0) as Section;		
					_sectionId = "value_" + section.keyValues.seriesKey.
						replace("\.", "_");
					sortField = _sectionId;		
				}
				_fullXSDataSet = _dataSet as XSDataSet;
				if (_euroAreaOnly) {
					_dataSet = createFilteredXSDataSet();
				}
			}
			
			if (_euroAreaOnlyChanged) {
				_euroAreaOnlyChanged = false;
				_dataSet = 
					_euroAreaOnly ? createFilteredXSDataSet() : _fullXSDataSet;
				_dataSetChanged = true;	
				addAverageLines = true;
				if (_dataSet is XSDataSet && (_dataSet as XSDataSet).groups.
					length == 1 && ((_dataSet as XSDataSet).groups.getItemAt(0) 
					as XSGroup).sections.length == 1) {
					section = ((_dataSet as XSDataSet).groups.getItemAt(0) as 
						XSGroup).sections.getItemAt(0) as Section;		
					_sectionId = "value_" + section.keyValues.seriesKey.
						replace("\.", "_");
					sortField = _sectionId;		
				}
			}
			
			super.commitProperties();
			
			if (addAverageLines && null != section) {
				var u2Obs:UncodedXSObservation = section.observations.
					getObsByCode(_euroAreaCode) as UncodedXSObservation;
				if (null != u2Obs) {	 
					addAverageLine(u2Obs.value,	0x2C70AA);
					_euroAreaLegend.label = "Euro area (" + u2Obs.value + 
						(_isPercentage ? "%" : "") + ")";
					_euroAreaLegend.visible = true;
				}
				
				var d0Obs:UncodedXSObservation = section.observations.
					getObsByCode(_euCode) as UncodedXSObservation;
				if (!_euroAreaOnly) {	
					if (null != d0Obs) {	 
						addAverageLine(d0Obs.value, 0xa6bddb);
						_eUnionLegend.label = "European Union (" + d0Obs.value + 
							(_isPercentage ? "%" : "") + ")";
						_eUnionLegend.visible = true;
					} else {
						_eUnionLegend.label = "European Union";
						_eUnionLegend.visible = true;
					}
					_eUnionLegend.width = NaN;
				} else {
					_eUnionLegend.visible = false;
					_eUnionLegend.width = 0;
				}
			}
		}
		
		/*=========================Private methods============================*/
		
		private function setColumnColor(element:ChartItem):IFill
		{
			var c:SolidColor = new SolidColor(0xa6bddb);
			if (_euCountries.belongsToEuroArea(element.item.measure, 
				_selectedDate)) {
				c.color = 0x2C70AA;
			}			
			c.alpha = 1.0;
	        return c;
		}
		
		private function createFilteredXSDataSet():XSDataSet 
		{
			var tmpDataSet:XSDataSet = new XSDataSet();
			tmpDataSet.groups = new XSGroupsCollection();
			var group:XSGroup = new XSGroup();
			group.keyValues = ((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).keyValues;
			tmpDataSet.groups.addItem(group);
			group.sections = new SectionsCollection();
			var section:Section = new Section();
			section.keyValues = (((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).sections.getItemAt(0) as 
				Section).keyValues;
			group.sections.addItem(section);
			section.observations = new XSObservationsCollection();
			for each (var obs:UncodedXSObservation in (((_dataSet as XSDataSet).
				groups.getItemAt(0) as XSGroup).sections.getItemAt(0) as 
				Section).observations) {
				if (_euCountries.belongsToEuroArea(obs.measure.code.id, 
					_selectedDate) || obs.measure.code.id == _euroAreaCode) {
					section.observations.addItem(obs);	
				}
			}
			return tmpDataSet;
		}
	}
}